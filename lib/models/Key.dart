class KeyObject{
  int keyId;
  String manufactor;
  String model;
  String type;
  String serviceType;
  String year;
  double price;
  int quantity;
  int buttons;
  String observation;
  String imagePath;

  KeyObject(this.keyId, this.manufactor, this.model, this.type, this.serviceType, this.year, this.price, this.quantity, this.buttons, this.observation, this.imagePath);

  KeyObject.fromJson(Map<String, dynamic> json){

      keyId = json['id'];
      manufactor = json['manufactor'];
      model = json['model'];
      type = json['type'];
      serviceType = json['serviceType'];
      year = json['year'];
      price = json['price'];
      buttons = json['buttons'];
      quantity = json['quantity'];
      imagePath = json['image'];
      observation = json['observation'];
  }
}