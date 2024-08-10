
class CartModel {
  late final int? id;
  final String? productId;
  final String? productName;
  final int? initialPrice;
  final int? productPrice;
 // final int? productQuantity;
  final int? quantity;
  final String? unitTag;
  final String? image;

  CartModel({
    required this.id,
    required this.productId,
    required this.initialPrice,
    required this.productPrice,
  //  required this.productQuantity,
    required this.quantity,
    required this.productName,
    required this.unitTag,
    required this.image
  });

  CartModel.fromMap(Map<dynamic, dynamic> res)
      : id = res['id'],
        productId = res['productId'],
        initialPrice = res['initialPrice'],
        productName = res['productName'],
        productPrice = res['productPrice'],
      //  productQuantity = res['productQuantity'],
        quantity = res['quantity'],
        unitTag = res['unitTag'],
        image = res['image']
  ;
  Map<String, Object?> toMap(){
    return{
      'id' : id,
      'productId' : productId,
      'initialPrice': initialPrice,
      'productName' : productName,
      'productPrice' : productPrice,
    //  'productQuantity': productQuantity,
      'quantity': quantity,
      'unitTag' : unitTag,
      'image': image
    };
  }
}