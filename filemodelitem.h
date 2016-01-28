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

    FileModelItem(const QString &name, const QString &info):_name(name),_info(info), _checked(false){}
    QString name() const{ return _name; }
    QString info() const{ return _info; }
    bool checked() const {return _checked; }



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
    QString _name, _info;
    bool _checked;

};


#endif // MYMODELITEM_H
