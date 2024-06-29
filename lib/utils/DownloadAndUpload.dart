import 'dart:html' as html;

Future<void> handleDownload(String uri,String filename)async {
     html.AnchorElement anchorElement =  new html.AnchorElement(href: uri)..target='blank';
   anchorElement.download = filename;
   anchorElement.click();
}
  Future<void> handleDownloadApp()async {
     html.AnchorElement anchorElement =  new html.AnchorElement(href:"https://firecloud-v2.web.app")..target='blank';

   anchorElement.click();
}


  




