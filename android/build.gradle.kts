import com.android.build.api.dsl.LibraryExtension
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

group = "com.ristocloudgroup.lib.risto_widgets"
version = "1.0-SNAPSHOT"

apply(plugin = "com.android.library")
apply(plugin = "org.jetbrains.kotlin.android")

configure<LibraryExtension> {
    namespace = "com.ristocloudgroup.lib.risto_widgets"
    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        minSdk = 24
    }

    testOptions {
        unitTests {
            isIncludeAndroidResources = true
        }
    }
}

tasks.withType<KotlinCompile> {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
    }
}

tasks.withType<Test> {
    useJUnitPlatform()
    outputs.upToDateWhen { false }
    testLogging {
        events("passed", "skipped", "failed", "standardOut", "standardError")
        showStandardStreams = true
    }
}

dependencies {
    add("testImplementation", "org.jetbrains.kotlin:kotlin-test")
    add("testImplementation", "org.mockito:mockito-core:5.0.0")
}