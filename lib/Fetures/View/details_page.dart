import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PokemonDetailPage extends StatelessWidget {
  final dynamic pokemon;

  PokemonDetailPage({required this.pokemon});

  bool isEmty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pokemon['name'])),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isEmty
              ? CircularProgressIndicator()
              : Image(image: NetworkImage(pokemon['image'])),
          // Image.network(pokemon['image']),
          Text('ID: ${pokemon['id']}'),
          Text(
              'Weight: ${pokemon['weight']['minimum']} - ${pokemon['weight']['maximum']}'),
          Text(
              'Height: ${pokemon['height']['minimum']} - ${pokemon['height']['maximum']}'),
          Text('Classification: ${pokemon['classification']}'),
        ],
      ),
    );
  }
}
