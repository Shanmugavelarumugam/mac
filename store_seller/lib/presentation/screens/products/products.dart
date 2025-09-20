import 'package:btc_store/data/models/product_model.dart';
import 'package:btc_store/data/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductsScreen extends StatefulWidget {
  final String? token;
  final int? sellerId;

  const ProductsScreen({super.key, this.token, this.sellerId});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late ProductRepository repository;
  List<Product> products = [];
  bool isLoading = true;
  String searchQuery = '';
  String? selectedCategory;
  String? statusFilter;
  bool _isGridView = true;
  int _currentPage = 1;
  static const int _itemsPerPage = 10;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    String? token = widget.token;
    int? sellerId = widget.sellerId;

    if (token == null || sellerId == null) {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('auth_token');
      sellerId = prefs.getInt('user_id');
    }

    if (token == null || sellerId == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
      return;
    }

    repository = ProductRepository(token: token);
    _fetchProducts(sellerId);
  }

  Future<void> _fetchProducts(int sellerId) async {
    setState(() => isLoading = true);
    try {
      final fetchedProducts = await repository.getProductsBySeller(sellerId);
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to fetch products: $e',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: const Color(0xFFF44336),
          ),
        );
      }
    }
  }

  List<Product> get filteredProducts {
    return products.where((product) {
      final matchesSearch =
          product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (product.sku?.toLowerCase().contains(searchQuery.toLowerCase()) ??
              false);

      final matchesCategory =
          selectedCategory == null ||
          selectedCategory == 'All' ||
          product.category == selectedCategory;

      final matchesStatus =
          statusFilter == null ||
          statusFilter == 'All' ||
          _getProductStatus(product) == statusFilter;

      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();
  }

  List<Product> get paginatedProducts {
    final filtered = filteredProducts;
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, filtered.length);
    return filtered.sublist(startIndex, endIndex);
  }

  int get totalPages {
    return (filteredProducts.length / _itemsPerPage).ceil();
  }

  String _getProductStatus(Product product) {
    if (!product.isAvailable) return 'Inactive';
    if (product.stock == 0) return 'Out of Stock';
    return 'Active';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return const Color(0xFF10B981);
      case 'Inactive':
        return const Color(0xFFF59E0B);
      case 'Out of Stock':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  Future<void> _confirmDelete(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Product', style: GoogleFonts.poppins()),
        content: Text(
          'Are you sure you want to delete "${product.name}"?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
            ),
            child: Text('Delete', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await repository.deleteProduct(product.id!);
        if (widget.sellerId != null) {
          _fetchProducts(widget.sellerId!);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Product deleted successfully',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to delete product: $e',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.8,
        expand: false,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(16.0),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Filters',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildFiltersSection(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'My Products',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF3B82F6),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
              color: Colors.white,
            ),
            onPressed: () => setState(() => _isGridView = !_isGridView),
            tooltip: _isGridView ? 'List View' : 'Grid View',
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
              ),
            )
          : Column(
              children: [
                // Modern Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search products...',
                            hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF94A3B8),
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: Color(0xFF3B82F6),
                            ),
                            suffixIcon: searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear_rounded,
                                      color: Color(0xFF94A3B8),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        searchQuery = '';
                                        _searchController.clear();
                                        _currentPage = 1;
                                      });
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF1F5F9),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                            ),
                          ),
                          style: GoogleFonts.poppins(),
                          onChanged: (value) => setState(() {
                            searchQuery = value;
                            _currentPage = 1;
                          }),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(
                          Icons.filter_list_rounded,
                          color: Color(0xFF3B82F6),
                        ),
                        onPressed: _showFilterBottomSheet,
                        tooltip: 'Filters',
                      ),
                    ],
                  ),
                ),

                // Results count
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${filteredProducts.length} products found',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF64748B),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      if (totalPages > 1)
                        Text(
                          'Page $_currentPage of $totalPages',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF94A3B8),
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),

                // Products Content
                Expanded(
                  child: filteredProducts.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: () => _fetchProducts(widget.sellerId!),
                          color: const Color(0xFF3B82F6),
                          child: _isGridView
                              ? _buildGridView(screenWidth, isLandscape)
                              : _buildListView(),
                        ),
                ),

                // Pagination
                if (totalPages > 1) _buildPagination(),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add-product').then((_) {
            if (widget.sellerId != null) {
              _fetchProducts(widget.sellerId!);
            }
          });
        },
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text('Add Product', style: GoogleFonts.poppins()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildFiltersSection() {
    final categories = ['All', ...products.map((p) => p.category).toSet()];
    final statuses = ['All', 'Active', 'Inactive', 'Out of Stock'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final isSelected =
                selectedCategory == category ||
                (selectedCategory == null && category == 'All');
            return FilterChip(
              label: Text(category, style: GoogleFonts.poppins()),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  selectedCategory = category == 'All' ? null : category;
                  _currentPage = 1;
                });
              },
              backgroundColor: const Color(0xFFF1F5F9),
              selectedColor: const Color(0xFF3B82F6).withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected
                    ? const Color(0xFF3B82F6)
                    : const Color(0xFF64748B),
              ),
              checkmarkColor: const Color(0xFF3B82F6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Text(
          'Status',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: statuses.map((status) {
            final isSelected =
                statusFilter == status ||
                (statusFilter == null && status == 'All');
            return FilterChip(
              label: Text(status, style: GoogleFonts.poppins()),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  statusFilter = status == 'All' ? null : status;
                  _currentPage = 1;
                });
              },
              backgroundColor: const Color(0xFFF1F5F9),
              selectedColor: const Color(0xFF3B82F6).withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected
                    ? const Color(0xFF3B82F6)
                    : const Color(0xFF64748B),
              ),
              checkmarkColor: const Color(0xFF3B82F6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedCategory = null;
                  statusFilter = null;
                  _currentPage = 1;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE2E8F0),
                foregroundColor: const Color(0xFF1E293B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Clear',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Apply',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            searchQuery.isNotEmpty ||
                    selectedCategory != null ||
                    statusFilter != null
                ? Icons.search_off_rounded
                : Icons.inventory_2_outlined,
            size: 100,
            color: const Color(0xFFE2E8F0),
          ),
          const SizedBox(height: 16),
          Text(
            searchQuery.isNotEmpty ||
                    selectedCategory != null ||
                    statusFilter != null
                ? 'No products found'
                : 'No products yet',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isNotEmpty ||
                    selectedCategory != null ||
                    statusFilter != null
                ? 'Try adjusting your search or filters'
                : 'Add your first product to get started',
            style: GoogleFonts.poppins(
              color: const Color(0xFF94A3B8),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  void _navigateToEditProduct(BuildContext context, Product product) async {
    final result = await Navigator.pushNamed(
      context,
      '/edit-product',
      arguments: product,
    );

    // Refresh the products list if we returned from editing
    if (result == true && widget.sellerId != null) {
      _fetchProducts(widget.sellerId!);
    }
  }

  Widget _buildGridView(double screenWidth, bool isLandscape) {
    int crossAxisCount = 2;
    if (screenWidth > 600) crossAxisCount = 3;
    if (isLandscape) crossAxisCount += 1;

   return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.46,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: paginatedProducts.length,
      itemBuilder: (_, index) {
        final product = paginatedProducts[index];
        return ProductCard(
          product: product,
          isGridView: true,
          onEdit: () =>
              _navigateToEditProduct(context, product), // ✅ reuse method
          onDelete: () => _confirmDelete(product),
        );
      },
    );

  }

  Widget _buildListView() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: paginatedProducts.length,
      itemBuilder: (_, index) {
        final product = paginatedProducts[index];
        return ProductCard(
          product: product,
          isGridView: false,
          onEdit: () =>
              Navigator.pushNamed(
                context,
                '/edit-product',
                arguments: product,
              ).then((_) {
                if (widget.sellerId != null) {
                  _fetchProducts(widget.sellerId!);
                }
              }),
          onDelete: () => _confirmDelete(product),
        );
      },
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 1
                ? () {
                    setState(() => _currentPage--);
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: Color(0xFF3B82F6),
            ),
          ),
          ...List.generate(totalPages, (index) {
            final pageNumber = index + 1;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () {
                  setState(() => _currentPage = pageNumber);
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: _currentPage == pageNumber
                      ? const Color(0xFF3B82F6)
                      : Colors.transparent,
                  child: Text(
                    '$pageNumber',
                    style: GoogleFonts.poppins(
                      color: _currentPage == pageNumber
                          ? Colors.white
                          : const Color(0xFF3B82F6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),
          IconButton(
            onPressed: _currentPage < totalPages
                ? () {
                    setState(() => _currentPage++);
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
            icon: const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF3B82F6),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isGridView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.isGridView,
    required this.onEdit,
    required this.onDelete,
  });

  String _getProductStatus() => product.isAvailable
      ? (product.stock == 0 ? 'Out of Stock' : 'Active')
      : 'Inactive';

  Color _getStatusColor() {
    switch (_getProductStatus()) {
      case 'Active':
        return const Color(0xFF10B981);
      case 'Inactive':
        return const Color(0xFFF59E0B);
      case 'Out of Stock':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isGridView ? _buildGridCard(context) : _buildListCard(context);
  }

  Widget _buildGridCard(BuildContext context) {
    final discountedPrice = product.discount != null && product.discount! > 0
        ? product.price - (product.price * product.discount! / 100)
        : product.price;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(),
          _buildContentSection(discountedPrice, context, screenWidth),
        ],
      ),
    );
  }

  Widget _buildListCard(BuildContext context) {
    final discountedPrice = product.discount != null && product.discount! > 0
        ? product.price - (product.price * product.discount! / 100)
        : product.price;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: _buildImageSection()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildContentSection(
                discountedPrice,
                context,
                screenWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: _buildProductImage(),
          ),
          Positioned(
            top: 8,
            left: 8,
            right: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (product.discount != null && product.discount! > 0)
                  _buildDiscountBadge(),
                _buildStatusBadge(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
        ),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF4444).withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '${product.discount!.toInt()}% OFF',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final status = _getProductStatus();
    final color = _getStatusColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        status,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildContentSection(
    double discountedPrice,
    BuildContext context,
    double screenWidth,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: screenWidth > 400 ? 14 : 13,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              product.category,
              style: GoogleFonts.poppins(
                color: const Color(0xFF64748B),
                fontSize: screenWidth > 400 ? 10 : 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: screenWidth > 400 ? 12 : 11,
                    color: product.stock > 10
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${product.stock} in stock',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth > 400 ? 11 : 10,
                      fontWeight: FontWeight.w600,
                      color: product.stock > 10
                          ? const Color(0xFF10B981)
                          : const Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: const Color(0xFFFBBF24),
                    size: screenWidth > 400 ? 12 : 11,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    product.averageRating?.toStringAsFixed(1) ?? 'N/A',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF64748B),
                      fontSize: screenWidth > 400 ? 11 : 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '\$${discountedPrice.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth > 400 ? 16 : 15,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  if (product.discount != null && product.discount! > 0) ...[
                    const SizedBox(width: 6),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF94A3B8),
                        fontSize: screenWidth > 400 ? 12 : 11,
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
              if (product.discount != null && product.discount! > 0)
                Text(
                  'Save \$${((product.price - discountedPrice)).toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF10B981),
                    fontSize: screenWidth > 400 ? 10 : 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Edit',
                  const Color(0xFF3B82F6),
                  onEdit,
                  screenWidth < 400,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  'Delete',
                  const Color(0xFFEF4444),
                  onDelete,
                  screenWidth < 400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    Color color,
    VoidCallback onPressed,
    bool isSmall,
  ) {
    return SizedBox(
      height: isSmall ? 28 : 32,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          foregroundColor: color,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isSmall ? 10 : 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    if (product.image.isEmpty || product.image == "jssks.png") {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
          ),
        ),
        child: const Center(
          child: Icon(Icons.image_outlined, size: 28, color: Color(0xFF94A3B8)),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: product.image,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFEF2F2), Color(0xFFFEE2E2)],
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFEF4444),
            size: 24,
          ),
        ),
      ),
    );
  }
}
