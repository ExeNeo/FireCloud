import 'package:cloud/main.dart';
import 'package:cloud/model/Model.dart';
import 'package:cloud/utils/Apicalls.dart';
import 'package:cloud/utils/Constants.dart';
import 'package:cloud/utils/DownloadAndUpload.dart';
import 'package:cloud/utils/Images.dart';
import 'package:cloud/utils/Widgets.dart';
import 'package:cloud/utils/otherUtils.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/services.dart';
Future showBottomSheetForFileAndFolderEditingOption(BuildContext context, DataModel dataModel) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => Container(
      padding: const EdgeInsets.only(top: 20),
      child: StatefulBuilder(
        builder: (BuildContext ctx, StateSetter state) {
          return DraggableScrollableSheet(
            initialChildSize: 0.5,
            expand: false,
            maxChildSize: 1.0,
            builder: (_, scrollController) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  controller: scrollController,
                  child: Column(
                    children: [
                      lisTileForFileEditingOption(
                        title: dataModel.fileName!,
                        leading: dataModel.isFolder ? Image.asset(CSFolderIcon, width: 40, height: 40) : Image.asset(getImage(dataModel.mimeType??'text/txt'), width: 40, height: 40),
                        subTitle: dataModel.isFolder ? AppName :   (dataModel.size!.toString()+" "+ dataModel.time!),
                      ),
                      buildDivider(isFull: true),
                      lisTileForFileEditingOption(
                        title: "Save to device",
                        leading: blackIcon(Icons.download),
                      ).onTap(
                        () {
                          handleDownload(dataModel.downloadUrl!, dataModel.fileName!);
                          finish(context);
                          
                        },
                      ),
                      dataModel.isFolder
                          ? 0.height
                          : lisTileForFileEditingOption(title: "Copy link", leading: blackIcon(Icons.link)).onTap(() async{
                            
                            await Clipboard.setData(ClipboardData(text: dataModel.downloadUrl!));
                              toastLong("Link is ready to be used");
                              finish(context);
                            }),
                      dataModel.isStared
                          ? lisTileForFileEditingOption(title: "Unstar", leading: blackIcon(Icons.star_outline)).onTap(() {
                              state(() {if( unsetStar(dataModel.url,dataModel.mimeType!)){
                                  
                                dataModel.isStared = false;
                                }
                                
                                finish(context);
                              });
                            })
                          : lisTileForFileEditingOption(title: "Star", leading: blackIcon(Icons.star)).onTap(() {
                              state(() {
                                if( setStar(dataModel.url,dataModel.mimeType!)){
                                  
                                dataModel.isStared = true;
                                }
                                finish(context);
                              });
                            }),
                      
                      

                      
                      dataModel.isShared
                          ? 0.height
                          : lisTileForFileEditingOption(
                              title: "Delete",
                              leading: const Icon(Icons.delete, color: Colors.red),
                              color: Colors.red,
                            ).onTap(
                              () async {
                                //success
                                bool isFileDeleted = await (buildDeleteDialog(context, dataModel));
                                if (isFileDeleted) {
                                  dataModel.isFolder?deleteFolder(dataModel.url!): deleteItem(dataModel.url!);
                                  
                                  getcloudList.removeWhere(
                                    (element) {
                                      return element.fileName == dataModel.fileName;
                                    },
                                  );
                                }
                                finish(context);
                              },
                            ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  );
}

Widget lisTileForFileEditingOption({required String title, String subTitle = "", Widget? trailing, Color? color, Widget? leading}) {
  return ListTile(
    contentPadding: const EdgeInsets.all(0),
    visualDensity: const VisualDensity(horizontal: -3, vertical: -4),
    title: Text(title, style: TextStyle(color: color.toString().isEmpty ? Colors.black : color)),
    subtitle: subTitle.isEmpty ? null : Text(subTitle),
    trailing: trailing,
    leading: leading,
  );
}

Widget blackIcon(IconData icon) {
  return Icon(
    icon,
    color: Colors.black,
  );
}
