import 'dart:async';
import 'dart:io';
import 'dart:math'as math;
import 'dart:typed_data';
import 'package:cloud/model/Model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud/utils/Images.dart';
import 'package:cloud/utils/otherUtils.dart';
import 'package:cloud/main.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:os_mime_type/os_mime_type.dart';


const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');
bool _first=false;
bool _firstFull=false;
    final user = FirebaseAuth.instance.currentUser;

  final storageRef = FirebaseStorage.instance.ref();
Future<bool> getFirst()async{
  if( !(_first)){

  bool result=await getDataFromCloud();
    _first=true;
    return result;
  }
  return false;
}
Future<bool> getFirstFull(loc)async{
  if( !(_firstFull)){
  await getFullList(loc);
    _firstFull=true;
    return true;
  }
  return false;
}


Future<bool> getDataFromCloud() async{
  try {
    getcloudList.clear();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final uploadsRefs = storageRef.child("$userId/uploads");
    final uploads = await uploadsRefs.listAll();
    await Future.forEach(uploads.items,insertFile);
    uploads.prefixes.forEach(insertFolder);
    return true;
  } catch (e) {
  }
    return false;

}

void insertFile(item)async {
    if (item.name!='ignore.me'){

    FullMetadata mData= await item.getMetadata();
    bool star=false;
    try{ star=bool.parse(mData.customMetadata.toString().split(': ').last.split('}').first);}catch(e){}
    var temp=mData.timeCreated!;
    String time = DateFormat("dd-MM-yy HH:mm").format(temp);
    const suffixes = ["b", "KB", "MB", "gb", "tb"];
    int bytes=mData.size!;
    String size='0${suffixes[0]}';
    if (bytes != 0) {
    var i = (math.log(bytes) / math.log(1024)).floor();
    size= ((bytes / math.pow(1024, i))).toStringAsFixed(1) + suffixes[i];
    }
    String image=getImage(mData.contentType!);
    getcloudList.add(DataModel(isStared: star,url:item.fullPath,fileName: item.name, mimeType: mData.contentType!,fileUrl:image,time: time,size1: size,size: mData.size!,downloadUrl: await item.getDownloadURL()));
    }
}
void insertFolder(item) {
    getcloudList.add(DataModel(fileName: item.name, isFolder: true,fileUrl:CSFolderIcon,url:item.fullPath,size: 0,time: '0'));
}
void uploadProfile(BuildContext context,Function refresh) async {
  try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
    final uploadRef = storageRef.child("${user!.uid}/profile");
dynamic uploadtask;
  if (result != null && result.files.isNotEmpty) {
  if(kIsWeb){
  final fileBytes = result.files.first.bytes!;
   uploadtask=  uploadRef.putData(fileBytes,SettableMetadata(
    contentType: 'image/jpeg',
  ));
  final snapshot = await uploadtask.whenComplete(() => null);
  String downloadUrl = await snapshot.ref.getDownloadURL();
    await user!.updatePhotoURL(downloadUrl);
  }else{
  File file = File(result.files.single.path!);

    uploadtask= uploadRef.putFile(file,SettableMetadata(
    contentType: 'image/jpeg',
  ));
    final snapshot = await uploadtask.whenComplete(() => null);
  String downloadUrl = await snapshot.ref.getDownloadURL();
    await user!.updatePhotoURL(downloadUrl);
    refresh();

  }
  }} catch (e) {
  }
}



