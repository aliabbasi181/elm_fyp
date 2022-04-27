import 'package:elm_fyp/BLoc/application_bloc.dart';
import 'package:elm_fyp/Models/OrganizationModel.dart';
import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizationProfileDetail extends StatefulWidget {
  OrganizationModel organization;
  OrganizationProfileDetail({Key? key, required this.organization})
      : super(key: key);

  @override
  State<OrganizationProfileDetail> createState() =>
      _OrganizationProfileDetailState();
}

class _OrganizationProfileDetailState extends State<OrganizationProfileDetail> {
  @override
  void initState() {
    print(widget.organization.isConfirmed);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        height: Constants.screenHeight(context),
        width: Constants.screenWidth(context),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background_image.jpg"),
                fit: BoxFit.fill)),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: Constants.screenWidth(context),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
                    color: Constants.primaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 100,
                              width: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey, blurRadius: 5)
                                  ],
                                  borderRadius: BorderRadius.circular(100)),
                              child: Text(
                                "${widget.organization.name.toString().split(' ').first[0]}${widget.organization.name.toString().split(' ').last[0]}",
                                style: FontStyle(40, Constants.primaryColor,
                                    FontWeight.w700),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: 65,
                              height: 22,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Text(
                                widget.organization.isConfirmed != null
                                    ? widget.organization.isConfirmed
                                                .toString() ==
                                            "true"
                                        ? "Active"
                                        : "Unactive"
                                    : "NA",
                                style: FontStyle(
                                    12,
                                    widget.organization.isConfirmed != null
                                        ? widget.organization.isConfirmed
                                                    .toString() ==
                                                "true"
                                            ? Colors.green
                                            : Colors.red
                                        : Colors.grey,
                                    FontWeight.w600),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: [
                          Text(
                            "Name",
                            style: FontStyle(16, Colors.black, FontWeight.w600),
                          ),
                          Icon(
                            Icons.more_vert_rounded,
                            size: 22,
                          ),
                          Text(
                            widget.organization.name.toString(),
                            style:
                                FontStyle(16, Colors.black87, FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: [
                          Text(
                            "Email",
                            style: FontStyle(16, Colors.black, FontWeight.w600),
                          ),
                          Icon(
                            Icons.more_vert_rounded,
                            size: 22,
                          ),
                          Text(
                            widget.organization.email.toString(),
                            style:
                                FontStyle(16, Colors.black87, FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Address",
                            style: FontStyle(16, Colors.black, FontWeight.w600),
                          ),
                          Icon(
                            Icons.more_vert_rounded,
                            size: 22,
                          ),
                          Flexible(
                            child: Text(
                              widget.organization.address.toString(),
                              style: FontStyle(
                                  16, Colors.black87, FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Created at",
                            style: FontStyle(16, Colors.black, FontWeight.w600),
                          ),
                          Icon(
                            Icons.more_vert_rounded,
                            size: 22,
                          ),
                          Flexible(
                            child: Text(
                              widget.organization.createdAt.toString(),
                              style: FontStyle(
                                  16, Colors.black87, FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  if (!applicationBloc.loading) {
                    var data = await applicationBloc.organizationUpdateStatus(
                      widget.organization.sId.toString(),
                      widget.organization.isConfirmed.toString() == "true"
                          ? false
                          : true,
                    );
                    if (data.name != null) {
                      setState(() {
                        widget.organization = data;
                      });
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                  width: Constants.screenWidth(context) * 0.6,
                  decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
                      color:
                          widget.organization.isConfirmed.toString() == "true"
                              ? Colors.red
                              : Colors.green,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                          visible: applicationBloc.loading,
                          child: CupertinoActivityIndicator()),
                      Text(
                          widget.organization.isConfirmed.toString() == "true"
                              ? "Unactive"
                              : "Accept",
                          textAlign: TextAlign.center,
                          style: FontStyle(20, Colors.white, FontWeight.bold)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
