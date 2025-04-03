import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentmaster/constans/my_colors.dart';
import 'package:rentmaster/controller/real_state_controller.dart';
import 'package:rentmaster/controller/real_state_type_controller.dart';
import 'package:rentmaster/controller/user_controller.dart';
import 'package:rentmaster/model/real_state_model.dart';

class ShowRealStateForRent extends StatefulWidget {
  const ShowRealStateForRent({super.key});

  @override
  State<ShowRealStateForRent> createState() => _ShowRealStateForRentState();
}

class _ShowRealStateForRentState extends State<ShowRealStateForRent> {
  final Realstatetypecontroller realstatetypecontroller =
      Get.put(Realstatetypecontroller());
  final RealStateController realStateController =
      Get.put(RealStateController());
  var real_stateList = <RealStateModel>[].obs;
  RxString selectedItem = ''.obs;
  final UserController userController = Get.put(UserController());

  Future getRealStateData() async {
    await realStateController.getRealStateData();
    real_stateList.assignAll(realStateController.realStateList);
  }

  Future getRealStateDataBasedOnStateType(String realStateName) async {
    int typeid = await realstatetypecontroller
        .getRealStateTypeId(realStateName.toString());
    await realStateController.fetchRealStateBasedOnStateType(
        userController.currentUser.value.username, typeid);
    real_stateList.assignAll(realStateController.realStateList);
  }

  @override
  void initState() {
    super.initState();
    realstatetypecontroller.fetchRealStateTypeList();
    getRealStateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myYellow,
        title: const Text(
          "العقارات القابلة للايجار",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Obx(() {
              if (realstatetypecontroller.realStateTypeList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: realstatetypecontroller.realStateTypeList
                        .map((type) =>
                            _buildCustomButton(type.name.toString()))
                        .toList(),
                  ),
                );
              }
            }),
          ),
          Expanded(
            child: Obx(() {
              if (real_stateList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 4 / 4,
                  ),
                  itemCount: real_stateList.length,
                  itemBuilder: (context, index) {
                    final type = real_stateList[index];
                    return _buildDashboardCard(
                      icon: Icons.home,
                      title: type.name.toString(),
                      color: Colors.green,
                      functionality: () {
                        // Add any functionality here
                      },
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButton(String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: () async {
          await getRealStateDataBasedOnStateType(text);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.myYellow,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          elevation: 4,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required Color color,
    required void Function() functionality,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: InkWell(
        onTap: functionality,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 4.0,
          color: color.withOpacity(0.9),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 48.0, color: Colors.white),
                const SizedBox(height: 16.0),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
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
