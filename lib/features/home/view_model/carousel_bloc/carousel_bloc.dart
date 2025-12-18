import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluxfoot_user/features/home/models/carousel_model.dart';

part 'carousel_event.dart';
part 'carousel_state.dart';

class CarouselBloc extends Bloc<UserCarouselEvent, UserCarouselState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CarouselBloc() : super(CarouselInitial()) {
    on<FetchCarouselData>((event, emit) async {
      emit(CarouselLoading());

      await emit.forEach(
        _firestore.collection('carousel_management').doc('data').snapshots(),
        onData: (DocumentSnapshot<Map<String, dynamic>> doc) {
          if (doc.exists && doc.data() != null) {
            return CarouselLoaded(CarouselData.fromFirestore(doc.data()!));
          } else {
            return CarouselError("No carousel configured");
          }
        },
        onError: (error, stackTrace) => CarouselError(error.toString()),
      );
    });
  }
}
