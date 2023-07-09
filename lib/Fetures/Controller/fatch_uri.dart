import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart' as http;

class GraphQLService {
  static final HttpLink _httpLink =
      HttpLink('https://graphql-pokemon2.vercel.app/');

  static final GraphQLClient _client = GraphQLClient(
    cache: GraphQLCache(),
    link: _httpLink,
  );

  static Future<List<dynamic>> fetchPokemons() async {
    const String pokemonsQuery = '''
      query GetPokemons {
        pokemons(first: 20) {
          id
          name
          weight {
            minimum
            maximum
          }
          height {
            minimum
            maximum
          }
          classification
          image
        }
      }
    ''';

    final QueryOptions options = QueryOptions(document: gql(pokemonsQuery));

    final QueryResult result = await _client.query(options);

    if (result.hasException) {
      throw result.exception!;
    }

    return result.data!['pokemons'];
  }
}
