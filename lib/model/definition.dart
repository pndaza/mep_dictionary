class Definition {
  int id;
  String my;
  String eng;
  String pli;

  Definition(this.id, this.my, this.eng, this.pli);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'my': my,
      'eng': eng,
      'pli': pli,
    };
  }

  Definition.fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.my = map['my'];
    this.eng =map['eng'];
    this.pli =map['pli'];
  }
}
