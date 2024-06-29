import 'package:cloud/utils/Images.dart';


String getImage(mime){
  String image=CSDefaultImg;
  try{switch (mime.split('/').first) {
    case 'image':
      image=CSPhotoImg;
      break;
    case 'application':
      image=CSAppImg;
      break;
    case 'audio':
      image=CSMusicImg;
      break;
    case 'video':
      image=CSVideoImg;
      break;
    case 'text':
      image=CSFileImg;
      break;
  }
  }catch(e){
    
  }
  return image;
}