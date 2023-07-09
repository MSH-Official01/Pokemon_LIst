import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Fetures/View/pokemon_view.dart';

void main() {
  runApp(PokemonApp());
}

class PokemonApp extends StatelessWidget {
  final HttpLink httpLink = HttpLink('https://graphql-pokemon2.vercel.app/');

  final ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink('https://graphql-pokemon2.vercel.app/'),
    ),
  );

  Future<void> initGraphQLClient() async {
    await initHiveForFlutter();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? token = prefs.getString('token');

    final AuthLink authLink = AuthLink(getToken: () => 'Bearer $token');
    final Link link = httpLink as Link;

    client.value = GraphQLClient(
      cache: GraphQLCache(),
      link: authLink.concat(link),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initGraphQLClient(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        return GraphQLProvider(
          client: client,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Pokemon App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            
            home: HomePage(),
          ),
        );
      },
    );
  }
}