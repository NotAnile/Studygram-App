import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

AppBar getMyAppBar(BuildContext context, Text title) {
  return AppBar(
    backgroundColor: Theme.of(context).primaryColor,
    foregroundColor: Theme.of(context).primaryColor,
    leading: GoRouter.of(context).canPop()
        ? IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).highlightColor,
            ),
            onPressed: () => context.pop(),
          )
        : null,
    title: title,
    centerTitle: true,
  );
}
