import 'package:flutter/material.dart';
import 'package:heart_rate_app/widgets/userinfo_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonInfo extends StatefulWidget {
  const PersonInfo({super.key});

  @override
  State<PersonInfo> createState() => _PersonInfoState();
}

class _PersonInfoState extends State<PersonInfo> {
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final provider = Provider.of<PersonProvider>(context, listen: false);
    if (provider.isNewSession) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection("user_info")
          .doc("profile")
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        provider.loadFromFirestore(data);
      }
    } catch (e) {
      // Nếu lỗi thì in ra log
      debugPrint("Lưu dữ liệu thất bại: $e");
    }
  }

  Future<void> saveToFirestore() async {
    final provider = Provider.of<PersonProvider>(context, listen: false);
    await FirebaseFirestore.instance
        .collection("user_info")
        .doc("profile")
        .set(provider.toJson());

    provider.setNewSession(false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lưu lên Firestore thành công!")),
    );
  }

  Widget _buildNumberInput(String key) {
    return Consumer<PersonProvider>(
      builder: (context, provider, _) {
        final value = provider.toJson()[key]?.toString() ?? '';

        return Container(
          height: 50,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              decoration: const InputDecoration(border: InputBorder.none),
              controller: TextEditingController(text: value)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: value.length),
                ),
              onChanged: (val) {
                final number = double.tryParse(val) ?? 0;
                provider.updateField(key, number);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildSexDropdown() {
    return Consumer<PersonProvider>(
      builder: (context, provider, _) {
        return Container(
          height: 50,
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(30),
          ),
          child: DropdownButton<String>(
            value: provider.sex,
            dropdownColor: Colors.white54,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            underline: const SizedBox(),
            isExpanded: true,
            items: const [
              DropdownMenuItem(value: "male", child: Text("nam")),
              DropdownMenuItem(value: "female", child: Text("nữ")),
            ],
            onChanged: (val) {
              if (val != null) provider.updateField('sex', val);
            },
          ),
        );
      },
    );
  }

  Widget _buildLabeledInput(String label, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Container(
              height: 50,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Consumer<PersonProvider>(
              builder: (context, provider, _) {
                final value = provider.toJson()[key]?.toString() ?? '0';
                return Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: value,
                      hintStyle: const TextStyle(color: Colors.white54),
                    ),
                    onChanged: (val) {
                      final number = double.tryParse(val) ?? 0;
                      provider.updateField(key, number);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          avt_background(context),
          name_user(),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text(
                    "Tuổi",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  _buildNumberInput("age"),
                ],
              ),

              Column(
                children: [
                  const Text(
                    "Giới tính",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  _buildSexDropdown(),
                ],
              ),

              Column(
                children: [
                  const Text(
                    "Cân nặng",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  _buildNumberInput("weight"),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          _buildLabeledInput("loại đau ngực", "chest"),
          _buildLabeledInput("huyết áp", "bp"),
          _buildLabeledInput("Cholesterol trong máu", "chol"),
          _buildLabeledInput("Đường huyết", "sugar"),
          _buildLabeledInput("Điện tâm đồ", "ecg"),
          _buildLabeledInput("Đau thắt ngực khi gắng sức", "angina"),
          _buildLabeledInput("mức ST xuống", "oldpeak"),
          _buildLabeledInput("độ dốc ST", "slope"),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: saveToFirestore,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white54,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "SAVE TO FIRESTORE",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Padding name_user() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Consumer<PersonProvider>(
        builder: (context, provider, _) {
          return SizedBox(
            width: 320,
            child: TextField(
              textAlign: TextAlign.center,
              controller: TextEditingController(text: provider.name)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: provider.name.length),
                ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                hintText: "Nhập tên",
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              onChanged: (val) {
                provider.updateName(val);
              },
            ),
          );
        },
      ),
    );
  }

  Padding avt_background(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              image: const DecorationImage(
                image: AssetImage('assets/images/anhd.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
              ),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: -40,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/avttt.jpg'),
            ),
          ),
        ],
      ),
    );
  }
}
