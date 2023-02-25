import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _focusPrice = FocusNode();
  final _focusDescription = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _newProd = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl:
        'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  );

  //dispose focusnodes otherwise memory leak
  void dispose() {
    _focusPrice.dispose();
    _focusDescription.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _safeForm() {
    _form.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit product'),
        actions: [
          IconButton(
              onPressed: () {
                _safeForm;
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (val) {
                  FocusScope.of(context).requestFocus(_focusPrice);
                },
                onSaved: (val) {
                  _newProd = Product(
                    id: _newProd.id,
                    title: val,
                    description: _newProd.description,
                    price: _newProd.price,
                    imageUrl: _newProd.imageUrl,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _focusPrice,
                onFieldSubmitted: (val) {
                  FocusScope.of(context).requestFocus(_focusDescription);
                },
                onSaved: (val) {
                  _newProd = Product(
                    id: _newProd.id,
                    title: _newProd.title,
                    description: _newProd.description,
                    price: double.parse(val),
                    imageUrl: _newProd.imageUrl,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                focusNode: _focusDescription,
                onSaved: (val) {
                  _newProd = Product(
                    id: _newProd.id,
                    title: _newProd.title,
                    description: val,
                    price: _newProd.price,
                    imageUrl: _newProd.imageUrl,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.white),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      onFieldSubmitted: (_) => _safeForm(),
                      onSaved: (val) {
                        _newProd = Product(
                          id: _newProd.id,
                          title: _newProd.title,
                          description: _newProd.description,
                          price: _newProd.price,
                          imageUrl: _newProd.imageUrl, //val
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
