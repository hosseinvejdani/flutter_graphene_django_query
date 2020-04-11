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
  Map<String, List<dynamic>> data = Map();
  //
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
      body: Center(
        child: Query(
          options: QueryOptions(
            // this is the query string you just created
            documentNode: gql(query),
          ),
          builder: (QueryResult result,
              {VoidCallback refetch, FetchMore fetchMore}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.loading) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: result.data["products"].length,
              itemBuilder: (BuildContext context, int index) {
                print(result.data.runtimeType);
                return Center(
                    child: Text(result.data["products"][index]["name"]));
              },
            );
          },
        ),
      ),
    );
  }
}
