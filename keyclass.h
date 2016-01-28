#ifndef KEYCLASS_H
#define KEYCLASS_H

#include <QObject>
#include <QTimer>
#include "keythread.h"
class KeyClass : public QObject
{
    Q_OBJECT
public:
    explicit KeyClass(QObject *parent = 0);

signals:
    void verifyTimeout();
    void verifySuccess();
    void verifyFail();

public:
    Q_INVOKABLE bool isRegisterd();
    Q_INVOKABLE QString userKey(bool crypt);
    Q_INVOKABLE void verifyKey(QString userKey);
    Q_INVOKABLE int runCount();

private slots:
    void _verifyKey(QString userKey);

private:
    keyThread *key;
    QTimer *timer;
    QString _userKey;
    void createKeyFile();
};

#endif // KEYCLASS_H
