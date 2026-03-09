plugins {
    kotlin("jvm") version "1.9.23"
    application
}

group = "com.gradecalculator"
version = "1.0.0"

repositories {
    mavenCentral()
}

dependencies {
    // Apache POI for Excel (.xlsx) read/write
    implementation("org.apache.poi:poi-ooxml:5.2.5")
    // Kotlin stdlib
    implementation(kotlin("stdlib"))
}

application {
    mainClass.set("GradeCalculatorKt")
}

// Build fat jar (includes all dependencies)
tasks.jar {
    manifest { attributes["Main-Class"] = "GradeCalculatorKt" }
    from(configurations.runtimeClasspath.get().map { if (it.isDirectory) it else zipTree(it) })
    duplicatesStrategy = DuplicatesStrategy.EXCLUDE
}
