#ifndef SYSINFO_H
#define SYSINFO_H

#include <QObject>
#include <QThread>
#include <QTimer>
#include <QSettings>
#include <fstream>
#include <iostream>
#include <unistd.h>
#include <QFile>
#include <QTextStream>
#include <QStringList>

class MemInfo;
class CpuInfo;

class MemInfo : public QThread
{
    Q_OBJECT
public:
    void run() Q_DECL_OVERRIDE {
        std::string tmp;
        std::ifstream file("/proc/meminfo");
        qint64 tmem=0, umem=0;

        while (file >> tmp){
              if (!(tmp.compare (0, tmp.length () - 1, "MemTotal")&&tmp.compare (0, tmp.length () - 1, "SwapTotal"))){
              file >> tmp;
              tmem += atol (tmp.c_str ());
             }
             else if (!
                (tmp.compare (0, tmp.length () - 1, "MemFree")
                 && tmp.compare (0, tmp.length () - 1, "Buffers")
                 && tmp.compare (0, tmp.length () - 1, "Cached")
                 && tmp.compare (0, tmp.length () - 1, "SwapFree")))
            {
                file >> tmp;
                umem -= atol (tmp.c_str ());
            }

       }
        file.close();
       umem+=tmem;
       emit meminfo(QString("%1M").arg(tmem/1024), QString("%1M").arg(umem/1024), (qreal)umem/tmem);
    }

signals:
    void meminfo(QString total, QString free, qreal ratio);
};

class CpuInfo : public QThread
{
    Q_OBJECT
public:
    void run() Q_DECL_OVERRIDE {
        long cpu_total = 0, cpu_idle = 0;
        QString info, prev, current;
       QFile file("/proc/stat");
       if(file.open(QFile::ReadOnly|QFile::Text)){
           prev = file.readAll();
           file.close();
       }
       QThread::msleep(500);
       if(file.open(QFile::ReadOnly|QFile::Text)){
           current = file.readAll();
           file.close();
       }
       if(prev.isEmpty()||current.isEmpty())
           return;
       else{
           QTextStream in1(&prev), in2(&current);
           in1.readLine();
           in2.readLine();
           QString tmp1, tmp2;
           while(!in1.atEnd()){
               tmp1 = in1.readLine();
               tmp2 = in2.readLine();
               if(!tmp1.startsWith("cpu"))
                   break;
               QStringList splitStr1 = tmp1.split(QRegExp("\\s+"));
               QStringList splitStr2 = tmp2.split(QRegExp("\\s+"));
               if(splitStr1.count()<10||splitStr2.count()<10)
                   continue;
               file.setFileName("/sys/bus/cpu/devices/"+splitStr1[0]+"/online");
               if(file.open(QFile::ReadOnly|QFile::Text)){
                   if(file.readAll().startsWith('0')){
                       file.close();
                       continue;
                   }
                   file.close();
               }
               for(int i =1; i<8; i++){
                    cpu_total += splitStr2[i].toLong() - splitStr1[i].toLong();
                    if(i == 4 || i == 5)
                        cpu_idle += splitStr2[i].toLong() - splitStr1[i].toLong();
               }

               info += splitStr1[0] + ": " + QString::number((cpu_total - cpu_idle) * 100 / cpu_total) + "%\n";
           }

           emit cpuinfo(info);
       }
    }
signals:
    void cpuinfo(QString info);
};

class SysInfo : public QObject
{
    Q_OBJECT
public:
    explicit SysInfo(QObject *parent = 0);
    //Q_INVOKABLE void memoryInfo();
    //Q_INVOKABLE void cpuInfo();

signals:
    void meminfo(QString total, QString free, qreal ratio);
    void cpuinfo(QString info);

public slots:
    void getInfo();

private:
    CpuInfo ci;
    MemInfo mi;
    QTimer timer;
    QSettings st;
};

#endif // SYSINFO_H
