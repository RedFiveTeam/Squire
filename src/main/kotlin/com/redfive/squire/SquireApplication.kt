package com.redfive.squire

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class SquireApplication

fun main(args: Array<String>) {
    runApplication<SquireApplication>(*args)
}
