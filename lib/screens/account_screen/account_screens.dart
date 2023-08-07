import 'package:e_commerce/constanst/routs.dart';
import 'package:e_commerce/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:e_commerce/screens/abuot_us/about_us.dart';
import 'package:e_commerce/screens/change_password/change_password.dart';
import 'package:e_commerce/screens/edit_profile/edit_profile.dart';
import 'package:e_commerce/screens/favorite_screen/favorite_screen.dart';
import 'package:e_commerce/screens/order_screen/order_screen.dart';
import 'package:e_commerce/widgets/primary_button/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/app_provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Account",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(

              children: [
                appProvider.getUserInformation.image == null
                    ? const Icon(
                  Icons.person_outline,
                  size: 120,
                )
                    : CircleAvatar(
                  backgroundImage:
                  NetworkImage(appProvider.getUserInformation.image!),
                  radius: 60,
                ),
                Center(
                  child: Text(
                    appProvider.getUserInformation.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    appProvider.getUserInformation.email,
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 120),
                  child: PrimaryButton(
                    title: "Edit Profile",
                    onPressed: () {
                      Routes.instance
                          .push(widget: const EditProfile(), context: context);
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Routes.instance
                        .push(widget: const OrderScreen(), context: context);
                  },
                  leading: const Icon(Icons.shopping_bag_outlined),
                  title: const Text("Your Orders"),
                ),
                ListTile(
                  onTap: () {
                    Routes.instance.push(
                        widget: const FavouriteScreen(), context: context);
                  },
                  leading: const Icon(Icons.favorite_outline),
                  title: const Text("Favourite"),
                ),
                ListTile(
                  onTap: () {
                    Routes.instance
                        .push(widget: const AboutUs(), context: context);
                  },
                  leading: const Icon(Icons.info_outline),
                  title: const Text("About us"),
                ),
                ListTile(
                  onTap: () {
                    Routes.instance
                        .push(widget: const ChangePassword(), context: context);
                  },
                  leading: const Icon(Icons.change_circle_outlined),
                  title: const Text("Change Password"),
                ),
                ListTile(
                  onTap: () {
                    FirebaseAuthHelper.instance.signOut();

                    setState(() {});
                  },
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text("Log out"),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                const Text("Version 1.0.0")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
