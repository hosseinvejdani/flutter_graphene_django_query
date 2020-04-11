import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'config/client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: Config.initailizeClient(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String query = '''
  query{
    products{
      id
      name
    }
  }
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('graphene query test...'),
      ),
      body: Query(
        options: QueryOptions(
          documentNode: gql(query), // this is the query string you just created
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.loading) {
            return Center(child: CircularProgressIndicator());
          }
          // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
          // print((result.data["products"].length));
          return ListView.builder(
            itemCount: result.data["products"].length,
            itemBuilder: (BuildContext context, int index) {
              return Center(child: Text(result.data["products"][index]["name"]));
            },
          );
        },
      ),
    );
  }
}
