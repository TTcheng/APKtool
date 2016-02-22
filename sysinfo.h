#ifndef SYSINFO_H
#define SYSINFO_H

#include <QObject>



class SysInfo : public QObject
{
    Q_OBJECT
public:
    explicit SysInfo(QObject *parent = 0);
    Q_INVOKABLE void memoryInfo();
    Q_INVOKABLE void cpuInfo();

signals:
    void meminfo(QString total, QString free, qreal ratio);
    void cpuinfo(QString info);

public slots:
};

#endif // SYSINFO_H
