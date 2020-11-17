package com.redfive.squire

import com.graphql.spring.boot.test.GraphQLTest
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Test
import org.springframework.boot.test.context.SpringBootTest

@SpringBootTest
@GraphQLTest
class HelloQueryResolverTest {

  @Test
  fun helloTest() {
    assertTrue(true)
  }
}
