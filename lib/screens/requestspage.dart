import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iocl_app/stores/requeststore.dart';
import 'package:provider/provider.dart';

import '../utils/consts.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<RequestStore>(
            builder: (context, requestModel, child) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("Bypass Requests", style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)
                ),),
                  Divider(),

                  Expanded(
                      child: RefreshIndicator(
                      onRefresh: requestModel.getRequests,
                      child: FutureBuilder(future: requestModel.getRequests(), builder: (context, snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if(snapshot.data!.length == 0) {
                          return Container(
                            child: Center(
                              child: Text("No Requests to Bypass", style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 16, color: Colors.black)
                              ),),
                            ),
                          );
                        }
                        
                        return Consumer<RequestStore>(

                            builder: (context, dashboardModel, child) {
                              return Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(

                                        itemCount: snapshot.data?.length ?? 0,
                                        itemBuilder: (context, index){
                                          dynamic createdAt = snapshot.data?[index]['createdAt'].toDate();
                                         final date = "${createdAt.day}/${createdAt.month}/${createdAt.year}";
                                         final time = formatTime(createdAt);

                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,

                                                    children: [
                                                      Text(snapshot.data?[index]['name'], style:GoogleFonts.lato(
                                                          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                                                      ) ,
                                                      ),
                                                      Wrap(
                                                        children: [
                                                          Text(
                                                            'Reason: ${snapshot.data?[index]['reason']}', style:GoogleFonts.lato(
                                                              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
                                                          ) ,),
                                                        ],
                                                      ),
                                                      Text(
                                                        'Created At: ${time}, ${date}', style:GoogleFonts.lato(
                                                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
                                                      ) ,),
                                                       Text(
                                                        'Created By: ${snapshot.data?[index]['createdBy']}', style:GoogleFonts.lato(
                                                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
                                                      ) ,),
                                                      snapshot.data?[index]['status'] == 'pending' ?
                                                      Row(
                                                        children: [
                                                          OutlinedButton(
                                                            onPressed: () async {
                                                              requestModel.updateApprovalStatus(snapshot.data?[index]['id']);
                                                            },
                                                            style: OutlinedButton.styleFrom(
                                                              fixedSize: Size(120, 30), // Adjust the width and height as needed
                                                            ),
                                                            child: Center(
                                                                child: Text(
                                                                  "Approve",
                                                                  style: GoogleFonts.lato(
                                                                      textStyle: const TextStyle(
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.w600,
                                                                          color: Color(0xffED6B21))),
                                                                )),
                                                          ) ,
                                                          SizedBox(
                                                            width: 0.02*width,
                                                          ),
                                                          OutlinedButton(
                                                            onPressed: () async {
                                                              requestModel.rejectBypassRequest(snapshot.data?[index]['id']);
                                                            },
                                                            style: OutlinedButton.styleFrom(
                                                              fixedSize: Size(120, 30), // Adjust the width and height as needed
                                                            ),
                                                            child: Center(
                                                                child: Text(
                                                                  "Reject",
                                                                  style: GoogleFonts.lato(
                                                                      textStyle: const TextStyle(
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.w600,
                                                                          color: Color(0xffED6B21))),
                                                                )),
                                                          ) ,
                                                        ],
                                                      ) : Container()
                                                    ],
                                                  ),
                                                  snapshot.data?[index]['status'] == 'pending' ? Container():
                                                  snapshot.data?[index]['status'] == 'approved' ? Text("Approved ✅", style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),) : Text("Rejected ❌", style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),)
                                                ],
                                              ),
                                            ),
                                          );

                                        }),
                                  ),
                                  OutlinedButton(onPressed: (){
                                    excelService.createRequestReport(snapshot.data!);
                                  }, child: Text("Download Excel"))
                                ],
                              );
                            }
                        );
                      }),
                    ),
                  ),


                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
