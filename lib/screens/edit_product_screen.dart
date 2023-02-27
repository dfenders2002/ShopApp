import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

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

  Future<void> _safeForm() async {
    final isValid = _form.currentState.validate(); //triggerd alle validates
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    if (_newProd.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_newProd.id, _newProd);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_newProd);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  var initVals = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var isInit = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    if (isInit) {
      final prodId = ModalRoute.of(context).settings.arguments as String;
      if (prodId != null) {
        _newProd =
            Provider.of<Products>(context, listen: false).findById(prodId);
        initVals = {
          'title': _newProd.title,
          'description': _newProd.description,
          'price': _newProd.price.toString(),
          //'imageUrl': _newProd.imageUrl,
          'imageUrl': ''
        };
        _imageUrlController.text = _newProd.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
    // TODO: implement didChangeDependencies
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit product'),
        actions: [
          IconButton(
              onPressed: () {
                _safeForm();
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: initVals['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).requestFocus(_focusPrice);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please provide a title;';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _newProd = Product(
                            id: _newProd.id,
                            title: val,
                            description: _newProd.description,
                            price: _newProd.price,
                            imageUrl: _newProd.imageUrl,
                            isFavorite: _newProd.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: initVals['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _focusPrice,
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).requestFocus(_focusDescription);
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'please enter number';
                        }
                        if (double.tryParse(val) == null) {
                          return 'enter valid number';
                        }
                        if (double.parse(val) <= 0) {
                          return 'number higher then 0';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _newProd = Product(
                            id: _newProd.id,
                            title: _newProd.title,
                            description: _newProd.description,
                            price: double.parse(val),
                            imageUrl: _newProd.imageUrl,
                            isFavorite: _newProd.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: initVals['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      focusNode: _focusDescription,
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'enter description';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _newProd = Product(
                            id: _newProd.id,
                            title: _newProd.title,
                            description: val,
                            price: _newProd.price,
                            imageUrl: _newProd.imageUrl,
                            isFavorite: _newProd.isFavorite);
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
                            //cant set controller to init value
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
                                  isFavorite: _newProd.isFavorite);
                            },
                            //validator: (val) {
                            //  if (val.isEmpty) {
                            //    return 'please enter an URL';
                            //  }
                            //  if (!val.startsWith('http') &&
                            //      !val.startsWith('https')) {
                            //    return 'enter valid URL';
                            //  }
                            //  if (!val.endsWith('.png') &&
                            //      !val.endsWith('.jpg') &&
                            //      !val.endsWith('.jpeg')) {
                            //    return 'use png or jpg';
                            //  }
                            //  return null;
                            //},
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
