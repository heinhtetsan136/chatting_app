abstract class HomePageEvent {
  const HomePageEvent();
}

class gotoHomePage extends HomePageEvent {
  const gotoHomePage();
}

class gotoContactScreen extends HomePageEvent {
  const gotoContactScreen();
}

class gotoSettings extends HomePageEvent {
  const gotoSettings();
}
