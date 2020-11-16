package com.redfive.squire

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.RequestParam

@SpringBootApplication
class SquireApplication

fun main(args: Array<String>) {
    runApplication<SquireApplication>(*args)
}

@RestController
class HelloController {

  @GetMapping
  fun helloWorld(@RequestParam(name = "name", defaultValue = "") name: String): String {
    if (name != "") {
      return "Hi, ${name}."
    }
    return "Hello world!"
  }
}