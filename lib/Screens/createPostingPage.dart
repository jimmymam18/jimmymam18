import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Models/postingObjects.dart';
import 'package:bizitme/Screens/hostHomePage.dart';
import 'package:bizitme/Views/textWidgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostingPage extends StatefulWidget {
  static final String routeName = '/createPostingPageRoute';
  final Posting posting;
  CreatePostingPage({this.posting, Key key}) : super(key: key);

  @override
  _CreatePostingPageState createState() => _CreatePostingPageState();
}

class _CreatePostingPageState extends State<CreatePostingPage> {
  final List<String> _spaceTypes = [
    'Workspace',
    'Meeting',
    'Parking Spot',
    'Storage',
    'Study',
    'Event & Party',
    'Salons & Barbershops',
    'Wedding',
    'Photo & Video Shoot',
    'Pop Up',
    'Recording Studios',
    'Gyms & Yoga',
    'Others'
  ];
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController;
  TextEditingController _priceController;
  TextEditingController _descriptionController;
  TextEditingController _addressController;
  TextEditingController _cityController;
  TextEditingController _countryController;
  TextEditingController _amenitiesController;

  String _spaceType;
  Map<String, int> _beds;
  Map<String, int> _bathroom;
  List<MemoryImage> _images;

  void _selectedImage(int index) async {
    var imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (imageFile != null) {
      MemoryImage newImage = MemoryImage(await imageFile.readAsBytes());
      if (index < 0) {
        _images.add(newImage);
      } else {
        _images[index] = newImage;
      }
      setState(() {});
    }
  }

  void _savePosting() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    if (_spaceType == null) {
      return;
    }
    if (_images.isEmpty) {
      return;
    }

