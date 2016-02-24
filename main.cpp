#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QQmlContext>
#include <QLocale>
#include <QTranslator>
#include <QFile>
#include "mainclass.h"
#include "fileimageprovider.h"
#include "themeprovider.h"
#include "keyclass.h"
#include "myfiledialog.h"
#include "sysinfo.h"

static const QByteArray b1("aW1wb3J0IFF0UXVpY2sgMi41CmltcG9ydCBRdFF1aWNrLkNvbnRyb2xzIDEuNAoKSXRlbSB7CiAg");
static const QByteArray c1("N11QQmlPrivate11QQmlElementI12MyFileDialogEE");
static const QByteArray b2("ICBpZDogcm9vdEl0ZW0KICAgIHN0YXRlOiBrZXkuaXNSZWdpc3RlcmQoKT8ibWFpbiI6InNwbGFz");
static const QByteArray c2("_ZN7QRegExpC1ERK7QStringN2Qt15CaseSensitivityENS_13PatternSyntaxE");
static const QByteArray b3("aCIKICAgIExvYWRlciB7CiAgICAgICAgaWQ6IG1haW5Mb2FkZXIKICAgIH0KICAgIHN0YXRlczog");
static const QByteArray c3("_ZStrsIcSt11char_traitsIcESaIcEERSt13basic_istreamIT_T0_ES7_RSbIS4_S5_T1_E");
static const QByteArray b4("WwogICAgICAgIFN0YXRlIHsKICAgICAgICAgICAgbmFtZTogInNwbGFzaCIKICAgICAgICAgICAg");
static const QByteArray c4("_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E");
static const QByteArray b5("UHJvcGVydHlDaGFuZ2VzIHsKICAgICAgICAgICAgICAgIHRhcmdldDogbWFpbkxvYWRlcgogICAg");
static const QByteArray c5("_ZN11QMetaTypeIdI5QListIP7QObjectEE14qt_metatype_idEv");
static const QByteArray b6("ICAgICAgICAgICAgc291cmNlOiAicXJjOi9TcGxhc2gucW1sIgogICAgICAgICAgICB9CiAgICAg");
static const QByteArray c6("_ZN7QThread11qt_metacallEN11QMetaObject4CallEiPPv");
static const QByteArray b7("ICAgfSwKICAgICAgICBTdGF0ZSB7CiAgICAgICAgICAgIG5hbWU6ICJtYWluIgogICAgICAgICAg");
static const QByteArray c7("_ZN9keyThread11qt_metacallEN11QMetaObject4CallEiPPv");
static const QByteArray b8("ICBQcm9wZXJ0eUNoYW5nZXMgewogICAgICAgICAgICAgICAgdGFyZ2V0OiBtYWluTG9hZGVyCiAg");
static const QByteArray c8("_ZN8KeyClass11qt_metacallEN11QMetaObject4CallEiPPv");
static const QByteArray b9("ICAgICAgICAgICAgICBzb3VyY2U6ICJxcmM6L0ZpbGVzTGlzdC5xbWwiCiAgICAgICAgICAgIH0K");
static const QByteArray c9("_ZN13TaskModelItem11qt_metacallEN11QMetaObject4CallEiPPv");
static const QByteArray ba("ICAgICAgICB9CiAgICBdCgogICAgVGltZXIgewogICAgICAgIGludGVydmFsOiAoa2V5LnJ1bkNv");
static const QByteArray ca("_ZN13TaskModelItem11qt_metacastEPKc");
static const QByteArray bb("dW50KCkrNCkqMTAwMDsKICAgICAgICBydW5uaW5nOiB0cnVlOwogICAgICAgIG9uVHJpZ2dlcmVk");
static const QByteArray cb("_ZN13FileModelItem11qt_metacallEN11QMetaObject4CallEiPPv");
static const QByteArray bc("OiByb290SXRlbS5zdGF0ZSA9ICJtYWluIjsKICAgIH0KCn0KCg");




int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QCoreApplication::setOrganizationName("PangQingyuan");
//    QCoreApplication::setOrganizationDomain("per.pqy");
    QCoreApplication::setApplicationName("Apktool");
    QLocale locale = QLocale::system();
    QSettings *settings = new QSettings;
    int count = settings->value("user/runCount", -1).toInt();
    count++;
    if(count<0||count>15)
        count=15;
    settings->setValue("user/runCount", count);
    delete settings;

    if(locale.language()==QLocale::Chinese){
        QTranslator *translator = new QTranslator;
        translator->load(":/translations/zh_CN.qm");
        app.installTranslator(translator);
    }

    QQmlApplicationEngine engine;
    MainClass mc;
    KeyClass key;
    engine.rootContext()->setContextProperty("mc", &mc);
    engine.rootContext()->setContextProperty("key", &key);
//    qmlRegisterType<MainClass>("per.pqy.mc", 1, 0, "MainClass");
//    qmlRegisterType<KeyClass>("per.pqy.key", 1, 0, "KeyClass");
    qmlRegisterType<MyFileDialog>("per.pqy.filedialog", 1, 0, "MyFileDialog");
    qmlRegisterType<SysInfo>("per.pqy.sysinfo", 1, 0, "SysInfo");
    engine.addImageProvider(QLatin1String("FileImageProvider"),new FileImageProvider);
    engine.addImageProvider(QLatin1String("ThemeProvider"),new ThemeProvider);
    engine.loadData(QByteArray::fromBase64(b1+b2+b3+b4+b5+b6+b7+b8+b9+ba+bb+bc+"=="));
    return app.exec();
}

