#include "fileimageprovider.h"
#include <QFileInfo>
#include <QProcess>
#include <QPainter>


FileImageProvider::FileImageProvider():QQuickImageProvider(QQuickImageProvider::Pixmap)
{

}

QPixmap FileImageProvider::requestPixmap(const QString& id, QSize* size, const QSize& requestedSize){
    int width = 100;
    int height = 100;

    if (size)
            *size = QSize(width, height);
    QPixmap pixmap(requestedSize.width() > 0 ? requestedSize.width() : width,
                           requestedSize.height() > 0 ? requestedSize.height() : height);

    QFileInfo f(id);
     if(id=="task_running")
         pixmap.load(":/icons/task_running.png");
     else if(id=="task_ok")
         pixmap.load(":/icons/task_ok.png");
     else if(id=="task_error")
         pixmap.load(":/icons/task_error.png");
     else if(id=="task_terminate")
         pixmap.load(":/icons/task_terminate.png");

    else if(f.isDir()&&f.isReadable())
        pixmap.load(":/icons/folder.png");
    else if(f.isDir()&&!f.isReadable())
         pixmap.load(":/icons/folder-grey.png");
    else if(f.isFile()){
         if(id.endsWith(".apk", Qt::CaseInsensitive)){
             QProcess proc;
             QProcessEnvironment env = proc.processEnvironment();
             QString path = env.value("PATH");
             env.insert("PATH", "/data/data/per.pqy.apktool/apktool/openjdk/bin:"+path);
             proc.setProcessEnvironment(env);
             QString cmd = "aapt5.0 d --values badging " + id + "|busybox grep application-icon|busybox tail -1|busybox awk -F: '{print $2}' ";
             proc.start("sh", QStringList()<<"-c"<<cmd);
             proc.waitForFinished(-1);
             QByteArray icon = proc.readAllStandardOutput();
             if(icon.length()==0)
                 pixmap.load(":/icons/unknown.png");
             else{
             cmd = "busybox unzip -p " + id + " " + icon;
             proc.start("sh", QStringList()<<"-c"<<cmd);
             proc.waitForFinished(-1);
             icon = proc.readAllStandardOutput();
             pixmap.loadFromData(icon,"png");
             }
         }else if(id.endsWith(".jpg", Qt::CaseInsensitive)||id.endsWith(".png", Qt::CaseInsensitive)){
            pixmap.load(id);
         }else pixmap.load(":/icons/file.png");
    }
    if(pixmap.isNull())
        pixmap.load(":/icons/unknown.png");
    if(f.isSymLink()){
        QPainter painter(&pixmap);
        painter.drawPixmap(0, 0, pixmap.width()/2, pixmap.height()/2, QPixmap(":/icons/symlink.png"));
    }
    return pixmap;
}
