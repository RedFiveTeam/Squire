package com.redfive.squire

import org.springframework.stereotype.Component
import graphql.kickstart.tools.GraphQLQueryResolver

@Component
class HelloQueryResolver() : GraphQLQueryResolver {
  fun hello(): String {
    return "Hello from GraphQL!"
  }
}