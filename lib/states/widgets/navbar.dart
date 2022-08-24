import 'package:flutter/material.dart';

class NavBar extends StatelessWidget with PreferredSizeWidget {
  final bool? isLeading;
  final bool? isActions;
  final Widget? title;
  Function? moveLogin;

  NavBar({
    this.isLeading = false,
    this.isActions = false,
    this.title,
    this.moveLogin
  });

  @override
  Widget build(BuildContext context) {
    Container leadingIcon;
    List<Widget> actionIcon;
    Container? backSpace;
    List<Widget>? logout;

    leadingIcon = Container(
      margin: const EdgeInsets.only(top: 9.0, bottom: 9.0, left: 18.0),
      decoration: const BoxDecoration(
        color: Color.fromARGB(100, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
      ),
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back,
          size: 18.0,
        ),
      ),
    );

    actionIcon = <Widget>[
      Container(
        margin: const EdgeInsets.only(top: 9.0, bottom: 9.0, right: 18.0),
        decoration: const BoxDecoration(
          color: Color.fromARGB(100, 255, 255, 255),
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        child: IconButton(
          onPressed: () {
            // Navigator.pushNamed(context, '/login');
            moveLogin!();
          },
          icon: const Icon(
            Icons.logout_rounded,
            size: 18.0,
          ),
        ),
      ),
    ];

    backSpace = isLeading! ? leadingIcon : null;
    logout = isActions! ? actionIcon : null;

    return AppBar(
      title: title,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: backSpace,
      actions: logout,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(100);
}

// Image.asset('assets/logo_02.png', fit: BoxFit.none)