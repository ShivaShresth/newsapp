import 'package:newsapi/models/category_model.dart';

List<CategoryModel> getCategories(){  
  List<CategoryModel> category=[];
  CategoryModel categoryModel=new CategoryModel();

  categoryModel.categoryName="Business";
  categoryModel.image="assets/a.jpeg";
  category.add(categoryModel);
  categoryModel=new CategoryModel();

  categoryModel.categoryName="Entertainment";
  categoryModel.image="assets/a.jpeg";
  category.add(categoryModel);
  categoryModel=new CategoryModel();

  categoryModel.categoryName="General";
  categoryModel.image="assets/a.jpeg";
  category.add(categoryModel);
  categoryModel=new CategoryModel();

  categoryModel.categoryName="Health";
  categoryModel.image="assets/a.jpeg";
  category.add(categoryModel);
  categoryModel=new CategoryModel();

  categoryModel.categoryName="Sports";
  categoryModel.image="assets/a.jpeg";
  category.add(categoryModel);
  categoryModel=new CategoryModel();

  return category;

}