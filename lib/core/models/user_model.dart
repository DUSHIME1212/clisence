class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String gender;
  final int age;
  final String country;
  final String region;
  final String district;
  final double farmSize;
  final List<String> mainCrops;
  final String plantingSeason;
  final List<String> preferredChannels;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.age,
    required this.country,
    required this.region,
    required this.district,
    required this.farmSize,
    required this.mainCrops,
    required this.plantingSeason,
    required this.preferredChannels,
  });

  // Create a default user for testing
  factory UserModel.dummy() {
    return UserModel(
      id: 'dummy123',
      fullName: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+250700000000',
      gender: 'Male',
      age: 30,
      country: 'Rwanda',
      region: 'Kigali',
      district: 'Gasabo',
      farmSize: 2.5,
      mainCrops: ['Maize', 'Beans'],
      plantingSeason: 'Season A',
      preferredChannels: ['SMS', 'Email'],
    );
  }
}
