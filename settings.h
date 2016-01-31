#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>

class Settings : public QObject
{
    Q_OBJECT

public:
    explicit Settings(QObject *parent = 0);
    Q_INVOKABLE int intValue(QString key);
    Q_INVOKABLE QString strValue(QString key);
    Q_INVOKABLE bool boolValue(QString key);

    Q_INVOKABLE void setIntValue(QString key, int value);
    Q_INVOKABLE void setStrValue(QString key, QString value);
    Q_INVOKABLE void setBoolValue(QString key, bool value);

signals:

public slots:

private:
    QSettings st;
};

#endif // SETTINGS_H