Future<bool> uploadImage(BuildContext context,String loc) async {
  try {

  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null && result.files.isNotEmpty) {

  final fileBytes = result.files.first.bytes!;
  final fileName = result.files.first.name;
    final uploadRef = storageRef.child("$loc/$fileName");
    String fileType=mimeFromFileName(fileName: fileName);
    if(fileType=='unknown'){fileType='application/octet-stream';}
    final uploadTask= uploadRef.putData(fileBytes,SettableMetadata(
    contentType: fileType,
    customMetadata: {"isStared":"false"},
  ));
  uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
  switch (taskSnapshot.state) {
    case TaskState.running:
      final progress =
          (100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes)).round();
      Fluttertoast.showToast(msg:"Upload is $progress% complete.");
      break;
    case TaskState.paused:
      break;
    case TaskState.canceled:
      break;
    case TaskState.error:
      toast("Upload failed");
    case TaskState.success:
      toast("Upload ${fileName} success");
      break;
  }
});
 

  }
  } catch (e) {
  }
  return false;
}
Future<bool> getFolderData(String loc) async{
  try {
    getcloudList.clear();
    final uploadsRefs = storageRef.child(loc);
    final uploads = await uploadsRefs.listAll();
    await Future.forEach(uploads.items,insertFile);
    uploads.prefixes.forEach(insertFolder);
    return true;
  } catch (e) {
  }
  return false;
}




setFalse(){
  _first=false;
}



bool setStar( loc,String mime){
  try{
final fileRef = storageRef.child(loc);
final newMetadata = SettableMetadata(
  contentType: mime,
  customMetadata: {"isStared":"true"},
);
      fileRef.updateMetadata(
        newMetadata
      );
      return true;
  }catch(e){
  }
  return false;
}
bool unsetStar( loc,String mime){
  try{
final fileRef = storageRef.child(loc);
final newMetadata = SettableMetadata(
  contentType: mime,
  customMetadata: {"isStared":"false"},
);
      fileRef.updateMetadata(
        newMetadata
      );
      return true;
  }catch(e){
  }
  return false;
}


Future<bool> createFolder(String loc,String filename)async{
  try {

    final List<int> codeUnits = 'ignore'.codeUnits;
    final Uint8List unit8List = Uint8List.fromList(codeUnits);

    final uploadRef = storageRef.child("$loc/$filename/ignore.me");
    await uploadRef.putData(unit8List);
    return true;
  }
  
   catch (e) {
  }
  return false;

}


Future<void> getFullList(loc)async{
 try {
    final uploadsRefs = storageRef.child(loc);
    final uploads = await uploadsRefs.listAll();

    await Future.forEach(uploads.items,(item)async{
      if (item.name!='ignore.me'){

    FullMetadata mData= await item.getMetadata();
    bool star=false;
    try{ star=bool.parse(mData.customMetadata.toString().split(': ').last.split('}').first);}catch(e){}
    var temp=mData.timeCreated!;
    String time = DateFormat("HH:mm dd-MM-yy").format(temp);
    const suffixes = ["b", "KB", "MB", "gb", "tb"];
    int bytes=mData.size!;
    String size='0${suffixes[0]}';
    if (bytes != 0) {
    var i = (math.log(bytes) / math.log(1024)).floor();
    size= ((bytes / math.pow(1024, i))).toStringAsFixed(1) + suffixes[i];
    }
    String image=getImage(mData.contentType!);
    getfullList.add(DataModel(isStared: star,url:item.fullPath,fileName: item.name, mimeType: mData.contentType!,fileUrl:image,time: time,size1: size,size: mData.size!,downloadUrl: await item.getDownloadURL()));
      }
    });
    await Future.forEach(uploads.prefixes,(item){
    getfullList.add(DataModel(fileName: item.name, isFolder: true,fileUrl:CSFolderIcon,url:item.fullPath,size: 0,time: '0'));

      getFullList(item.fullPath);
    });
  } catch (e) {
  }

}
Future<bool>deleteItem(loc)async{
final fileRef = storageRef.child(loc);

await fileRef.delete();
  return true;
}
Future<bool>deleteFolder(loc)async{
    final  deleteRef= storageRef.child(loc);
    final deletes = await deleteRef.listAll();
    await Future.forEach(deletes.prefixes,(item){
      deleteFolder(item.fullPath);
    });
  await Future.forEach(deletes.items,(item)async{
    deleteItem(item.fullPath);
  });
    return true;
}

Future<bool>renameItem(loc)async{

  return true;
}
Future<bool>copyItem()async{
  return true;
}
Future<bool>moveItem()async{
  return true;
}

