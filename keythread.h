#ifndef KEYTHREAD_H
#define KEYTHREAD_H

#include <QThread>


class keyThread : public QThread
{
    Q_OBJECT
public:
    keyThread();
    ~keyThread();
    static const quint64 _divisor;
signals:
    void gotKey(QString key);
protected:
    void run();
private slots:
private:
    QString genKey();
    time_t getNTPTime();
    quint64 getNetTime();

};

#endif // KEYTHREAD_H
