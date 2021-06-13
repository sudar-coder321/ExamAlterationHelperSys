import 'package:graphql/client.dart';

class GraphQL {
  //http://65.0.80.8
  final baseURL = 'http://127.0.0.1:8000/graphql';

  GraphQLClient getClient() => GraphQLClient(
        cache: GraphQLCache(),
        link: HttpLink(baseURL).concat(null),
      );
}

extension Graph on GraphQLClient {
  Future queryCharacter(String query) {
    final String readCharacter = query;
    return this.query(QueryOptions(
      document: gql(readCharacter),
    ));
  }
}
