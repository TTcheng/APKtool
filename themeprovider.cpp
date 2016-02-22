#include "themeprovider.h"
#include <QSettings>
#include <QDir>
#include <QDebug>

ThemeProvider::ThemeProvider():QQuickImageProvider(QQuickImageProvider::Pixmap)
{

}

QPixmap ThemeProvider::requestPixmap(const QString& id, QSize* size, const QSize& requestedSize){
    int width = 100;
    int height = 100;

    if (size)
            *size = QSize(width, height);
    QPixmap pixmap(requestedSize.width() > 0 ? requestedSize.width() : width,
                           requestedSize.height() > 0 ? requestedSize.height() : height);

    QSettings settings;
     if(id=="bg")
         pixmap.load(settings.value("theme/background").toString()=="custom"?QDir::homePath()+"/bg":":/icons/bg.png");

     else if(id=="itembg")
         pixmap.load(settings.value("theme/itembackground").toString()=="custom"?QDir::homePath()+"/itembg":"");

     else if(id=="buttonbg")
         pixmap.load(settings.value("theme/buttonbackground").toString()=="custom"?QDir::homePath()+"/buttonbg":":/icons/buttonbg.png");


    return pixmap;
}
