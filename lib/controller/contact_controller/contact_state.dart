import 'package:blca_project_app/repo/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class ContactBaseState extends Equatable {
  final List<ContactUser> posts;
  const ContactBaseState(this.posts);
  @override
  // TODO: implement props
  List<Object?> get props => posts;
}

class ContactInitialState extends ContactBaseState {
  const ContactInitialState(super.posts);
}

class ContactLoadingState extends ContactBaseState {
  const ContactLoadingState(super.posts);
}

class ContactSoftLoadingState extends ContactBaseState {
  const ContactSoftLoadingState(super.posts);
}

class ContactSuccessState extends ContactBaseState {
  const ContactSuccessState(super.posts);
}

class ContactFailedState extends ContactBaseState {
  final String message;
  const ContactFailedState(this.message, super.posts);
  @override
  // TODO: implement props
  List<Object?> get props => [...super.posts, message];
}
