//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:tirthankar/core/const.dart';

class Pdfview extends StatefulWidget {
  // int playingId;
  int pdfpage;
  String appname;

  // List<MusicData> list;
  Pdfview({this.appname, this.pdfpage});

  @override
  _PdfviewState createState() => _PdfviewState(appname, pdfpage);
}

class _PdfviewState extends State<Pdfview> {
  String appname;
  int pdfpage;
  
  // PDFDocument document;

  _PdfviewState(this.appname, this.pdfpage);



  int _actualPageNumber = 1, _allPagesCount = 0;
  PdfController _pdfController;

  @override
  void initState() {
    _pdfController = PdfController(
      document: PdfDocument.openAsset('assets/jainaarti.pdf'),
        initialPage: pdfpage
    );
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(primaryColor: Colors.white),
    home: Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.styleColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: (){                      
            Navigator.of(context).pop(false);     
          },
        ),
        title: Text(
          "Tirthankar",
          style: TextStyle(color: Colors.white),
        ),
      ),
//      appBar: AppBar(
//        title: Text('PdfView example'),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.navigate_before),
//            onPressed: () {
//              _pdfController.previousPage(
//                curve: Curves.ease,
//                duration: Duration(milliseconds: 100),
//              );
//            },
//          ),
//          Container(
//            alignment: Alignment.center,
//            child: Text(
//              '$_actualPageNumber/$_allPagesCount',
//              style: TextStyle(fontSize: 22),
//            ),
//          ),
//          IconButton(
//            icon: Icon(Icons.navigate_next),
//            onPressed: () {
//              _pdfController.nextPage(
//                curve: Curves.ease,
//                duration: Duration(milliseconds: 100),
//              );
//            },
//          ),
//        ],
//      ),
      body: PdfView(
        documentLoader: Center(child: CircularProgressIndicator()),
        pageLoader: Center(child: CircularProgressIndicator()),
        controller: _pdfController,

//          _pdfController.jumpToPage(10);
        onDocumentLoaded: (document) {
//          _pdfController.jumpToPage(10);
          setState(() {
            _allPagesCount = document.pagesCount;
          });
        },
        onPageChanged: (page) {
          setState(() {
            _actualPageNumber = page;
          });
        },
      ),
    ),
  );

}
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(home: Scaffold(body: Column(children: <Widget>[
//      Expanded(child: Center(
//        child: _isInit ? Text('Press Button to Load')
//            : _isLoading
//        ? Center(
//          child: CircularProgressIndicator(),
//        )
//        :PDFViewer(document: document,
//        )
//      ),
//      ),
//      Row(
//        mainAxisSize: MainAxisSize.max,
//        children: <Widget>[
//          Expanded(child: MaterialButton(
//            child: Text('URL'),
//            onPressed: (){
//              loadFromAssets();
//            },
//          ))
//        ],
//      )
//
//    ],),),
//
//
//    );
//  }
//  loadFromAssets() async{
//    setState(() {
//      _isInit = false;
//      _isLoading = true;
//    });
//    document = await PDFDocument.fromAsset("assets/10.pdf");
//    setState(() {
//      _isLoading=false;
//    });
//
//  }
//}


