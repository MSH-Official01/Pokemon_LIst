import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;

import 'details_page.dart';

class HomePage extends StatelessWidget {
  bool isEmty = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pokemon List')),
      body: Query(
        options: QueryOptions(document: gql('''
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
        ''')),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final List<dynamic> pokemons = result.data!['pokemons'];

          return ListView.builder(
            itemCount: pokemons.length,
            itemBuilder: (BuildContext context, int index) {
              final pokemon = pokemons[index];

              return ListTile(
                leading: isEmty
                    ? CircularProgressIndicator()
                    : Image(image: NetworkImage(pokemon['image'])),
                // leading: Image.network(pokemon['image']),
                title: Text(pokemon['name']),
                subtitle: Text('ID: ${pokemon['id']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PokemonDetailPage(pokemon: pokemon),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
