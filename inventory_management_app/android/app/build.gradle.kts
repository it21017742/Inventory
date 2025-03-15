plugins {
    id("com.android.application")
    id("com.google.gms.google-services")  // Firebase plugin
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")  // Flutter plugin
}

android {
    namespace = "com.example.inventory_management_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.inventory_management_app"  // Correct application ID
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")  // Default signing config for debug
        }
    }
}

flutter {
    source = "../.."  // Ensure the Flutter source path is correct
}
