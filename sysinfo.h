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
protected:
    void run() Q_DECL_OVERRIDE ;

signals:
    void meminfo(QString total, QString free, qreal ratio);
};

class CpuInfo : public QThread
{
    Q_OBJECT
protected:
    void run() Q_DECL_OVERRIDE;
signals:
    void cpuinfo(QString info);
};

class SysInfo : public QObject
{
    Q_OBJECT
public:
    explicit SysInfo(QObject *parent = 0);
    ~SysInfo();
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
