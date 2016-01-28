TEMPLATE = app

QT += qml quick
android-g++:QT += androidextras
CONFIG += c++11

SOURCES += main.cpp \
    mainclass.cpp \
    fileimageprovider.cpp \
    keyclass.cpp \
    keythread.cpp \
    themeprovider.cpp \
    myfiledialog.cpp \
    sysinfo.cpp

RESOURCES += \
    apktool.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    NewDialog.qml \
    android/src/per/pqy/apktool/Extra.java

HEADERS += \
    mainclass.h \
    filemodelitem.h \
    taskmodelitem.h \
    fileimageprovider.h \
    keyclass.h \
    keythread.h \
    themeprovider.h \
    myfiledialog.h \
    sysinfo.h

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

lupdate_only{
SOURCES = *.qml 
}

TRANSLATIONS += \
    translations/zh_CN.ts

#FORMS += \
#    txteditor.ui
