import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_management/providers/product.dart';
import 'package:shop_management/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var editedProduct =
      Product(id: null, title: '', price: 0, description: '', imageUrl: '');

  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  var isInit = true;

  var initValues = {
    "title": '',
    "description": '',
    "price": '',
    "imageUrl": '',
  };

  @override
  void didChangeDependencies() {
    if (isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        final product =
            Provider.of<Products>(context, listen: false).findbyId(productId);
        editedProduct = product;
        initValues = {
          "title": editedProduct.title,
          "description": editedProduct.description,
          "price": editedProduct.price.toString(),
          // "imageUrl": editedProduct.imageUrl
          "imageUrl": '',
        };
        _imageUrlController.text = editedProduct.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  void updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  var isLoading = false;
  Future<void> saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });

    if (editedProduct.id != null) {
      await Provider.of<Products>(context)
          .updateProduct(editedProduct.id, editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured'),
            content: Text('Something went wrong'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Okay')),
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: saveForm),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(8),
              child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: initValues["title"],
                        decoration: InputDecoration(labelText: 'title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          editedProduct = Product(
                              title: value,
                              price: editedProduct.price,
                              description: editedProduct.description,
                              imageUrl: editedProduct.imageUrl,
                              id: editedProduct.id,
                              isFavourite: editedProduct.isFavourite);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: initValues["price"],
                        decoration: InputDecoration(labelText: 'price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          editedProduct = Product(
                              title: editedProduct.title,
                              price: double.parse(value),
                              description: editedProduct.description,
                              imageUrl: editedProduct.imageUrl,
                              id: editedProduct.id,
                              isFavourite: editedProduct.isFavourite);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'please enter a number greater tahan 0';
                          }
                        },
                      ),
                      TextFormField(
                          initialValue: initValues["description"],
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          onSaved: (value) {
                            editedProduct = Product(
                                title: editedProduct.title,
                                price: editedProduct.price,
                                description: value,
                                imageUrl: editedProduct.imageUrl,
                                id: editedProduct.id,
                                isFavourite: editedProduct.isFavourite);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a description';
                            }
                          }),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter a url')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'ImageURL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) => saveForm,
                              onSaved: (value) {
                                editedProduct = Product(
                                    title: editedProduct.title,
                                    price: editedProduct.price,
                                    description: editedProduct.description,
                                    imageUrl: value,
                                    id: editedProduct.id,
                                    isFavourite: editedProduct.isFavourite);
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
