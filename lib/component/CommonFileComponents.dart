import 'package:cloud/component/DisplayDataInListViewComponents.dart';
import 'package:cloud/component/DrawerComponents.dart';
import 'package:cloud/component/Loading.dart';
import 'package:cloud/component/SearchBar.dart';
import 'package:cloud/main.dart';
import 'package:cloud/utils/Apicalls.dart';
import 'package:cloud/utils/Colors.dart';
import 'package:cloud/utils/Constants.dart';
import 'package:cloud/utils/Widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:nb_utils/nb_utils.dart';

class CommonFileComponents extends StatefulWidget {
  static String tag = '/CommonFileComponents';

  final String? appBarTitle;
  final String? path;

  const CommonFileComponents({Key? key, this.appBarTitle, this.path}) : super(key: key);

  @override
  CommonFileComponentsState createState() => CommonFileComponentsState();
}

class CommonFileComponentsState extends State<CommonFileComponents> {
  CrossFadeState state = CrossFadeState.showFirst;
  Sorting? defaultSortingType = Sorting.Name;
  int selectedItem = 0;
  bool isSelect = false;
  bool isSelectAll = false;
  bool seen=false;
  bool isLoading=true;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
if(widget.appBarTitle==AppName){   
      isLoading=true;
   bool stat=await getFirst();
      setState(() {isLoading=false;});
    if(stat){
      setState(() {});
    }}else{
      setFalse();
      isLoading=true;
      bool stat=await getFolderData(widget.path!);
      setState(() {isLoading=false;});

    if(stat){

      setState(() {
      isLoading=false;

      });
    }
    }
  }
  getParent()async {
    if(widget.appBarTitle==AppName){   
      return ;
   }else if(widget.path!.substring(0,widget.path!.lastIndexOf('/')).split('/').last=='uploads'){
               setState((){isLoading=true;});

  //  bool stat=await getFirst();
      setState(() {isLoading=false;});
    // if(stat){
      
      setState(() {isLoading=false;});
    // }
   }else{
      setState((){isLoading=true;});
      bool stat=await getFolderData(widget.path!.substring(0,widget.path!.lastIndexOf('/')));
      setState(() {isLoading=false;});

    if(stat){

      setState(() {
      isLoading=false;

      });
    }
    }
  }
