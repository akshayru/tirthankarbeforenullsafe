class MusicData {
  int id;
  // int indx;
  int pdfpage;
  int linkid;
  String title;
  String album;  
  String songURL;
  String hindiName;  
  String mname;
  String msign;
  String other1;
  String other2;
  String ename;
  String esign; 
  String language;
  String songtext;
  int isfave;

  MusicData(this.id,this.pdfpage,this.linkid, this.title, this.album, this.songURL,this.hindiName,this.mname,this.msign,this.other1,this.other2,this.ename,this.esign,
  this.language,this.songtext,this.isfave);

  

  factory MusicData.fromJson(dynamic json) {
    return MusicData(
      json['id'] as int,
      // json['indx'] as int,
      json['pdfpage'] as int, 
      json['linkid'] as int, 
      json['title'] as String, 
      json['album'] as String, 
      json['songURL'] as String, 
      json['hindiName'] as String,       
      json['mname'] as String,
      json['msign'] as String,
      json['other1'] as String,
      json['other2'] as String,
      json['ename'] as String,       
      json['esign'] as String,
      json['language'] as String,
      json['songtext'] as String,
      json['isfave'] as int); 
  }

   @override
  String toString() {
    return '{ ${this.id},${this.pdfpage},${this.linkid}, ${this.title},${this.album}, ${this.songURL}, ${this.hindiName},  ${this.mname} , ${this.msign}, ${this.other1} , ${this.other2}, ${this.ename} , ${this.esign} ,${this.language},${this.songtext},${this.isfave} }';
  }
   
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      // 'indx': indx,
      'pdfpage': pdfpage,
      'linkid': linkid,
      'title': title,
      'album': album,
      'songURL': songURL,
      'hindiName': hindiName,
      'mname': mname,
      'msign': msign,
      'other1': other1,
      'other2': other2,
      'ename': ename,
      'esign': esign,
      'language': language,
      'songtext': songtext,
      'isfave': isfave,
    };
  }

  MusicData fromMap(Map<String, dynamic> map) {    
      id = map['id'];
      // indx = map['indx'];
      pdfpage = map['pdfpage'];
      linkid = map['linkid'];
      title = map['title'];
      album = map['album'];
      songURL = map['songURL'];
      hindiName = map['hindiName'];
      mname = map['mname'];
      msign = map['msign'];
      other1 = map['other1'];
      other2 = map['other2'];
      ename = map['ename'];
      esign = map['esign'];
      language = map['language'];
      songtext = map['songtext'];
      isfave = map['isfave'];  
  }
   


}
  

