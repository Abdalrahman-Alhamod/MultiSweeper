import 'package:flutter_bloc/flutter_bloc.dart';

import 'logger.dart';

class CustomBlocObserver implements BlocObserver {
  @override
  void onEvent(
    Bloc<dynamic, dynamic> bloc,
    Object? event,
  ) {
    logger.print(
      'Bloc = $bloc\nEvent = $event',
      title: '${PrintTitles.blocObserver} Event',
    );
  }

  @override
  void onError(
    BlocBase<dynamic> bloc,
    Object error,
    StackTrace stackTrace,
  ) {
    logger.print(
      'Bloc = $bloc\nError = $error\nTrace = $stackTrace',
      title: '${PrintTitles.blocObserver} Error',
    );
  }

  @override
  void onChange(
    BlocBase<dynamic> bloc,
    Change<dynamic> change,
  ) {
    logger.print(
      'Bloc = $bloc\n$change',
      title: '${PrintTitles.blocObserver} Change',
    );
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    logger.print(
      'Bloc = $bloc\nTransition = $transition',
      title: '${PrintTitles.blocObserver} Transition',
    );
  }

  @override
  void onClose(
    BlocBase<dynamic> bloc,
  ) {
    logger.print(
      'Bloc = $bloc\nClose = $bloc',
      title: '${PrintTitles.blocObserver} Close',
    );
  }

  @override
  void onCreate(
    BlocBase<dynamic> bloc,
  ) {
    logger.print(
      'Create = $bloc',
      title: '${PrintTitles.blocObserver} Create',
    );
  }
}
