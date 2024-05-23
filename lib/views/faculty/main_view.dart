import 'package:facultysupportdesk/layout/main_layout.dart';
import 'package:facultysupportdesk/models/consultation_request.dart';
import 'package:facultysupportdesk/widgets/consultations/consultation_list.dart';
import 'package:flutter/material.dart';

import '../../route_guards.dart';


class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<ConsultationRequest> _consultations = [];


  Future<void> fetchConsultations() async {
    _consultations.clear();
    _consultations = await ConsultationRequest().getConsultationRequestsByStatus();
  }

  void _refreshList(){
    setState(() {
    
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAuthenticated('faculty', context);
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchConsultations(),
        builder: (ctx, snapshot) {
          Widget body;
          if (snapshot.connectionState == ConnectionState.waiting) {
            body = const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            body = Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Widget mainContent = Container(
              width: double.infinity,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'OOPS!',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize:  50
                    ),
                  ),
                  SizedBox(height:  5),
                  Text(
                      'There are no pending consultations.'
                  )
                ],
              ),
            );

            if (_consultations.isNotEmpty) {
              mainContent = ConsultationList(
                isPending: true,
                onUpdateConsultationList: _refreshList,
                consultations: _consultations
              );
            }

            body = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height:  10),
                _consultations.isNotEmpty ? const Padding(
                  padding: EdgeInsets.only(left:  15,  bottom:  5),
                  child: Text(
                    'Pending Consultations',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize:  18
                    ),
                  ),
                ) : const SizedBox.shrink(),
                Expanded(child: mainContent),
              ],
            );
          }

          return MainLayout(
            role: Role.faculty,
            title: 'Consultation Requests',
            index: 0,
            content: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: RefreshIndicator(
                onRefresh: () async{
                  await fetchConsultations();
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text("Consultation Requests List Updated"),
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: body,
                ),
                ),
            ),
          );

        }
    );

  }
}
