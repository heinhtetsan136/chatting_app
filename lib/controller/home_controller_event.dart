abstract class HomePageEvent {
  const HomePageEvent();
}

class gotoHomePage extends HomePageEvent {
  const gotoHomePage();
}

class gotoContactScreen extends HomePageEvent {
  const gotoContactScreen();
}

class gotoPost extends HomePageEvent {
  const gotoPost();
}

class gotoPostScreen extends HomePageEvent {
  const gotoPostScreen();
}
