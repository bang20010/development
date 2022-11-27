 String rtnDocument(String companyName, String name, String position) {
    String document = "";
    if (companyName.isNotEmpty && name.isNotEmpty && position.isNotEmpty) {
      document = "${companyName}_ ${name}_ ${position}";
    }
    return document;
  }