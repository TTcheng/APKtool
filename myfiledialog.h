#ifndef MYFILEDIALOG_H
#define MYFILEDIALOG_H

#include <QObject>
#include <QDir>

class MyFileDialog : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*>  fileModel READ fileModel  NOTIFY fileModelChanged)
    Q_PROPERTY(QString filter READ filter WRITE setFilter)
    Q_PROPERTY(QString currentPath READ currentPath CONSTANT)
public:
    explicit MyFileDialog(QObject *parent = 0);
    QList<QObject*> fileModel(){ return fList; }
    QString filter(){ return _filter; }
    QString currentPath(){ return MyFileDialog::_currentPath; }

signals:
    void fileModelChanged();
    void clickFile();

public:
    Q_INVOKABLE void singlePress(QString fname);
    Q_INVOKABLE void setFilter(QString filter){ _filter = filter; refresh();}
    Q_INVOKABLE void setcurrentPath(QString path){if(MyFileDialog::_currentPath.isEmpty()) MyFileDialog::_currentPath = path; }
private:
    inline QDir::Filters currentFilter(){
            if(QDir(_currentPath).isRoot())
                    return QDir::NoDotAndDotDot|QDir::AllEntries|QDir::Hidden|QDir::AllDirs;
            else
                    return QDir::NoDot|QDir::AllEntries|QDir::Hidden|QDir::AllDirs;
        }

    QList <QObject*> fList;
    QString _filter;
    static QString _currentPath;
    void refresh();
};

#endif // MYFILEDIALOG_H
