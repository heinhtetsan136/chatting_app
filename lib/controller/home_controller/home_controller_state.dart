abstract class HomeBlocBaseState {
  const HomeBlocBaseState();
}

class HomeInitial extends HomeBlocBaseState {
  const HomeInitial();
}

class HomeSuccess extends HomeBlocBaseState {
  const HomeSuccess();
}

class HomeError extends HomeBlocBaseState {
  final String error;
  const HomeError(this.error);
}

class HomeBlocNavigationState extends HomeBlocBaseState {
  final int index;
  const HomeBlocNavigationState(this.index);
}

class HomeLoading extends HomeBlocBaseState {
  const HomeLoading();
}

class HomeLogout extends HomeBlocBaseState {
  const HomeLogout();
}
