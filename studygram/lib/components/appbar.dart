import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

AppBar getMyAppBar(BuildContext context, Text title) {
  return AppBar(
    backgroundColor: const Color.fromARGB(255, 151, 115, 156),
    leading: GoRouter.of(context).canPop()
        ? IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => context.pop(),
          )
        : null,
    title: title,
    centerTitle: true,
  );
}
