#ifndef MAINCLASS_H
#define MAINCLASS_H

#include <QObject>
#include <QStringList>
#include <QQmlContext>
#include <QFile>
#include <QDateTime>
//#include <QDebug>
#include <QDir>
#include <QSettings>
#include <QColor>


#include "filemodelitem.h"
#include "taskmodelitem.h"
#include "keythread.h"

class MainClass : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentPath READ currentPath CONSTANT)
    Q_PROPERTY(QList<QObject*>  fileModel READ fileModel  NOTIFY fileModelChanged)
    Q_PROPERTY(QList<QObject*>  taskModel READ taskModel  NOTIFY taskModelChanged)
    Q_PROPERTY(QList<QObject*>  searchModel READ searchModel  NOTIFY searchModelChanged)
//    Q_PROPERTY(bool noItemSelected READ noItemSelected CONSTANT)
    Q_PROPERTY(int taskNum READ taskNum CONSTANT)
    Q_PROPERTY(QString aapt READ aapt CONSTANT)


public:
    explicit MainClass(QObject *parent = 0);
    ~MainClass();
    QString currentPath(){return _currentPath;}
    QString aapt(){return _aapt;}
//    QStringList filesInfoList();
    QList<QObject*> fileModel(){ return fList; }
    QList<QObject*> taskModel(){ return tList; }
    QList<QObject*> searchModel(){ return sList; }

    int taskNum();

//    static bool cmpFileModel(QObject *a, QObject *b);

signals:
    void fileModelChanged();
     void taskModelChanged();
    void searchModelChanged();
    void noPerm();
    void clickFile(QString type);
    void clickDir();   
    void deleteFinished();
    void gotKey(QString key);
    void copyFinished();
    void cutFinished();
    void sameNameExist();
    void editorClosed();
    void signFinished();
    void taskFinished(QString cmd, QString output, QString duration);
    void noBootClass();
    void combineHelp();
    void themeChanged();

public:
   Q_INVOKABLE void singlePress(int index);
   Q_INVOKABLE void longPress(int index);
   Q_INVOKABLE void selectAll();
   Q_INVOKABLE void reverseSelect();
   Q_INVOKABLE void unselectAll();
   Q_INVOKABLE void deleteSelected();
   Q_INVOKABLE void genKey();
   Q_INVOKABLE void saveSelected();
   Q_INVOKABLE bool copySelected(bool cover);
   Q_INVOKABLE bool cutSelected(bool cover);
   Q_INVOKABLE void rename(QString oldName, QString newName);
   Q_INVOKABLE bool noItemSelected();
   Q_INVOKABLE bool hasRoot();
   Q_INVOKABLE void setShell(bool root);

   Q_INVOKABLE void createNewFile(QString name, bool type);
   Q_INVOKABLE void decApk(QString apkFile, QString options, bool rootPerm = false);
   Q_INVOKABLE void recApk(QString sourceDir, QString options, QString aapt, bool rootPerm = false);
   Q_INVOKABLE void signApk(QString apkFile);
   Q_INVOKABLE void openFile(QString file);
   Q_INVOKABLE void importFramework(QString apkFile);
   Q_INVOKABLE void oat2dex(QString odexFile);
   Q_INVOKABLE void combineApkDex();

   Q_INVOKABLE void removeTask(int n);
   Q_INVOKABLE void removeFinishedTasks();
   Q_INVOKABLE void stopAllTasks();

   Q_INVOKABLE void searchFiles(QString cmd);

   Q_INVOKABLE void setTheme(QString type, QString fname);

    Q_INVOKABLE int intValue(QString key);
    Q_INVOKABLE QString strValue(QString key);
    Q_INVOKABLE bool boolValue(QString key);
    Q_INVOKABLE QColor colorValue(QString key);

    Q_INVOKABLE void setIntValue(QString key, int value);
    Q_INVOKABLE void setStrValue(QString key, QString value);
    Q_INVOKABLE void setBoolValue(QString key, bool value);
    Q_INVOKABLE void setColorValue(QString key, QColor value);


private slots:
    void deleteKey();
    void searchResult();
    void refreshCurrentPath();

private:
    QString _currentPath, _oldPath, _shell;
//    QString qtPerm2unix(QFile::Permissions p);
//    QString qtFileSize(qint64 s);
//    QString qtDate(QDateTime d);
    QList<QObject*> fList; //files list
    QList<QObject*> tList; //tasks list
    QList<QObject*> sList; //search files list
//    void createFSWatcher();
//    QFileSystemWatcher *watcher;
    keyThread *_key;
    QString _selectedFiles;
    QString _aapt;
    QSettings st;
    QProcess *searchProc, listProc;
    inline QDir::Filters currentFilter(){
        if(QDir(_currentPath).isRoot())
                return QDir::NoDotAndDotDot|QDir::AllEntries|QDir::Hidden;
        else
                return QDir::NoDot|QDir::AllEntries|QDir::Hidden;
    }

};

#endif // MAINCLASS_H
