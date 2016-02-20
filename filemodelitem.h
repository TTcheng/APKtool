#ifndef MYMODELITEM_H
#define MYMODELITEM_H

#include <QObject>


class FileModelItem :public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name CONSTANT)
    Q_PROPERTY(QString info READ info CONSTANT)
    Q_PROPERTY(bool checked READ checked WRITE setChecked NOTIFY checkedChanged)

public:

    FileModelItem(const QString &name, const QString &info, const QString &st = "", const QString &symtarget = "")
        :_name(name),_info(info), sortTag(st), _symtarget(symtarget), _checked(false){}
    QString name() const{ return _name; }
    QString info() const{ return _info; }
    QString sym() const { return _symtarget; }
    bool checked() const {return _checked; }
    QString sortTag;




signals:
    void checkedChanged();

public slots:
    void setChecked(bool c){
        if(_checked != c){
            _checked = c;
            if(_name == "..")
                _checked = false;
            emit checkedChanged();
        }
    }

private:
    QString _name, _info, _symtarget;
    bool _checked; //_type: true-> file; false->folder

};


#endif // MYMODELITEM_H
