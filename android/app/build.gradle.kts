plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // ต้องอยู่ล่างสุดตาม Flutter ระบุ
}

android {
    namespace = "com.example.pj_app"
    compileSdk = 35 // ✅ ระบุ compileSdk ตรงนี้แบบชัดเจน

    ndkVersion = "23.1.7779620" // ✅ ระบุ ndkVersion ชัดเจนหรือใช้ของ flutter ถ้ารองรับ

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.pj_app"
        minSdk = 21 // ✅ แนะนำให้ใช้เลขตรงไปเลยแทน flutter.minSdkVersion
        targetSdk = 33
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
