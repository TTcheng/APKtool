#ifndef PROCMODELITEM_H
#define PROCMODELITEM_H

#include <QObject>

class ProcModelItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name CONSTANT)
    Q_PROPERTY(QString user READ user CONSTANT)
    Q_PROPERTY(ulong mem READ mem CONSTANT)
    Q_PROPERTY(uint pid READ pid CONSTANT)
    Q_PROPERTY(uint ppid READ ppid CONSTANT)
public:
    explicit ProcModelItem(const QString &name, const QString &user, const QString &mem, const QString &pid, const QString &ppid):
        _name(name), _user(user)
    {
        _mem = mem.toULong();
        _pid = pid.toUInt();
        _ppid = ppid.toUInt();
    }

    QString name(){ return _name; }
    QString user(){ return _user; }
    ulong mem(){ return _mem; }
    uint pid(){ return _pid; }
    uint ppid(){ return _ppid; }

signals:

public slots:

private:
    QString _name, _user;
    ulong _mem;
    uint _ppid, _pid;
};

#endif // PROCMODELITEM_H
