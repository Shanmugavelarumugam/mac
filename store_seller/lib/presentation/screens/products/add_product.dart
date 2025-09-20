import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:btc_store/bloc/product/product_bloc.dart';
import 'package:btc_store/bloc/product/product_event.dart';
import 'package:btc_store/bloc/product/product_state.dart';
import 'package:btc_store/data/models/product_model.dart';

class AddProductScreen extends StatefulWidget {
  final ProductBloc productBloc;
  const AddProductScreen({super.key, required this.productBloc});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Controllers
  final _nameController = TextEditingController();
  final _slugController = TextEditingController();
  final _shortDescController = TextEditingController();
  final _descController = TextEditingController();
  final _imageController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _skuController = TextEditingController();
  final _categoryController = TextEditingController();
  final _subcategoryController = TextEditingController();
  final _brandIdController = TextEditingController();
  final _createdByController = TextEditingController();
  final _discountController = TextEditingController();
  final _taglineController = TextEditingController();

  bool _isAvailable = true;
  bool _isFeatured = false;

  // Step configuration
  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Basic Info',
      'icon': Icons.info_outline,
      'color': Colors.blue,
      'gradient': [Color(0xFF4364F7), Color(0xFF6FB1FC)],
    },
    {
      'title': 'Pricing',
      'icon': Icons.attach_money,
      'color': Colors.green,
      'gradient': [Color(0xFF0BA360), Color(0xFF3CBA92)],
    },
    {
      'title': 'Media & Category',
      'icon': Icons.category,
      'color': Colors.orange,
      'gradient': [Color(0xFFFF8008), Color(0xFFFFC837)],
    },
    {
      'title': 'Settings',
      'icon': Icons.settings,
      'color': Colors.purple,
      'gradient': [Color(0xFF834D9B), Color(0xFFD04ED6)],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.3, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 768;
    final isDesktop = size.width > 1024;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF121212) : Color(0xFFF8FAFC),
      appBar: _buildAppBar(context, isDarkMode),
      body: BlocListener<ProductBloc, ProductState>(
        bloc: widget.productBloc,
        listener: (context, state) {
          if (state is ProductOperationSuccess) {
            setState(() => _isLoading = false);
            _showSuccessDialog(context);
          } else if (state is ProductError) {
            setState(() => _isLoading = false);
            _showErrorSnackbar(context, state.message);
          } else if (state is ProductLoading) {
            setState(() => _isLoading = true);
          }
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              _buildStepProgress(context, isDarkMode),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop
                        ? 48
                        : isTablet
                        ? 32
                        : 16,
                    vertical: 16,
                  ),
                  child: Form(
                    key: _formKey,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Step Header
                            _buildStepHeader(context, isDarkMode),
                            const SizedBox(height: 24),

                            // Step Content
                            Expanded(
                              child: _buildStepContent(
                                isTablet,
                                isDesktop,
                                isDarkMode,
                              ),
                            ),

                            // Step Indicators
                            _buildStepIndicators(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _buildNavigationButtons(context, size, isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDarkMode) {
    return AppBar(
      title: const Text(
        'Add New Product',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
      ),
      centerTitle: false,
      elevation: 0,
      backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
      foregroundColor: isDarkMode ? Colors.white : Colors.black87,
      systemOverlayStyle: isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      actions: [
        IconButton(
          icon: Icon(Icons.help_outline, size: 24),
          onPressed: () => _showHelpDialog(context),
        ),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _buildStepProgress(BuildContext context, bool isDarkMode) {
    final stepGradient = LinearGradient(
      colors: _steps[_currentStep]['gradient'],
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Progress bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey[300],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final progress = (_currentStep + 1) / _steps.length;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: constraints.maxWidth * progress,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: stepGradient,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Step indicators
          Row(
            children: List.generate(_steps.length, (index) {
              final isActive = index == _currentStep;
              final isCompleted = index < _currentStep;
              final step = _steps[index];
              final stepGradient = LinearGradient(colors: step['gradient']);

              return Expanded(
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: isActive ? 42 : 36,
                      height: isActive ? 42 : 36,
                      decoration: BoxDecoration(
                        gradient: isCompleted || isActive ? stepGradient : null,
                        color: isCompleted || isActive
                            ? null
                            : Colors.grey[300],
                        shape: BoxShape.circle,
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: (step['color'] as Color).withOpacity(
                                    0.4,
                                  ),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        isCompleted ? Icons.check : step['icon'],
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        fontSize: isActive ? 13 : 12,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isActive || isCompleted
                            ? step['color']
                            : Colors.grey[600],
                      ),
                      child: Text(
                        step['title'],
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStepHeader(BuildContext context, bool isDarkMode) {
    final step = _steps[_currentStep];
    final gradient = LinearGradient(colors: step['gradient']);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (step['color'] as Color).withOpacity(0.15),
            (step['color'] as Color).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (step['color'] as Color).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: (step['color'] as Color).withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(step['icon'], color: Colors.white, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step['title'],
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Step ${_currentStep + 1} of ${_steps.length}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(bool isTablet, bool isDesktop, bool isDarkMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
      child: Padding(
        padding: EdgeInsets.all(
          isDesktop
              ? 32
              : isTablet
              ? 24
              : 20,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: _getCurrentStepWidget(isTablet, isDesktop, isDarkMode),
        ),
      ),
    );
  }

  Widget _buildStepIndicators() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_steps.length, (index) {
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;
          final step = _steps[index];

          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 28 : 12,
            height: 6,
            decoration: BoxDecoration(
              color: isCompleted || isActive ? step['color'] : Colors.grey[300],
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
      ),
    );
  }

  Widget _getCurrentStepWidget(bool isTablet, bool isDesktop, bool isDarkMode) {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep(isTablet, isDesktop, isDarkMode);
      case 1:
        return _buildPricingStep(isTablet, isDesktop, isDarkMode);
      case 2:
        return _buildMediaCategoryStep(isTablet, isDesktop, isDarkMode);
      case 3:
        return _buildSettingsStep(isDarkMode);
      default:
        return const SizedBox();
    }
  }

  Widget _buildBasicInfoStep(bool isTablet, bool isDesktop, bool isDarkMode) {
    final column = Column(
      children: [
        _buildAnimatedTextField(
          controller: _nameController,
          label: 'Product Name',
          icon: Icons.shopping_bag_outlined,
          isRequired: true,
          delay: 100,
        ),
        const SizedBox(height: 20),
        _buildAnimatedTextField(
          controller: _slugController,
          label: 'Slug',
          icon: Icons.link,
          hintText: 'Auto-generated if empty',
          delay: 200,
        ),
        const SizedBox(height: 20),
        _buildAnimatedTextField(
          controller: _shortDescController,
          label: 'Short Description',
          icon: Icons.short_text,
          isRequired: true,
          maxLines: 2,
          delay: 300,
        ),
        const SizedBox(height: 20),
        _buildAnimatedTextField(
          controller: _descController,
          label: 'Full Description',
          icon: Icons.description,
          isRequired: true,
          maxLines: 4,
          delay: 400,
        ),
      ],
    );

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: column),
          SizedBox(width: 24),
          Expanded(
            child: Column(
              children: [
                _buildHelpCard(
                  icon: Icons.lightbulb_outline,
                  title: "Naming Tips",
                  content:
                      "Use descriptive names that include key features and benefits. Keep it under 60 characters for best display.",
                  color: Colors.amber,
                  isDarkMode: isDarkMode,
                ),
                SizedBox(height: 20),
                _buildHelpCard(
                  icon: Icons.description,
                  title: "Description Best Practices",
                  content:
                      "Start with the most important information. Use bullet points for features. Include dimensions, materials, and usage instructions.",
                  color: Colors.blue,
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return column;
  }

  Widget _buildPricingStep(bool isTablet, bool isDesktop, bool isDarkMode) {
    final priceFields = isTablet || isDesktop
        ? Row(
            children: [
              Expanded(
                child: _buildAnimatedTextField(
                  controller: _priceController,
                  label: 'Price (₹)',
                  icon: Icons.attach_money,
                  isRequired: true,
                  isNumber: true,
                  delay: 100,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildAnimatedTextField(
                  controller: _stockController,
                  label: 'Stock Quantity',
                  icon: Icons.inventory_2,
                  isRequired: true,
                  isNumber: true,
                  delay: 200,
                ),
              ),
            ],
          )
        : Column(
            children: [
              _buildAnimatedTextField(
                controller: _priceController,
                label: 'Price (₹)',
                icon: Icons.attach_money,
                isRequired: true,
                isNumber: true,
                delay: 100,
              ),
              const SizedBox(height: 20),
              _buildAnimatedTextField(
                controller: _stockController,
                label: 'Stock Quantity',
                icon: Icons.inventory_2,
                isRequired: true,
                isNumber: true,
                delay: 200,
              ),
            ],
          );

    final column = Column(
      children: [
        priceFields,
        const SizedBox(height: 20),
        _buildAnimatedTextField(
          controller: _skuController,
          label: 'SKU',
          icon: Icons.confirmation_number,
          delay: 300,
        ),
        const SizedBox(height: 20),
        _buildAnimatedTextField(
          controller: _discountController,
          label: 'Discount (%)',
          icon: Icons.discount,
          isNumber: true,
          delay: 400,
        ),
      ],
    );

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: column),
          SizedBox(width: 24),
          Expanded(
            child: Column(
              children: [
                _buildHelpCard(
                  icon: Icons.attach_money,
                  title: "Pricing Strategy",
                  content:
                      "Consider competitor pricing, perceived value, and your profit margins. Psychological pricing (e.g., ₹999 instead of ₹1000) can increase sales.",
                  color: Colors.green,
                  isDarkMode: isDarkMode,
                ),
                SizedBox(height: 20),
                _buildHelpCard(
                  icon: Icons.trending_up,
                  title: "Discount Tips",
                  content:
                      "Limited-time discounts create urgency. Consider tiered discounts for bulk purchases. Display original price alongside discounted price.",
                  color: Colors.purple,
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return column;
  }

  Widget _buildMediaCategoryStep(
    bool isTablet,
    bool isDesktop,
    bool isDarkMode,
  ) {
    final categoryFields = isTablet || isDesktop
        ? Row(
            children: [
              Expanded(
                child: _buildAnimatedTextField(
                  controller: _categoryController,
                  label: 'Category',
                  icon: Icons.category,
                  isRequired: true,
                  delay: 200,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildAnimatedTextField(
                  controller: _subcategoryController,
                  label: 'Subcategory',
                  icon: Icons.category_outlined,
                  delay: 300,
                ),
              ),
            ],
          )
        : Column(
            children: [
              _buildAnimatedTextField(
                controller: _categoryController,
                label: 'Category',
                icon: Icons.category,
                isRequired: true,
                delay: 200,
              ),
              const SizedBox(height: 20),
              _buildAnimatedTextField(
                controller: _subcategoryController,
                label: 'Subcategory',
                icon: Icons.category_outlined,
                delay: 300,
              ),
            ],
          );

    final column = Column(
      children: [
        _buildAnimatedTextField(
          controller: _imageController,
          label: 'Image URL',
          icon: Icons.image,
          isRequired: true,
          delay: 100,
        ),
        const SizedBox(height: 20),
        categoryFields,
        const SizedBox(height: 20),
        _buildAnimatedTextField(
          controller: _brandIdController,
          label: 'Brand ID',
          icon: Icons.branding_watermark,
          isRequired: true,
          isNumber: true,
          delay: 400,
        ),
        const SizedBox(height: 20),
        _buildAnimatedTextField(
          controller: _taglineController,
          label: 'Tags (comma separated)',
          icon: Icons.tag,
          delay: 500,
        ),
      ],
    );

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: column),
          SizedBox(width: 24),
          Expanded(
            child: Column(
              children: [
                _buildHelpCard(
                  icon: Icons.photo_library,
                  title: "Image Guidelines",
                  content:
                      "Use high-quality images with white backgrounds. Show product from multiple angles. Include close-ups of important features.",
                  color: Colors.orange,
                  isDarkMode: isDarkMode,
                ),
                SizedBox(height: 20),
                _buildHelpCard(
                  icon: Icons.local_offer,
                  title: "Tagging Tips",
                  content:
                      "Use relevant keywords customers might search for. Include product type, features, use cases, and attributes. Separate with commas.",
                  color: Colors.red,
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return column;
  }

  Widget _buildSettingsStep(bool isDarkMode) {
    return Column(
      children: [
        _buildAnimatedTextField(
          controller: _createdByController,
          label: 'Created By',
          icon: Icons.person,
          delay: 100,
        ),
        const SizedBox(height: 24),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 500),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: _buildSettingsCard(isDarkMode),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSettingsCard(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF252525) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            title: 'Product Available',
            subtitle: 'Make this product available for purchase',
            value: _isAvailable,
            icon: Icons.visibility,
            activeColor: Colors.green,
            onChanged: (v) => setState(() => _isAvailable = v),
          ),
          Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
          _buildSwitchTile(
            title: 'Featured Product',
            subtitle: 'Display this product prominently',
            value: _isFeatured,
            icon: Icons.star,
            activeColor: Colors.amber,
            onChanged: (v) => setState(() => _isFeatured = v),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF252525) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required Color activeColor,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: value
              ? activeColor.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: value ? activeColor : Colors.grey[600],
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 13),
      ),
      trailing: Transform.scale(
        scale: 1.2,
        child: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: activeColor,
          activeTrackColor: activeColor.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isRequired = false,
    bool isNumber = false,
    int maxLines = 1,
    String? hintText,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + delay),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: _buildTextField(
              controller: controller,
              label: label,
              icon: icon,
              isRequired: isRequired,
              isNumber: isNumber,
              maxLines: maxLines,
              hintText: hintText,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isRequired = false,
    bool isNumber = false,
    int maxLines = 1,
    String? hintText,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : null,
        inputFormatters: isNumber
            ? [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))]
            : null,
        validator: isRequired
            ? (value) => value == null || value.isEmpty
                  ? 'This field is required'
                  : null
            : null,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.primaryColor, size: 20),
          ),
          filled: true,
          fillColor: isDarkMode ? Color(0xFF252525) : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: theme.primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 20,
          ),
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(
    BuildContext context,
    Size size,
    bool isDarkMode,
  ) {
    final isTablet = size.width > 768;
    final stepGradient = LinearGradient(
      colors: _steps[_currentStep]['gradient'],
    );

    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _currentStep == 0 ? null : _cancel,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: BorderSide(
                    color: _currentStep == 0
                        ? Colors.grey[300]!
                        : Theme.of(context).primaryColor,
                  ),
                ),
                child: Text(
                  'BACK',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: _currentStep == 0
                        ? Colors.grey[400]
                        : Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  gradient: stepGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: (_steps[_currentStep]['color'] as Color)
                          .withOpacity(0.4),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _continue,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          _currentStep == _steps.length - 1 ? 'SUBMIT' : 'NEXT',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _continue() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep += 1);
      _animationController.reset();
      _animationController.forward();
    } else {
      _submitForm();
    }
  }

  void _cancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
      _animationController.reset();
      _animationController.forward();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        name: _nameController.text,
        slug: _slugController.text.isNotEmpty
            ? _slugController.text
            : _nameController.text.toLowerCase().replaceAll(' ', '-'),
        shortDescription: _shortDescController.text,
        description: _descController.text,
        image: _imageController.text,
        price: double.parse(_priceController.text),
        stock: int.parse(_stockController.text),
        sku: _skuController.text,
        category: _categoryController.text,
        subcategory: _subcategoryController.text,
        brandId: int.parse(_brandIdController.text),
        isAvailable: _isAvailable,
        isFeatured: _isFeatured,
        createdBy: _createdByController.text,
        tagline: _taglineController.text.isNotEmpty
            ? _taglineController.text.split(',').map((e) => e.trim()).toList()
            : [],
        discount: double.tryParse(_discountController.text) ?? 0,
        averageRating: 0,
      );

      widget.productBloc.add(CreateProductEvent(product));
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 64),
              SizedBox(height: 16),
              Text(
                'Success!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Product has been created successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text('OK', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.help_outline, color: Colors.blue, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'Help',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Fill in all the required fields marked with (*) to create a new product. '
                'You can navigate between steps using the Next/Back buttons.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'GOT IT',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _slugController.dispose();
    _shortDescController.dispose();
    _descController.dispose();
    _imageController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _skuController.dispose();
    _categoryController.dispose();
    _subcategoryController.dispose();
    _brandIdController.dispose();
    _createdByController.dispose();
    _discountController.dispose();
    _taglineController.dispose();
    super.dispose();
  }
}
