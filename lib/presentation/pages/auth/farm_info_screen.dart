import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clisence/presentation/providers/auth_provider.dart';
import 'package:clisence/core/models/user_model.dart';

class FarmInfoScreen extends StatefulWidget {
  final String userId;
  final String userEmail;
  final String userName;

  const FarmInfoScreen({
    Key? key,
    required this.userId,
    required this.userEmail,
    required this.userName,
  }) : super(key: key);

  @override
  _FarmInfoScreenState createState() => _FarmInfoScreenState();
}

class _FarmInfoScreenState extends State<FarmInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _countryController = TextEditingController();
  final _regionController = TextEditingController();
  final _districtController = TextEditingController();
  final _farmSizeController = TextEditingController();
  final List<String> _selectedCrops = [];

  // List of available crops (you can expand this list)
  final List<String> _availableCrops = [
    'Maize', 'Beans', 'Rice', 'Wheat', 'Potatoes',
    'Cassava', 'Sweet Potatoes', 'Bananas', 'Coffee', 'Tea'
  ];

  @override
  void dispose() {
    _countryController.dispose();
    _regionController.dispose();
    _districtController.dispose();
    _farmSizeController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      try {
        // Get the auth provider
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        
        // Create a UserModel with the collected information
        final user = UserModel(
          id: widget.userId,
          fullName: widget.userName,
          email: widget.userEmail,
          phone: '', // Phone can be updated later
          gender: '', // Gender can be updated later
          age: 0, // Age can be updated later
          country: _countryController.text,
          region: _regionController.text,
          district: _districtController.text,
          farmSize: double.tryParse(_farmSizeController.text) ?? 0.0,
          mainCrops: _selectedCrops,
          plantingSeason: '', // Can be updated later
          preferredChannels: const [],
        );

        // Save the user data to Firestore
        await authProvider.updateUserData(user);

        // Close the loading dialog
        if (mounted) {
          Navigator.of(context).pop();
          
          // Navigate to the home screen
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        // Close the loading dialog
        if (mounted) {
          Navigator.of(context).pop();
          
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving farm information: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Information'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Tell us about your farm',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Country field
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your country';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Region field
              TextFormField(
                controller: _regionController,
                decoration: const InputDecoration(
                  labelText: 'Region',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.map),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your region';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // District field
              TextFormField(
                controller: _districtController,
                decoration: const InputDecoration(
                  labelText: 'District',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your district';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Farm size field
              TextFormField(
                controller: _farmSizeController,
                decoration: const InputDecoration(
                  labelText: 'Farm Size (acres)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.square_foot),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your farm size';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Crops selection
              const Text(
                'Select up to 3 main crops you grow:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _availableCrops.map((crop) {
                  final isSelected = _selectedCrops.contains(crop);
                  return FilterChip(
                    label: Text(crop),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          if (_selectedCrops.length < 3) {
                            _selectedCrops.add(crop);
                          }
                        } else {
                          _selectedCrops.remove(crop);
                        }
                      });
                    },
                    selectedColor: Colors.green[100],
                    checkmarkColor: Colors.green,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Submit button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save and Continue',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
