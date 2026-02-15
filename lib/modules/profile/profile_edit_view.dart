import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/auth_controller.dart';
import '../../app/ui/app_snackbar.dart';

class ProfileEditView extends StatefulWidget {
  const ProfileEditView({super.key});

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  final auth = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  String? photoUrl;

  final avatars = const [
    'https://i.pravatar.cc/150?img=1',
    'https://i.pravatar.cc/150?img=2',
    'https://i.pravatar.cc/150?img=3',
    'https://i.pravatar.cc/150?img=4',
    'https://i.pravatar.cc/150?img=5',
    'https://i.pravatar.cc/150?img=6',
  ];

  @override
  void initState() {
    super.initState();
    final user = auth.user.value;
    if (user != null) {
      nameController.text = user.name;
      emailController.text = user.email;
      photoUrl = user.photoUrl;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void pickAvatar() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: avatars.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemBuilder: (_, i) {
          final url = avatars[i];
          return InkWell(
            onTap: () {
              setState(() => photoUrl = url);
              Get.back();
            },
            child: CircleAvatar(backgroundImage: NetworkImage(url)),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('edit_profile'.tr)),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    backgroundImage:
                        photoUrl == null ? null : NetworkImage(photoUrl!),
                    child: photoUrl == null
                        ? const Icon(Icons.person, color: Colors.white, size: 32)
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: pickAvatar,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit,
                            size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'full_name'.tr),
                      textInputAction: TextInputAction.next,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'enter_name'.tr
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'email'.tr),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'enter_email'.tr
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    auth.updateProfile(
                      name: nameController.text.trim(),
                      email: emailController.text.trim(),
                      photoUrl: photoUrl,
                    );
                    AppSnackbar.success('updated'.tr, 'profile_saved'.tr);
                    Get.back();
                  }
                },
                child: Text('save_changes'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
