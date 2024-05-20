import 'package:facultysupportdesk/widgets/users/user_dialog_form.dart';
import 'package:flutter/material.dart';
import '../../models/app_user.dart';

class UserItem extends StatelessWidget {
  const UserItem({
    super.key,
    required this.user,
    required this.onUpdateUserList
  });

  final AppUser user;
  final Function() onUpdateUserList;


  @override
  Widget build(BuildContext context) {

    void openUpdateUserDialog(){
      showDialog(
          context: context,
          builder: (ctx) => SimpleDialog(
        children: [
            UserDialogForm(
            onUpdateUser: onUpdateUserList,
            mode: Mode.update,
            user: user,
          )
        ],
      )
      );
    }




    return Card(
        margin: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 15
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                      user.name!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                      )
                  ),
                  const Spacer(),
                  Text(
                    user.role!
                  )
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(user.email!),
                  const Spacer(),
                  Text(user.isActive! ? 'Active' : 'Inactive')
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              TextButton.icon(
                  onPressed: openUpdateUserDialog,
                  label: const Text('Edit'),
                  icon: const Icon(Icons.edit_rounded,
                      size: 16)
              )
            ],
          ),
        ),
    );
  }
}
