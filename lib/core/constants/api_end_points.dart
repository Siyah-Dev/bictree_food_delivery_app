abstract final class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://dummyjson.com';

  // Authentication
  static const String login = '/auth/login';
  static const String currentUser = '/auth/me';

  // Recipes
  static const String recipes = '/recipes';
  static const String searchRecipes = '/recipes/search';

  static String recipeDetails(int id) => '/recipes/$id';
}