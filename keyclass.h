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
    ~KeyClass();

signals:
    void verifyTimeout();
    void verifySuccess();
    void verifyFail();
    void registerBug();

public:
    Q_INVOKABLE bool isRegisterd();
    Q_INVOKABLE QString userKey(bool crypt);
    Q_INVOKABLE void verifyKey(QString userKey);
    Q_INVOKABLE int runCount();
    Q_INVOKABLE QString genBugMsg();

private slots:
    void _verifyKey(QString userKey);

private:
    keyThread *key;
    QTimer *timer;
    QString _userKey;
    void createKeyFile();
    bool _secondVerify();
    char *_keyfile;
};

#endif // KEYCLASS_H
