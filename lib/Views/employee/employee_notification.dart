import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';

class Notification {
  String msg, date, time;
  Notification(this.msg, this.date, this.time);
}

class EmployeeNotification extends StatefulWidget {
  const EmployeeNotification({Key? key}) : super(key: key);

  @override
  State<EmployeeNotification> createState() => _EmployeeNotificationState();
}

class _EmployeeNotificationState extends State<EmployeeNotification> {
  List<Notification> data = [];
  @override
  initState() {
    super.initState();
    // data.add(Notification("Ali is out of fence", "12/01/2022", "02:05"));
    // data.add(Notification("Ali is out of fence", "12/01/2022", "02:10"));
    // data.add(Notification("Ali is out of fence", "12/01/2022", "02:15"));
    // data.add(Notification("Ali is out of fence", "12/01/2022", "02:20"));
    // data.add(Notification("Aun is out of fence", "12/01/2022", "02:20"));
    // data.add(Notification("Faseh is out of fence", "12/01/2022", "02:25"));
    // data.add(Notification("Ali is out of fence", "12/01/2022", "02:25"));
    // data.add(Notification("Omar is out of fence", "12/01/2022", "02:30"));
    // data.add(Notification("Awais is out of fence", "12/01/2022", "02:35"));
    // data.add(Notification("Afaq is out of fence", "12/01/2022", "02:45"));
    data.add(Notification("You are out of fence", "12/01/2022", "02:05"));
    data.add(Notification("You are out of fence", "12/01/2022", "02:10"));
    data.add(Notification("You are out of fence", "12/01/2022", "02:15"));
    data.add(Notification("You are out of fence", "12/01/2022", "02:20"));
    data.add(Notification("You are out of fence", "12/01/2022", "02:20"));
    data.add(Notification("You are out of fence", "12/01/2022", "02:25"));
    data.add(Notification("You are out of fence", "12/01/2022", "02:25"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Color(0xFFe6f5fd),
              Color(0xFFfde5eb),
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Container(
                height: Constants.screenHeight(context),
                width: Constants.screenWidth(context),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
                      height: Constants.screenHeight(context) * 0.15,
                      decoration: BoxDecoration(
                          color: Constants.primaryColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 20, // Shadow position
                            ),
                          ],
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Notifications!",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await AwesomeNotifications()
                                        .getGlobalBadgeCounter()
                                        .then((value) => AwesomeNotifications()
                                            .setGlobalBadgeCounter(0));
                                    Constants.showSnackBar(
                                        context,
                                        "All notifications marked as read",
                                        true);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text("Read all"),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        //height: Constants.screnHeight(context) * 0.6,
                        child: ListView.builder(
                          padding: EdgeInsets.only(top: 10),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return MyListTile(
                              msg: data[index].msg,
                              date: data[index].date,
                              time: data[index].time,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class MyListTile extends StatefulWidget {
  String msg, date, time;
  MyListTile(
      {Key? key, required this.msg, required this.date, required this.time})
      : super(key: key);

  @override
  _MyListTileState createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      margin: const EdgeInsets.only(bottom: 10, left: 30, right: 30),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1.5)],
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(stops: const [
          0.02,
          0.01
        ], colors: [
          Constants.primaryColor,
          const Color.fromRGBO(255, 255, 255, 1)
        ]),
      ),
      child: ListTile(
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.date,
              style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 12),
            ),
            Text(
              widget.time,
              style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 12),
            ),
          ],
        ),
        title: Text(
          widget.msg.toString(),
          style: TextStyle(
              color: Constants.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
        // trailing: QudsPopupButton(
        //   child: const Icon(
        //     Icons.more_vert_rounded,
        //     size: 30,
        //   ),
        //   items: [
        //     QudsPopupMenuItem(
        //         leading: const Icon(Icons.delete_rounded),
        //         title: const Text('Delete'),
        //         onPressed: () {
        //           print('Deleting Fence (${widget.msg})');
        //         }),
        //   ],
        // )
      ),
    );
  }
}
