import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iocl_app/stores/adminstore.dart';
import 'package:provider/provider.dart';

import '../utils/consts.dart';


class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController empcodeController = TextEditingController();
  TextEditingController editingController = TextEditingController();
  GroupController sortFiltercontroller = GroupController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sortFiltercontroller.initSelectedItem = [0];
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AdminStore>(
            builder: (context, adminModel, child) {
              return Column(
               
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("Admin Panel", style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)
                ),),
                  Divider(),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          _showBottomSheet(context, height, width, adminModel);
                        },

                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                                "Add Employee",
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xffED6B21))),
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: RefreshIndicator( 
                      onRefresh: adminModel.refreshData,
                      child: FutureBuilder(future: adminModel.getUsers(), builder: (context, snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data?.length ?? 0,
                                  itemBuilder: (context, index){
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(snapshot.data?[index]['name'], style:GoogleFonts.lato(
                                                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                                            ) ,
                                            ),
                                            SizedBox(height: height*0.01,),
                                            Text(snapshot.data?[index]['empCode'], style:GoogleFonts.lato(
                                                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                                            ) ,
                                            ),
                                            SizedBox(height: height*0.01,),

                                            Row(
                                              children: [
                                                OutlinedButton(
                                                  onPressed: () async {
                                                    editingController.text = snapshot.data?[index]['emailId'];
                                                    _showEditBottomSheet(context, height, width, adminModel,editingController, snapshot.data![index]);
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                    fixedSize: Size(120, 30), // Adjust the width and height as needed
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                        "Edit",
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
                                                    adminModel.deleteEmployee(snapshot.data?[index]['empCode'] ,snapshot.data?[index]['name'], snapshot.data?[index]['emailId']);
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                    fixedSize: Size(120, 30), // Adjust the width and height as needed
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                        "Delete",
                                                        style: GoogleFonts.lato(
                                                            textStyle: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w600,
                                                                color: Color(0xffED6B21))),
                                                      )),
                                                ) ,
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );

                                    return ListTile(
                                      // trailing: Text(snapshot.data?[index]['role'],
                                      //   style:GoogleFonts.lato(
                                      //       textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)
                                      //   ) ,),
                                      trailing: IconButton(icon: Icon(Icons.delete), onPressed: () {
                                        adminModel.deleteEmployee(snapshot.data?[index]['empCode'] , snapshot.data?[index]['name'], snapshot.data?[index]['emailId']);
                                      },),
                                      leading: CircleAvatar(
                                        radius: 24,
                                        child: Image(
                                          image: AssetImage("assets/iocl_cover.png"),
                                        ),
                                      ),
                                      title: Text(snapshot.data![index]['name'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style:GoogleFonts.lato(
                                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
                                      ) ,),
                                      subtitle: Text(snapshot.data?[index]['empCode'], style:GoogleFonts.lato(
                                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)
                                      ) ,),
                                    );
                                  });
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
  void _showBottomSheet(BuildContext context, double height, double width, AdminStore adminModel) {
    final formKey = GlobalKey<FormState>();
    final userRoles =  [
      "Admin",
      "Manager",
      "Worker",
    ];
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
          ),
          padding: EdgeInsets.all(16.0),
          width: double.infinity,
          child: SingleChildScrollView(
            child:
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Add an Employee',
                          style:GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if(value!.length < 3){
                                return "Too Short";
                              }
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),

                              labelText: 'Enter employee name',
                            )),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if(value!.length < 3){
                                return "Too Short";
                              }

                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),

                              labelText: 'Enter employee email',
                            )),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        TextFormField(
                            controller: empcodeController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if(value!.length < 3){
                                return "Too Short";
                              }
                            },
                            decoration: const InputDecoration(

                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),

                              labelText: 'Enter employee code',
                            )),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Text("Select Employee Role"),
                        SimpleGroupedChips<int>(
                          controller: sortFiltercontroller,
                          onItemSelected: (selected) {

                          },
                          values: const [0, 1, 2],
                          chipGroupStyle: ChipGroupStyle.minimize(
                            checkedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            selectedIcon: null,
                            selectedColorItem:
                            Theme.of(context).colorScheme.inversePrimary,
                            disabledColor: Colors.green,
                            backgroundColorItem: Colors.white,
                            itemTitleStyle: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)
                            ),
                          ),
                          itemsTitle: userRoles,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the bottom sheet on button press
                              },
                              child: Text('Close'),
                            ),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if(formKey.currentState!.validate() && sortFiltercontroller.selectedItem != null){
                                  adminModel.addEmployee(nameController.text, emailController.text, empcodeController.text, userRoles[sortFiltercontroller.selectedItem]);
                                  Navigator.pop(context);
                                }
                                else if(sortFiltercontroller.selectedItem == null) {
                                  showGenericToast("Please Select User Role");
                                }
                                // Close the bottom sheet on button press
                              },
                              child: Text('Submit'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),



          ),
        );
      },
    );
  }
  void _showEditBottomSheet(BuildContext context, double height, double width, AdminStore adminModel, TextEditingController textEditingController, Map<String,dynamic> user) {
    final formKey = GlobalKey<FormState>();
    final userRoles =  [
      "Admin",
      "Manager",
      "Worker",
    ];
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(

          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
          ),
          padding: EdgeInsets.all(16.0),
          width: double.infinity,
          child: SingleChildScrollView(
            child:
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Edit Details',
                      style:GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    TextFormField(
                        controller: textEditingController,
                        validator: (value) {
                          if(value!.length < 3){
                            return "Too Short";
                          }
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),

                          labelText: 'Edit employee email',
                        )),
                    // SizedBox(
                    //   height: height * 0.03,
                    // ),
                    // TextFormField(
                    //     controller: emailController,
                    //     validator: (value) {
                    //       if(value!.length < 3){
                    //         return "Too Short";
                    //       }
                    //
                    //     },
                    //     decoration: const InputDecoration(
                    //       border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    //
                    //       labelText: 'Enter employee email',
                    //     )),
                    // SizedBox(
                    //   height: height * 0.03,
                    // ),
                    // TextFormField(
                    //     controller: empcodeController,
                    //     keyboardType: TextInputType.number,
                    //     validator: (value) {
                    //       if(value!.length < 3){
                    //         return "Too Short";
                    //       }
                    //     },
                    //     decoration: const InputDecoration(
                    //
                    //       border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    //
                    //       labelText: 'Enter employee code',
                    //     )),
                    // SizedBox(
                    //   height: height * 0.03,
                    // ),
                    // Text("Select Employee Role"),
                    // SimpleGroupedChips<int>(
                    //   controller: sortFiltercontroller,
                    //   onItemSelected: (selected) {
                    //
                    //   },
                    //   values: const [0, 1, 2],
                    //   chipGroupStyle: ChipGroupStyle.minimize(
                    //     checkedShape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(20)),
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(20)),
                    //     selectedIcon: null,
                    //     selectedColorItem:
                    //     Theme.of(context).colorScheme.inversePrimary,
                    //     disabledColor: Colors.green,
                    //     backgroundColorItem: Colors.white,
                    //     itemTitleStyle: GoogleFonts.lato(
                    //         textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)
                    //     ),
                    //   ),
                    //   itemsTitle: userRoles,
                    // ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the bottom sheet on button press
                          },
                          child: Text('Close'),
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if(formKey.currentState!.validate()){
                              adminModel.editEmployee(user, editingController.text);
                              Navigator.pop(context);
                            }
                            else if(sortFiltercontroller.selectedItem == null) {
                              showGenericToast("Please Select User Role");
                            }
                            // Close the bottom sheet on button press
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),



          ),
        );
      },
    );
  }

}
