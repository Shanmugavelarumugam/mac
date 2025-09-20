import 'package:btc_store/bloc/brand/brand_bloc.dart';
import 'package:btc_store/bloc/brand/brand_event.dart';
import 'package:btc_store/bloc/brand/brand_state.dart';
import 'package:btc_store/data/models/brand_model.dart';
import 'package:btc_store/data/repositories/brand_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateBrandScreen extends StatefulWidget {
  const CreateBrandScreen({super.key});

  @override
  State<CreateBrandScreen> createState() => _CreateBrandScreenState();
}

class _CreateBrandScreenState extends State<CreateBrandScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _logoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isFeatured = false;
  String? _token;
  bool _isLoadingToken = true;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print("CreateBrandScreen: Retrieved token: $token");

    setState(() {
      _token = token;
      _isLoadingToken = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingToken) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6A5AE0)),
          ),
        ),
      );
    }

    if (_token == null || _token!.isEmpty) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.warning_2, size: 64, color: Colors.orange),
                SizedBox(height: 16),
                Text(
                  "Authentication Required",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Please login again to create brands",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Color(0xFF64748B)),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6A5AE0),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Go Back",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final repository = BrandRepository(token: _token!);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return BlocProvider(
      create: (_) => BrandBloc(repository: repository),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Create Brand",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Iconsax.arrow_left, color: Color(0xFF1E293B)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Color(0xFFF8FAFC),
        body: BlocConsumer<BrandBloc, BrandState>(
          listener: (context, state) {
            if (state is BrandSuccess) {
              print("Brand created successfully: ${state.brand.toJson()}");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Brand created successfully"),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
              Navigator.pop(context);
            } else if (state is BrandFailure) {
              print("Brand creation failed: ${state.error}");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Iconsax.tag,
                              size: 32,
                              color: Color(0xFF6A5AE0),
                            ),
                            SizedBox(height: 12),
                            Text(
                              "Brand Information",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Create a new brand for your products",
                              style: GoogleFonts.poppins(
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),

                      // Form Section
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Brand Name Field
                              Text(
                                "Brand Name *",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1E293B),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  hintText: "Enter brand name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Color(0xFFE2E8F0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Color(0xFF6A5AE0),
                                      width: 2,
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Iconsax.tag,
                                    color: Color(0xFF64748B),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: isSmallScreen ? 12 : 16,
                                  ),
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? "Brand name is required"
                                    : null,
                                style: GoogleFonts.poppins(),
                              ),
                              SizedBox(height: 20),

                              // Logo URL Field
                              Text(
                                "Logo URL",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1E293B),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: _logoController,
                                decoration: InputDecoration(
                                  hintText: "https://example.com/logo.png",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Color(0xFFE2E8F0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Color(0xFF6A5AE0),
                                      width: 2,
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Iconsax.image,
                                    color: Color(0xFF64748B),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: isSmallScreen ? 12 : 16,
                                  ),
                                ),
                                style: GoogleFonts.poppins(),
                              ),
                              SizedBox(height: 20),

                              // Description Field
                              Text(
                                "Description",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1E293B),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  hintText: "Describe your brand...",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Color(0xFFE2E8F0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Color(0xFF6A5AE0),
                                      width: 2,
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Iconsax.document_text,
                                    color: Color(0xFF64748B),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: isSmallScreen ? 12 : 16,
                                  ),
                                ),
                                maxLines: 3,
                                style: GoogleFonts.poppins(),
                              ),
                              SizedBox(height: 20),

                              // Featured Switch
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Iconsax.star,
                                      color: Color(0xFFF59E0B),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Featured Brand",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF1E293B),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "Feature this brand on your storefront",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Switch(
                                      value: _isFeatured,
                                      onChanged: (val) {
                                        setState(() => _isFeatured = val);
                                        print("Featured toggled: $_isFeatured");
                                      },
                                      activeColor: Color(0xFF6A5AE0),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),

                              // Submit Button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      final brand = Brand(
                                        id: 0,
                                        name: _nameController.text,
                                        slug: "",
                                        logo: _logoController.text,
                                        description:
                                            _descriptionController.text,
                                        isFeatured: _isFeatured,
                                        sellerId: 0,
                                        createdAt: DateTime.now(),
                                        updatedAt: DateTime.now(),
                                      );
                                      print(
                                        "Submitting brand: ${brand.toJson()}",
                                      );
                                      context.read<BrandBloc>().add(
                                        CreateBrandEvent(brand),
                                      );
                                    } else {
                                      print("Form validation failed");
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF6A5AE0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: state is BrandLoading
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : Text(
                                          "Create Brand",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),

                // Loading Overlay
                if (state is BrandLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF6A5AE0),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _logoController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
