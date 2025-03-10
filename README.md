# Sources
Olika sätt att navigera med go_router:

https://medium.com/@zahidulislam.pubalibank/go-router-an-efficient-way-to-manage-flutter-navigation-development-process-8a4c03e69066

Shell routes med go_router:
https://pub.dev/documentation/go_router/latest/go_router/ShellRoute-class.html

Anteckningar:
- MaterialApp.router ska ligga längst upp
- Sök på "flutter shell route and navigation bar" 
- Innehållet på sidorna ska bytas ut (argument till Scaffold)
    - Skapa en MainScaffold som innehåller Scaffold
    - Sidorna (HomePage, NotificationsPage, osv.) behöver inte returnera Scaffold utan 
      kan vara saker som Center då Scaffold finns med i MainScaffold. 
