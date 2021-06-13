import graphene
from graphql_auth.schema import UserQuery, MeQuery
from graphql_auth import mutations
import examaltersys.schema


class Query(examaltersys.schema.Query, graphene.ObjectType):
    pass


class Mutation(examaltersys.schema.Mutation, graphene.ObjectType):
    pass


schema = graphene.Schema(query=Query, mutation=Mutation)
