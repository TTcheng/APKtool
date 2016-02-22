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
    engine.loadData(QByteArray::fromBase64("aW1wb3J0IFF0UXVpY2sgMi41CmltcG9ydCBRdFF1aWNrLkNvbnRyb2xzIDEuNAoKSXRlbSB7CiAg\
                                           ICBpZDogcm9vdEl0ZW0KICAgIHN0YXRlOiBrZXkuaXNSZWdpc3RlcmQoKT8ibWFpbiI6InNwbGFz\
                                           aCIKICAgIExvYWRlciB7CiAgICAgICAgaWQ6IG1haW5Mb2FkZXIKICAgIH0KICAgIHN0YXRlczog\
                                           WwogICAgICAgIFN0YXRlIHsKICAgICAgICAgICAgbmFtZTogInNwbGFzaCIKICAgICAgICAgICAg\
                                           UHJvcGVydHlDaGFuZ2VzIHsKICAgICAgICAgICAgICAgIHRhcmdldDogbWFpbkxvYWRlcgogICAg\
                                           ICAgICAgICAgICAgc291cmNlOiAicXJjOi9TcGxhc2gucW1sIgogICAgICAgICAgICB9CiAgICAg\
                                           ICAgfSwKICAgICAgICBTdGF0ZSB7CiAgICAgICAgICAgIG5hbWU6ICJtYWluIgogICAgICAgICAg\
                                           ICBQcm9wZXJ0eUNoYW5nZXMgewogICAgICAgICAgICAgICAgdGFyZ2V0OiBtYWluTG9hZGVyCiAg\
                                           ICAgICAgICAgICAgICBzb3VyY2U6ICJxcmM6L0ZpbGVzTGlzdC5xbWwiCiAgICAgICAgICAgIH0K\
                                           ICAgICAgICB9CiAgICBdCgogICAgVGltZXIgewogICAgICAgIGludGVydmFsOiAoa2V5LnJ1bkNv\
                                           dW50KCkrNCkqMTAwMDsKICAgICAgICBydW5uaW5nOiB0cnVlOwogICAgICAgIG9uVHJpZ2dlcmVk\
                                           OiByb290SXRlbS5zdGF0ZSA9ICJtYWluIjsKICAgIH0KCn0KCg=="));
    return app.exec();
}

