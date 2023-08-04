// ignore: file_names
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applications/colors/app_constants.dart';
import 'package:flutter_applications/colors/colors.dart';
import 'package:flutter_applications/colors/dimensions.dart';
import 'package:flutter_applications/data/controllers/product_controller.dart';
import 'package:flutter_applications/models/products.dart';
import 'package:flutter_applications/screens/icon_and_text_widget.dart';
import 'package:flutter_applications/widget/big_text.dart';
import 'package:flutter_applications/widget/small_text.dart';
import 'package:get/get.dart';

import '../data/controllers/recommended_product_controller.dart';
import '../routes/route_helper.dart';
import '../widget/app_column.dart';
import '../widget/expandable_text.dart';

class FoodItem extends StatefulWidget {
  const FoodItem({super.key});
  @override
  _FoodPageBodyState createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodItem> {
  PageController pageController = PageController(viewportFraction: 0.9);
  var _currPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _height = Dimensions.pageViewContainer;
  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder<ProductController>(builder: (popularProducts){
          return popularProducts.isLoaded?Container(
          height: Dimensions.pageView,
          child: GestureDetector(
            onTap: (){
              Get.toNamed(RouterHelper.popularfood);
            },
            child: PageView.builder(
                controller: pageController,
                itemCount: popularProducts.ProductList.length,
                itemBuilder: (context, position) {
                  return _buildPageItem(position,popularProducts.ProductList[position]);
                }),
          ),
        ): CircularProgressIndicator(color: AppColors.mainColor,);
        }),
        GetBuilder<ProductController>(builder: (popularProducts){
          return DotsIndicator(
            dotsCount: popularProducts.ProductList.length<=0?1:popularProducts.ProductList.length,
            position: _currPageValue,
            decorator: DotsDecorator(
              activeColor: AppColors.mainColor,
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          );
        }),
        SizedBox(
          height: Dimensions.height20,
        ),
        //Popular text
        Container(
          margin: EdgeInsets.only(left: Dimensions.width30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BigText(text: "Recommended"),
              SizedBox(
                width: Dimensions.width10,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 3),
                child: BigText(
                  text: ".",
                  color: Colors.black26,
                ),
              ),
              SizedBox(
                width: Dimensions.width10,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 2),
                child: SmallText(
                  text: "Food Pairing",
                  color: Colors.black26,
                ),
              ),
            ],
          ),
        ),
        //List of food
             GetBuilder<RecommendedProductController>(builder: (recommendedProduct){
                 return recommendedProduct.isLoaded?ListView.builder(
                  itemCount: recommendedProduct.RecommendedProductList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(
                          left: Dimensions.width20, right: Dimensions.width20,bottom: Dimensions.width10),
                      child: Row(
                        children: [
                          //image section
                          Container(
                            width: Dimensions.listViewImgSize,
                            height: Dimensions.listViewImgSize,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius20),
                                    color: Colors.white38,
                                    image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      AppConstants.BASE_URL+AppConstants.UPLOAD_URL+recommendedProduct.RecommendedProductList[index].img!
                                    )
                                    )
                                    ),
                          ),
                      //text section
                      Expanded(
                        child: Container(
                          height: Dimensions.listViewTextConstSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(Dimensions.radius20),
                              bottomRight: Radius.circular(Dimensions.radius20),
                            ),
                            color: Colors.white,
                      
                          ),
                          child: Padding(padding: EdgeInsets.only(left: Dimensions.width10,right: Dimensions.width10,top: Dimensions.height10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BigText(text: recommendedProduct.RecommendedProductList[index].name!),
                               SizedBox(height: Dimensions.height10),
                              SmallText(text: "with japanese characteristics"),
                              // ExpandableTextWidget(text: recommendedProduct.RecommendedProductList[index].description!),
                              SizedBox(height: Dimensions.height10),
                               Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconAndTextWidget(
                            icon: Icons.circle_sharp,
                            text: "Normal",
                            iconColor: AppColors.iconColor1),
                        IconAndTextWidget(
                            icon: Icons.location_on,
                            text: "1.7km",
                            iconColor: AppColors.mainColor),
                        IconAndTextWidget(
                            icon: Icons.access_time_rounded,
                            text: "32min",
                            iconColor: AppColors.iconColor2),
                      ],
                    ),
                            ],
                          ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }):CircularProgressIndicator(color: AppColors.mainColor,);


               })


       
      ],
    );
  }

  Widget _buildPageItem(int index, ProductModel popularproductList) {
    Matrix4 matrix = new Matrix4.identity();
    if (index == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() - 1) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor), 0);
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          Container(
            height: Dimensions.pageViewContainer,
            margin: EdgeInsets.only(
                left: Dimensions.width10, right: Dimensions.width10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius30),
              color: index.isEven
                  ? const Color(0xFF69c5df)
                  : const Color(0xFF9294cc),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                 AppConstants.BASE_URL+AppConstants.UPLOAD_URL+popularproductList.img!
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Dimensions.pageViewTextContainer,
              margin: EdgeInsets.only(
                  left: Dimensions.width30,
                  right: Dimensions.width30,
                  bottom: Dimensions.width30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0xFFe8e8e8),
                        blurRadius: 5.0,
                        offset: Offset(0, 5)),
                  ]),
              child: Container(
                padding: EdgeInsets.only(
                    top: Dimensions.height15,
                    left: Dimensions.height20,
                    right: Dimensions.height20,
                    bottom: Dimensions.height10),
                child:AppColumn(text: popularproductList.name!,),
              ),
            ),
          )
        ],
      ),
    );
  }
}