    Posting posting = Posting();
    posting.name = _nameController.text;
    posting.price = double.parse(_priceController.text);
    posting.description = _descriptionController.text;
    posting.address = _addressController.text;
    posting.city = _cityController.text;
    posting.country = _countryController.text;
    posting.amenities = _amenitiesController.text.split(",");
    posting.type = _spaceType;
    posting.beds = _beds;
    posting.bathrooms = _bathroom;
    posting.displayImages = _images;
    posting.host = AppConstants.currentUser.createContactFromUser();
    posting.setImageNames();
    if (widget.posting == null) {
      posting.rating = 2.5;
      posting.bookings = [];
      posting.reviews = [];
      posting.addPostingInfoToFirestore().whenComplete(() {
        posting.addImagesToFirestore().whenComplete(() {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HostHomePage(
                      index: 1,
                    )),
          );
        });
      });
    } else {
      posting.rating = widget.posting.rating;
      posting.bookings = widget.posting.bookings;
      posting.reviews = widget.posting.reviews;
      posting.id = widget.posting.id;
      for (int i = 0; i < AppConstants.currentUser.myPostings.length; i++) {
        if (AppConstants.currentUser.myPostings[i].id == posting.id) {
          AppConstants.currentUser.myPostings[i] = posting;
          break;
        }
      }

      posting.updatePostingInfoInFirestore().whenComplete(() {
        posting.addImagesToFirestore().whenComplete(() {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HostHomePage(
                      index: 1,
                    )),
          );
        });
      });

    }
  }



  void _setUpInitialValues() {
    if (widget.posting == null) {
      _nameController = TextEditingController();
      _priceController = TextEditingController();
      _descriptionController = TextEditingController();
      _addressController = TextEditingController();
      _cityController = TextEditingController();
      _countryController = TextEditingController();
      _amenitiesController = TextEditingController();
      _beds = {
        'small': 0,
        'medium': 0,
        'large': 0,
      };
      _bathroom = {
        'full': 0,
        'half': 0,
      };

      _images = [];
    } else {
      _nameController = TextEditingController(text: widget.posting.name);
      _priceController =
          TextEditingController(text: widget.posting.price.toString());
      _descriptionController =
          TextEditingController(text: widget.posting.description);
      _addressController = TextEditingController(text: widget.posting.address);
      _cityController = TextEditingController(text: widget.posting.city);
      _countryController = TextEditingController(text: widget.posting.country);
      _amenitiesController =
          TextEditingController(text: widget.posting.getAmenitiesString());
      _beds = widget.posting.beds;
      _bathroom = widget.posting.bathrooms;
      _images = widget.posting.displayImages;
      _spaceType = widget.posting.type;
    }
    setState(() {});
  }

  @override
  void initState() {
    _setUpInitialValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarText(text: 'Create a Post '),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _savePosting,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Please enter the following information:',
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 35.0),
                        child: TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Posting name'),
                          style: TextStyle(
                            fontSize: 22.0,
                          ),
                          controller: _nameController,
                          validator: (text) {
                            if (text.isEmpty) {
                              return "Please enter a name.";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35.0),
                        child: DropdownButton(
                          isExpanded: true,
                          value: _spaceType,
                          hint: Text(
                            'Select a space type',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          items: _spaceTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(
                                type,
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            this._spaceType = value;
                            setState(() {});
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Price',
                                ),
                                style: TextStyle(
                                  fontSize: 22.0,
                                ),
                                keyboardType: TextInputType.number,
                                controller: _priceController,
                                validator: (text) {
                                  if (text.isEmpty) {
                                    return "Please enter a price.";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, bottom: 15.0),
                              child: Text(
                                '\$ / night',
                                style: TextStyle(
                                  fontSize: 22.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Description'),
                          style: TextStyle(
                            fontSize: 22.0,
                          ),
                          controller: _descriptionController,
                          maxLines: 3,
                          minLines: 1,
                          validator: (text) {
                            if (text.isEmpty) {
                              return "Please enter a description.";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Address'),
                          style: TextStyle(
                            fontSize: 22.0,
                          ),
                          controller: _addressController,
                          validator: (text) {
                            if (text.isEmpty) {
                              return "Please enter an address.";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'City'),
                          style: TextStyle(
                            fontSize: 22.0,
                          ),
                          controller: _cityController,
                          validator: (text) {
                            if (text.isEmpty) {
                              return "Please enter a city.";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Country'),
                          style: TextStyle(
                            fontSize: 22.0,
                          ),
                          controller: _countryController,
                          validator: (text) {
                            if (text.isEmpty) {
                              return "Please enter a country.";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35.0),
                        child: Text(
                          'Beds',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
                        child: Column(
                          children: <Widget>[
                            FacilitiesWidget(
                              type: 'Twin/Single',
                              startValue: _beds['small'],
                              decreaseValue: () {
                                this._beds['small']--;
                                if (this._beds['small'] < 0) {
                                  this._beds['small'] = 0;
                                }
                              },
                              increaseValue: () {
                                this._beds['small']++;
                              },
                            ),
                            FacilitiesWidget(
                                type: 'Double',
                                startValue: _beds['medium'],
                                decreaseValue: () {
                                  this._beds['medium']--;
                                  if (this._beds['medium'] < 0) {
                                    this._beds['medium'] = 0;
                                  }
                                },
                                increaseValue: () {
                                  this._beds['medium']++;
                                }),
                            FacilitiesWidget(
                                type: 'Queen/king',
                                startValue: _beds['large'],
                                decreaseValue: () {
                                  this._beds['large']--;
                                  if (this._beds['large'] < 0) {
                                    this._beds['large'] = 0;
                                  }
                                },
                                increaseValue: () {
                                  this._beds['large']++;
                                }),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35.0),
                        child: Text(
                          'Bathrooms',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                        child: Column(
                          children: <Widget>[
                            FacilitiesWidget(
                              type: 'Half',
                              startValue: _bathroom['half'],
                              decreaseValue: () {
                                this._bathroom['half']--;
                                if (this._bathroom['half'] < 0) {
                                  this._bathroom['half'] = 0;
                                }
                              },
                              increaseValue: () {
                                this._bathroom['half']++;
                              },
                            ),
                            FacilitiesWidget(
                              type: 'Full',
                              startValue: _bathroom['full'],
                              decreaseValue: () {
                                this._bathroom['full']--;
                                if (this._bathroom['full'] < 0) {
                                  this._bathroom['full'] = 0;
                                }
                              },
                              increaseValue: () {
                                this._bathroom['full']++;
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Amenities (comma separated)'),
                          style: TextStyle(
                            fontSize: 22.0,
                          ),
                          controller: _amenitiesController,
                          maxLines: 3,
                          minLines: 1,
                          validator: (text) {
                            if (text.isEmpty) {
                              return "Please enter some amenities (comma separated)";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35.0),
                        child: Text(
                          'Images',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                          padding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: _images.length + 1,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 25,
                                    crossAxisSpacing: 25,
                                    childAspectRatio: 3 / 2),
                            itemBuilder: (context, index) {
                              if (index == _images.length) {
                                return IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    _selectedImage(-1);
                                  },
                                );
                              }
                              return MaterialButton(
                                onPressed: () {
                                  _selectedImage(index);
                                },
                                child: Image(
                                  image: _images[index],
                                  fit: BoxFit.fill,
                                ),
                              );
                            },
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FacilitiesWidget extends StatefulWidget {
  final String type;
  final int startValue;
  final Function decreaseValue;
  final Function increaseValue;

  FacilitiesWidget(
      {Key key,
      this.type,
      this.startValue,
      this.decreaseValue,
      this.increaseValue})
      : super(key: key);

  @override
  _FacilitiesWidgetState createState() => _FacilitiesWidgetState();
}

class _FacilitiesWidgetState extends State<FacilitiesWidget> {
  int _value;
  @override
  void initState() {
    this._value = widget.startValue;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          widget.type,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                widget.decreaseValue();
                this._value--;
                if (this._value < 0) {
                  this._value = 0;
                }
                setState(() {});
              },
            ),
            Text(
              this._value.toString(),
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  widget.increaseValue();
                  this._value++;
                  setState(() {});
                }),
          ],
        )
      ],
    );
  }
}
