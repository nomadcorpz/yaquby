import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yaquby/config.dart';
import 'package:yaquby/models/login_response_model.dart';
import 'package:yaquby/servives/global_variables.dart';

class ProfileWidget extends StatelessWidget {
  final String name;
  final LoginResponseModel? loginResponse; // Add this line

  const ProfileWidget({
    required this.name,
    required this.loginResponse, // Add this parameter
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataManagerProvider dataManagerProvider = DataManagerProvider();

    List<String> parts = dataManagerProvider.loginResponse_DM!.data.userImage.split(",");
    String base64Image = parts.length == 2 ? parts[1] : dataManagerProvider.loginResponse_DM!.data.userImage;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: InkWell(
          onTap: () {
            // print("TEST");
            // ProfileScreen(imageUrl: imageUrl, name: name);
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.colorSmokeWhite,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.0),
                  offset: const Offset(0, 2),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: loginResponse != null && loginResponse!.data.userImage != null
                        ? Image.memory(
                            Uint8List.fromList(
                              base64.decode(base64Image),
                            ),
                          ).image
                        : AssetImage('assets/default_avatar.png'), // Replace with a default image
                  ),
                  const SizedBox(width: 16),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.colorGreen,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.0),
                          offset: const Offset(0, 2),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: const Column(children: []),
                  ),
                  Expanded(
                    // Wrap the Column containing user info with Expanded
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/ic_sales_person.png',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              dataManagerProvider.loginResponse_DM!.data.userName,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/ic_store1.png',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Current Store - ${dataManagerProvider.selectedLocation_DM!.description}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/location_icon.svg',
                              // Replace with the path to your SVG icon
                              width: 20,
                              height: 20,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${dataManagerProvider.cityName}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        // Display user roles
                        if (loginResponse!.data.userroles.isNotEmpty)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.group, // You can use any icon you prefer
                                size: 20,
                                color: Colors.blue, // Change the color as needed
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "${loginResponse!.data.userroles.map((role) => role.roleName).join(',\n')}",
                                style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
