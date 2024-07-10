import 'package:blca_project_app/repo/user_model.dart';

abstract class ContactBaseEvent {
  const ContactBaseEvent();
}

class GetContactEvent extends ContactBaseEvent {
  GetContactEvent();
}

class RefreshContactEvent extends ContactBaseEvent {
  RefreshContactEvent();
}

class NewContactEvent extends ContactBaseEvent {
  final List<ContactUser> post;
  NewContactEvent(this.post);
}
