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
#include "settings.h"



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
    Settings st;
    engine.rootContext()->setContextProperty("mc", &mc);
    engine.rootContext()->setContextProperty("key", &key);
    engine.rootContext()->setContextProperty("settings", &st);
//    qmlRegisterType<MainClass>("per.pqy.mc", 1, 0, "MainClass");
//    qmlRegisterType<KeyClass>("per.pqy.key", 1, 0, "KeyClass");
    qmlRegisterType<MyFileDialog>("per.pqy.filedialog", 1, 0, "MyFileDialog");
    qmlRegisterType<SysInfo>("per.pqy.sysinfo", 1, 0, "SysInfo");
    engine.addImageProvider(QLatin1String("FileImageProvider"),new FileImageProvider);
    engine.addImageProvider(QLatin1String("ThemeProvider"),new ThemeProvider);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

