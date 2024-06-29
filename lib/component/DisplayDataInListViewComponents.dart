import 'package:cloud/component/CommonFileComponents.dart';
import 'package:cloud/component/FileAndFolderEditingComponents.dart';
import 'package:cloud/model/Model.dart';
import 'package:cloud/utils/Apicalls.dart';
import 'package:cloud/utils/Colors.dart';
import 'package:cloud/utils/DownloadAndUpload.dart';
import 'package:cloud/utils/Images.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/src/widgets/text.dart' as txt;
// ignore: must_be_immutable
class DisplayDataInListViewComponents extends StatefulWidget {
  static String tag = '/DisplayDataInListViewComponents';
  List<DataModel>? listOfData;
  bool? isSelect;
  bool? isSelectAll;
  bool? isCopyOrMove;
  int? selectedItem;
  Function(int?, bool?)? onChange;
  Function()? onListChanged;

  DisplayDataInListViewComponents({Key? key, this.listOfData, this.isSelect, this.isSelectAll, this.selectedItem, this.onChange, this.onListChanged, this.isCopyOrMove}) : super(key: key);

  @override
  DisplayDataInListViewComponentsState createState() => DisplayDataInListViewComponentsState();
}

class DisplayDataInListViewComponentsState extends State<DisplayDataInListViewComponents> {
  @override
  void initState() {
    super.initState();
    init();
  }
  Future<void> _handleRefresh()async{
    setState((){});
    return await Future.delayed(Duration(seconds: 2));
  }
  init() async {
    //
  }
  int downloadProgress = 0;

  bool isDownloadStarted = false;

  bool isDownloadFinish = false;
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      onRefresh: _handleRefresh,
      color: Colors.deepPurple,
      height: 300,
      backgroundColor:Colors.deepPurple[200],
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ListTile(
            enabled: widget.isCopyOrMove!
                ? widget.listOfData![index].isFolder
                    ? true
                    : false
                : true,
            contentPadding: const EdgeInsets.fromLTRB(8, 4, 4, 8),
            onTap: () {
              if (widget.listOfData![index].isFolder) {
                widget.isSelect!
                    ? selectFileAndFolders(index)
                    : widget.isCopyOrMove!
                        ? toasty(context, "Copied ${widget.listOfData![index].fileName}")
                        : CommonFileComponents(appBarTitle: widget.listOfData![index].fileName,path: widget.listOfData![index].url,).launch(context);
              } else {
                if (widget.isSelect!) selectFileAndFolders(index);
              }
            },
            visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
            title: Row(
              children: [
                txt.Text(widget.listOfData![index].fileName!),
                widget.listOfData![index].isStared
                    ? IconButton(
                        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                        iconSize: 18,
                        color: CSecondColor,
                        icon: const Icon(Icons.star),
                        onPressed: () {
                          if( unsetStar(widget.listOfData![index].url,widget.listOfData![index].mimeType!)){
                                  
                          widget.listOfData![index].isStared = false;
                                }
                          setState(() {});
                        },
                      )
                    : 0.width,
              ],
            ),
            leading: Image.asset(widget.listOfData![index].fileUrl, height: 30, width: 30),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                !widget.isSelect!
                    ? Row(
                        children: [
                          
                          !widget.listOfData![index].isFolder
                          ?Visibility(
                            visible: !isDownloadStarted,
                            child: IconButton(
                              icon:const Icon(Icons.download) ,
                              onPressed: ()async{
                               await handleDownload(widget.listOfData![index].downloadUrl!,widget.listOfData![index].fileName!);

                              },
                            ),
                          ):0.width,
                          !widget.isCopyOrMove!
                              ? IconButton(
                                  visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                                  icon: const Icon(Icons.more_vert),
                                  iconSize: 18,
                                  onPressed: () async {
                                    await showBottomSheetForFileAndFolderEditingOption(context, widget.listOfData![index]);
                                    widget.onListChanged!.call();
                                    setState(() {});
                                  })
                              : 0.width,
                        ],
                      )
                    : Row(
                        children: [
                         
                          Checkbox(
                            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                            value: widget.listOfData![index].isFileSelect,
                            onChanged: (val) {
                              setState(() {
                                widget.isSelectAll = false;
                                widget.listOfData![index].isFileSelect = val;
                                val! ? widget.selectedItem = widget.selectedItem! + 1 : widget.selectedItem = widget.selectedItem! - 1;
                                widget.onChange!.call(widget.selectedItem, widget.isSelectAll);
                              });
                            },
                          ),
                        ],
                      ),
              ],
            ),
            subtitle: widget.listOfData![index].fileUrl != CSFolderIcon ?  txt.Text(widget.listOfData![index].size1!+" "+widget.listOfData![index].time!) : null,
          );
        },
        itemCount: widget.listOfData!.length,
      ),
    );
  }

  void selectFileAndFolders(int index) {
    setState(() {
      widget.isSelectAll = false;
      widget.listOfData![index].isFileSelect = !widget.listOfData![index].isFileSelect!;
      widget.listOfData![index].isFileSelect! ? widget.selectedItem = widget.selectedItem! + 1 : widget.selectedItem = widget.selectedItem! - 1;
      widget.onChange!.call(widget.selectedItem, widget.isSelectAll);
    });
  }
}
