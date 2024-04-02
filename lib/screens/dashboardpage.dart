import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iocl_app/services/mailservice.dart';
import 'package:iocl_app/stores/dashboardstore.dart';
import 'package:provider/provider.dart';

import '../utils/consts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}



class _DashboardPageState extends State<DashboardPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    DashboardStore dashboardStore = DashboardStore();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: context.read<DashboardStore>().getUsers(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return Consumer<DashboardStore>(
                builder: (context, dashboardModel, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text("Dashboard", style: GoogleFonts.lato(
                      textStyle: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)
                    ),),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Workers", style: GoogleFonts.lato(
                              textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                          ),),
                          OutlinedButton(
                            onPressed: () async {
                              if(dashboardModel!.selectedUsers.isEmpty) {

                                showGenericToast("Please select workers");
                              }
                              else {
                              //  bool isValid = await dashboardModel.checkValidity();
                                bool isCooldown = await dashboardModel.checkCooldown();
                                if(isCooldown) {
                                  dashboardModel.randomizeUsers();
                                  _showBottomSheet(context, dashboardModel);
                                }
                                else {
                                 showGenericToast("Cooldown period of 60 minutes is active. Try again later") ;
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                    "Randomize",
                                    style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xffED6B21))),
                                  )),
                            ),
                          ),
                        ],
                      ),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                  itemCount: snapshot.data?.length ?? 0,
                                  itemBuilder: (context, index){
                                return ListTile(
leading:const CircleAvatar(
                                  radius: 24,
                                  child: Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage("assets/iocl_cover.png"),
                                  ),

                                ),
                                  title: Text(snapshot.data?[index]['name'], style:GoogleFonts.lato(
                                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
                                  ) ,),
                                  trailing: Checkbox(
                                    checkColor: const Color(0xffED6B21),
                                    activeColor: const Color(0xff03134e),
                                    value: dashboardModel.selectedItems[index],
                                    onChanged: (value) {
                                     dashboardModel.toggleSelection(index, snapshot.data?[index]);
                                    },
                                  ),
                                );
                              }),
                            ),

                

                    ],
                  );
                }
              );
            }
          ),
        ),
      ),
    );
  }
  dynamic _showBottomSheet(BuildContext context, DashboardStore dashboardModel) {
    final formKey = GlobalKey<FormState>();
    final reasons = ["Worker did not report for duty" , "Erreneously worker was selected although worker not available", "Others"];
    final reasonEditingController = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
          ),
          padding: const EdgeInsets.all(16.0),
          width: double.infinity,
          child: Column(
            children: [
              Text("Selected Users", style: GoogleFonts.lato(textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: dashboardModel.randomizedUsers.length,
                  itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title:  Text(dashboardModel.randomizedUsers[index]['name']),
                    trailing: OutlinedButton(onPressed: (){
                    showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Consumer<DashboardStore>(

                                builder: (context, dashboardModel, child) {
                                  return Container(
                                    height: 200,
                                    width: 600,
                                    child: Column(
                                      children: [
                                        Text("Please Add Reason", style: GoogleFonts.lato(
                                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)
                                        ),),
                                        const SizedBox(height: 20,),
                                         DropdownButtonFormField(

                                          hint: const Text("Select Reason"),
isExpanded: true,
                                            items: const [
                                          DropdownMenuItem(child: Text("Worker did not report for duty"),value: 0,),
                                          DropdownMenuItem(child: Text("Erreneously worker was selected although worker not available"),value: 1,),
                                          DropdownMenuItem(child: Text("Others"),value: 2,)
                                        ], onChanged: (val){
                                            setState(() {
                                              reasonEditingController.text = reasons[val!];
                                              dashboardModel.toggleSelectedReason(val);
                                            });
                                        }),
                                        const SizedBox(height: 20,),
                                      dashboardModel.selectedReason == 2 ?  TextFormField(
                                            controller: reasonEditingController,
                                            validator: (value) {},
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),

                                              labelText: 'Enter Reason'
                                            )) : Container(),
                                      ],
                                    )
                                  );
                                }
                              ),
                              actions: [
                                OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context, {
                                        "status" : false
                                      });
                                    },
                                    child: const Text("Cancel")),
                                OutlinedButton(
                                    onPressed: () {
                                      if(reasonEditingController.text.isEmpty) {
                                        showGenericToast("Please add a reason");
                                        return;
                                      }
                                      dashboardModel.sendBypassRequest(reasonEditingController.text, dashboardModel.randomizedUsers[index]);
                                      Navigator.pop(context, {
                                        "status" : true,
                                        "data": dashboardModel.randomizedUsers[index]
                                      });
                                    },
                                    child: const Text("Submit")),
                              ],
                            );
                          }).then((value) => {
                            if(value['status']) {
                              dashboardModel.emptyRandomizedUsers(value['data']),
                              Navigator.pop(context, {"status": false})
                            }
                    });
                    },
                        child: const Text("Bypass"),),
                  );

                },),
              ),
              OutlinedButton(
                  onPressed: () async{

                    bool isScheduled = await dashboardModel.scheduleTest();
                    if(isScheduled) {
                      print(loggedInUser);

                     mailService.sendEmail("Event Scheduled", dashboardModel.randomizedUsers, dashboardModel.selectedUsers , loggedInUser?["emailId"], loggedInUser?['name']);
                    }
                    Navigator.pop(context, {
                      "status": isScheduled
                    });

                   // dashboardModel.sendBypassRequest(dashboardModel.randomizedUsers[index]['name'], reasonEditingController.text);

                  },
                  child: const Text("Schedule Test")),
            ],
          ),
        );
      },
    ).then((value) => {
      if(value['status']){
        dashboardModel.clearDataAfterSchedule(),
       // Navigator.pop(context)
      }

    });
  }

}