void updateList()async{
      bool stat=await getFolderData(widget.path??'${FirebaseAuth.instance.currentUser!.uid}/uploads');
      if(stat){
        setState((){
          isLoading=false;
        });
      }
}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
    
  }

   void setX(){
    setState(() {});
  }
  void selectAll() {
    isSelectAll = !isSelectAll;

    for (var element in getcloudList) {
      element.isFileSelect = isSelectAll;
    }

    selectedItem = isSelectAll ? getcloudList.length : 0;
    setState(() {});
  }

  List<Widget> actionBarWidgets() {
    List<Widget> listOfActionBarWidgets = [];
    if (selectedItem == 0) {
      listOfActionBarWidgets.add(
        IconButton(
          color: CSecondColor,
          icon: const Icon(Icons.done_all),
          onPressed: () => setState(() => selectAll()),
        ),
      );
    } else {
      listOfActionBarWidgets.add(
        IconButton(
          color: CSecondColor,
          icon: const Icon(Icons.done_all),
          onPressed: () => setState(() => selectAll()),
        ),
      );

      listOfActionBarWidgets.add(PopupMenuButton(
          icon: const Icon(Icons.more_vert, color: CSecondColor),
          onSelected: (dynamic val) async {
            if (val == 1) {
              bool isSelectedFileDeleted = await (buildDeleteSelectedFileDialog(context, "Delete $selectedItem items?"));
              if (isSelectedFileDeleted) {
                getcloudList.forEach((element){
                  if(element.isFileSelect == true){
                    element.isFolder?deleteFolder(element.url!): deleteItem(element.url!);
                    
                  }
                });
                getcloudList.removeWhere((element) => element.isFileSelect == true);
                finish(context);

                const CommonFileComponents(
                  appBarTitle: AppName,
                ).launch(context);
              }
              setState(() {});
            }
          },
          itemBuilder: (context) =>
          [
            const PopupMenuItem(value: 1, child: Text("Delete")),
          ]));
    }
    return listOfActionBarWidgets;
  }

  void ascendingOrderList() {
    getcloudList.sort((a, b) => a.fileName!.toLowerCase().compareTo(b.fileName!.toLowerCase()));
  }

  void modifyOrderList() {
   getcloudList.sort((a,b)=> a.time!.compareTo(b.time!));
  } 
   void sizeOrderList() {
   getcloudList.sort((a,b)=> a.size!.compareTo(b.size!));
  }

  Future showSortingType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return StatefulBuilder(builder: (BuildContext ctx, StateSetter state) {
            return Wrap(children: [
              Container(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Text("Sort By", style: primaryTextStyle(size: 16)),
                  10.height,
                  ListTile(
                    onTap: () {
                      ascendingOrderList();
                      defaultSortingType = Sorting.Name;
                      setState(() {});
                      finish(context);
                    },
                    visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                    contentPadding: const EdgeInsets.all(0),
                    title: const Text("Name"),
                    leading: const Icon(Icons.sort_by_alpha),
                    trailing: Radio(
                        visualDensity: const VisualDensity(vertical: -2),
                        value: Sorting.Name,
                        groupValue: defaultSortingType,
                        onChanged: (Sorting? val) =>
                            state(() {
                              ascendingOrderList();
                              defaultSortingType = val;
                              setState(() {});
                              finish(context);
                            })),
                  ),
                  ListTile(
                    onTap: () {
                      sizeOrderList();
                      defaultSortingType = Sorting.Size;
                      setState(() {});
                      finish(context);
                    },
                    visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                    contentPadding: const EdgeInsets.all(0),
                    title: const Text("Size"),
                    leading: const Icon(Icons.format_list_numbered),
                    trailing: Radio(
                        visualDensity: const VisualDensity(vertical: -2),
                        value: Sorting.Size,
                        groupValue: defaultSortingType,
                        onChanged: (Sorting? val) =>
                            state(() {
                              sizeOrderList();
                              defaultSortingType = val;
                              setState(() {});
                              finish(context);
                            })),
                  ),
                  ListTile(
                    onTap: () {
                      modifyOrderList();
                      defaultSortingType = Sorting.Date;
                      setState(() {});
                      finish(context);
                    },
                    visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                    contentPadding: const EdgeInsets.all(0),
                    title: const Text("Date"),
                    leading: const Icon(Icons.access_time),
                    trailing: Radio(
                        visualDensity: const VisualDensity(vertical: -2),
                        value: Sorting.Date,
                        groupValue: defaultSortingType,
                        onChanged: (Sorting? val) =>
                            state(() {
                              modifyOrderList();
                              defaultSortingType = val;
                              setState(() {});
                              finish(context);
                            })),
                  ),
                ]).paddingAll(16),
              ),
            ]);
          });
        });
  }

  Future<void> refreshList() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading=true;
      updateList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if(didPop){
          getParent();

        }
      },
      // onWillPop: () async {
      //   if (isSelect) {
      //     setState(() {
      //       isSelect = false;
      //     });
      //   } else {
      //     finish(context);
      //   }
      //   return false;
      // },
      // canPop: false,
      child: Scaffold(
        drawer: isSelect ? null : const DrawerComponents(),
        body: LiquidPullToRefresh(
          onRefresh: refreshList,
          showChildOpacityTransition: false,
            color: CSecondColor,
            animSpeedFactor: 2,
            springAnimationDurationInMilliseconds: 500,
            height: 150,
            backgroundColor:Colors.amber[300],
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [

                SliverAppBar(
                  pinned: true,
                  leading: isSelect
                      ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () =>
                        setState(() {
                          isSelect = false;
                          for (var element in getcloudList) {
                            element.isFileSelect = false;
                          }
                          selectedItem = 0;
                        }),
                  )
                      : null,
                  actions: isSelect
                      ? actionBarWidgets()
                      : [
                    IconButton(
                      color: CSecondColor,
                      icon: const Icon(Icons.search),
                      onPressed: () => showSearch(context: context, delegate: CSSearchBar(hintText: "Searching in cloud", listData: getcloudList)),
                    ),
                    IconButton(
                      color: CSecondColor,
                      icon: const Icon(Icons.check_box, size: 20),
                      onPressed: () => setState(() => isSelect = true),
                    ),
                    PopupMenuButton(
                      icon: const Icon(Icons.more_vert, color: CSecondColor),
                      onSelected: (dynamic val) {
                        if (val == 1) showSortingType(context);
                      },
                      itemBuilder: (context) => [const PopupMenuItem(value: 1, child: Text("Sort"))],
                    ),
                  ],
                  expandedHeight: isSelect ? 0 : 120,
                  flexibleSpace: FlexibleSpaceBar(
                    title: isSelect
                        ? selectedItem == 0
                        ? Text("Select items", style: boldTextStyle(color: black, size: 18))
                        : Text("$selectedItem selected", style: boldTextStyle(color: black, size: 18))
                        : Text(widget.appBarTitle!, style: boldTextStyle(color: black, size: 18)),
                  ),
                ),
              ];
            },
            body: Container(
              
              child: isLoading? Loading():SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    10.height,
                    isSelect
                        ? 0.height
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [Text(defaultSortingType.toString().substring(defaultSortingType.toString().indexOf('.') + 1)), const Icon(Icons.keyboard_arrow_down)],
                        ).onTap(() => showSortingType(context)),
                        
                      ],
                    ).paddingOnly(right: 10, left: 16),
                    isSelect ? 0.height : buildDivider(isFull: true),
                    getcloudList.isNotEmpty
                        ? 
          
                       DisplayDataInListViewComponents(
                        isSelect: isSelect,
                        isSelectAll: isSelectAll,
                        listOfData: getcloudList,
                        selectedItem: selectedItem,
                        isCopyOrMove: false,
                        onChange: (int? itemCount, bool? selectAll) {
                          selectedItem = itemCount!;
                          isSelectAll = selectAll!;
                          setState(() {});
                        },
                        onListChanged: () => setState(() {}),
                      )
                    
                        : SizedBox(
                      height: 200,
                      child: Text("This folder is empty", style: primaryTextStyle(color: Colors.grey)).center(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: isSelect
            ? null
            : FloatingActionButton(
          onPressed: () async {
            setState(() {
              isLoading=true;
            });
            await showBottomSheetForAddingData(context,widget.path??FirebaseAuth.instance.currentUser!.uid+'/uploads');
            setState(() {
              updateList();
            });
          },
          backgroundColor: CSecondColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
