class Contact {
  static const tblContact = 'contacts';//table name
  static const colId = 'id'; //1st col
  static const colName = 'name'; //2nd col
  static const colMobile = 'mobileNumber'; //3rd col

  int id;
  String name;
  String mobileNumber;

  Contact({
    this.id,
    this.name,
    this.mobileNumber,
  });

  Contact.formMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    mobileNumber = map[colMobile];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colName: name,
      colMobile: mobileNumber,
    };
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}
