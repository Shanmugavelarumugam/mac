import 'package:btc_store/bloc/product/product_bloc.dart';
import 'package:btc_store/data/repositories/product_repository.dart';
import 'package:btc_store/presentation/screens/products/add_product.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductButton extends StatelessWidget {
  const AddProductButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');

        if (token == null || token.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("User token not found."),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final repository = ProductRepository(token: token);
        final productBloc = ProductBloc(repository);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: productBloc,
              child: AddProductScreen(productBloc: productBloc),
            ),
          ),
        );
      },
      backgroundColor: const Color(0xFF3B82F6),
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add_rounded),
      label: const Text("Add Product"),
    );
  }
}
