import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/prodcut.dart';
import '../providers/product_provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();

  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final product = Product(
      productName: _nameCtrl.text,
      price: double.parse(_priceCtrl.text),
      stock: int.parse(_stockCtrl.text),
    );

    await Provider.of<ProductProvider>(context, listen: false).addProduct(product);
    setState(() => _isLoading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: "Name"),
              validator: (val) => val!.isEmpty ? "Required" : null,
            ),
            TextFormField(
              controller: _priceCtrl,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
              validator: (val) => double.tryParse(val!) == null ? "Enter valid price" : null,
            ),
            TextFormField(
              controller: _stockCtrl,
              decoration: const InputDecoration(labelText: "Stock"),
              keyboardType: TextInputType.number,
              validator: (val) => int.tryParse(val!) == null ? "Enter valid stock" : null,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submit,
                    child: const Text("Add Product"),
                  )
          ]),
        ),
      ),
    );
  }
}
