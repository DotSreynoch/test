import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/prodcut.dart';
import '../providers/product_provider.dart';

class EditProductPage extends StatefulWidget {
  final Product product;
  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _stockCtrl;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.product.productName);
    _priceCtrl = TextEditingController(text: widget.product.price.toString());
    _stockCtrl = TextEditingController(text: widget.product.stock.toString());
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final updated = Product(
      productId: widget.product.productId,
      productName: _nameCtrl.text,
      price: double.parse(_priceCtrl.text),
      stock: int.parse(_stockCtrl.text),
    );

    await Provider.of<ProductProvider>(context, listen: false).updateProduct(updated);
    setState(() => _isLoading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product")),
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
                    child: const Text("Save Changes"),
                  )
          ]),
        ),
      ),
    );
  }
}
