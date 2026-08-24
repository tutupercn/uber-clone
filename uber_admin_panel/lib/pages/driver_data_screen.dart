import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DriverDataScreen extends StatefulWidget {
  final String driverId;

  const DriverDataScreen({super.key, required this.driverId});

  @override
  _DriverDataScreenState createState() => _DriverDataScreenState();
}

class _DriverDataScreenState extends State<DriverDataScreen> {
  @override
  Widget build(BuildContext context) {
    DatabaseReference driverRef =
        FirebaseDatabase.instance.ref().child("drivers").child(widget.driverId);

    return StreamBuilder(
      stream: driverRef.onValue,
      builder: (BuildContext context, snapshotData) {
        if (snapshotData.hasError) {
          return const Center(
            child: Text(
              "Bir hata oluştu. Daha sonra tekrar deneyin.",
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
          );
        }

        if (snapshotData.connectionState == ConnectionState.none) {
          return const Center(
            child: Text(
              "Bağlantı yok. İnternetinizi kontrol edin.",
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
          );
        }
        if (!snapshotData.hasData ||
            snapshotData.data?.snapshot.value == null) {
          return const Center(
            child: Text(
              "Sürücü bilgisi bulunamadı.",
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
          );
        }

        Map dataMap = snapshotData.data!.snapshot.value as Map;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromARGB(221, 39, 57, 99),
            centerTitle: true,
            title: const Text(
              "Sürücü Detayları",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildProfileSection(dataMap),
                const SizedBox(height: 20),
                Divider(),
                _buildCNICSection(dataMap),
                const SizedBox(height: 20),
                Divider(),
                _buildLicenseSection(dataMap),
                const SizedBox(height: 20),
                Divider(),
                _buildVehicleInfoSection(dataMap),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileSection(Map dataMap) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (dataMap.containsKey('profilePicture'))
          ClipOval(
            child: Image.network(
              dataMap['profilePicture'],
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        const SizedBox(width: 40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ad soyad: ${dataMap['firstName']} ${dataMap['secondName']}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Telefon: ${dataMap['phoneNumber']}"),
            Text("E-posta: ${dataMap['email']}"),
            Text("T.C. kimlik numarası: ${dataMap['cnicNumber']}"),
            Text("Adres: ${dataMap['address']}"),
            Text("Doğum tarihi: ${dataMap['dob']}"),
          ],
        ),
      ],
    );
  }

  Widget _buildCNICSection(Map dataMap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Kimlik bilgileri:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            _buildImage(dataMap['cnicFrontImage'], "Kimlik ön yüz"),
            _buildImage(dataMap['cnicBackImage'], "Kimlik arka yüz"),
            _buildImage(dataMap['driverFaceWithCnic'], "Kimlikle selfie"),
          ],
        ),
      ],
    );
  }

  Widget _buildLicenseSection(Map dataMap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Sürücü belgesi:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text('Ehliyet numarası: ${dataMap['drivingLicenseNumber']}'),
        const SizedBox(height: 20),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            _buildImage(dataMap['drivingLicenseFrontImage'], "Ehliyet ön yüz"),
            _buildImage(dataMap['drivingLicenseBackImage'], "Ehliyet arka yüz"),
          ],
        ),
      ],
    );
  }

  Widget _buildVehicleInfoSection(Map dataMap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Araç bilgileri:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text("Araç türü: ${dataMap['vehicleInfo']['type']}"),
        Text("Marka: ${dataMap['vehicleInfo']['brand']}"),
        Text("Renk: ${dataMap['vehicleInfo']['color']}"),
        Text("Model yılı: ${dataMap['vehicleInfo']['productionYear']}"),
        Text(
            "Plaka: ${dataMap['vehicleInfo']['registrationPlateNumber']}"),
        const SizedBox(height: 10),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            _buildImage(
                dataMap['vehicleInfo']['registrationCertificateFrontImage'],
                "Ruhsat ön yüz"),
            _buildImage(
                dataMap['vehicleInfo']['registrationCertificateBackImage'],
                "Ruhsat arka yüz"),
          ],
        ),
      ],
    );
  }

  Widget _buildImage(String url, String label) {
    return Column(
      children: [
        Image.network(
          url,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
