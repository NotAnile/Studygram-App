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

- Lägg till searchbar i homepage och feed (sidan där vi får upp andra personers inlägg som vi inte följer) längst upp i kolumnen.
- Lägg till innehåll för profilskärm:
  - Det ska stå användarnamn högst upp som man kan redigera
  - Det finns 4 stora knappar:
    - Vänner
    - inlägg
    - Gillade
    - Inställningar

- Lägg till innehåll för vänner skärm:
  - Alla vänner ska ligga i en lång rad innuti ett card
  - I varje card:
    - Står användarnamn till vänster
    - Ta bort vän knapp längst till höger

  - När man klickar på ett card (vän) kommer man till deras profil

- Statistik skärm:
  - Lista upp antalet plugg timmar och minuter för:
    - Idag
    - Denna vecka
    - Denna månad
    - Detta år
    - Genomsnittliga tiden

  - Längst ner ligger ett stapeldiagram för M, T, O, T, F, L, S (Måndag, Tisdag...)
    - I stapeldiagrammet står det timmar längst till höger