#include "myfiledialog.h"
#include "filemodelitem.h"

QString MyFileDialog::_currentPath;

MyFileDialog::MyFileDialog(QObject *parent) : QObject(parent), _filter("*.*")
{
    refresh();
}

void MyFileDialog::refresh()
{
    QDir parent(MyFileDialog::_currentPath);
    qDeleteAll(fList);
    fList.clear();
    QStringList filesList = parent.entryList(_filter.split(",",QString::SkipEmptyParts), currentFilter(), QDir::DirsFirst| QDir::IgnoreCase);
    for(int i=0;i<filesList.count();i++)
        fList.append(new FileModelItem(filesList[i],""));
    emit fileModelChanged();
}

void MyFileDialog::singlePress(QString fname)
{
    QFileInfo finfo(MyFileDialog::_currentPath, fname);
    if(!finfo.isReadable())
        return;
    if(finfo.isFile()){
        emit clickFile();
        return;
    }
    if(finfo.isDir()&&finfo.isExecutable()){
        QString cp(MyFileDialog::_currentPath);
        cp+="/";
        cp+=fname;
        MyFileDialog::_currentPath = QDir(cp).absolutePath();
        MyFileDialog::_currentPath = QDir(MyFileDialog::_currentPath).path();
        refresh();
    }
}
