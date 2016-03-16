#include "mainclass.h"
#include <QDir>
#include <QFile>
#include <QThread>
#include <QDebug>
#include <QSettings>
#include <QStringList>


#if defined(Q_OS_ANDROID)
#include <QtAndroid>
#include <QtAndroidExtras/QAndroidJniObject>
#endif

bool cmpFileModel(QObject *_a, QObject *_b)
{
    FileModelItem* a = qobject_cast<FileModelItem *>(_a);
    FileModelItem* b = qobject_cast<FileModelItem *>(_b);
    return a->sortTag.compare(b->sortTag, Qt::CaseInsensitive) <0;
}

/* 0: sort by name;
 * 1: sort by user;
 * 2: sort by mem;
 * 3: sort by pid;
 * 4: sort by ppid;
 */
#define CMPPROCMODELUP(type) \
    bool cmpProcModelUp##type(QObject *_a, QObject *_b)\
{\
    ProcModelItem *a = qobject_cast<ProcModelItem *>(_a);\
    ProcModelItem *b = qobject_cast<ProcModelItem *>(_b);\
    switch(type){\
    case 0:\
    return a->name().compare(b->name(), Qt::CaseInsensitive) <0;\
    case 1:\
    return a->user().compare(b->user(), Qt::CaseInsensitive) <0;\
    case 2:\
    return a->mem() < b->mem();\
    case 3:\
    return a->pid() < b->pid();\
    case 4:\
    return a->ppid() < b->ppid();\
    }\
    }
CMPPROCMODELUP(0)
CMPPROCMODELUP(1)
CMPPROCMODELUP(2)
CMPPROCMODELUP(3)
CMPPROCMODELUP(4)

#define CMPPROCMODELDOWN(type) \
    bool cmpProcModelDown##type(QObject *_a, QObject *_b)\
{\
    ProcModelItem *a = qobject_cast<ProcModelItem *>(_a);\
    ProcModelItem *b = qobject_cast<ProcModelItem *>(_b);\
    switch(type){\
    case 0:\
    return a->name().compare(b->name(), Qt::CaseInsensitive) >0;\
    case 1:\
    return a->user().compare(b->user(), Qt::CaseInsensitive) >0;\
    case 2:\
    return a->mem() > b->mem();\
    case 3:\
    return a->pid() > b->pid();\
    case 4:\
    return a->ppid() > b->ppid();\
    }\
    }
CMPPROCMODELDOWN(0)
CMPPROCMODELDOWN(1)
CMPPROCMODELDOWN(2)
CMPPROCMODELDOWN(3)
CMPPROCMODELDOWN(4)

MainClass::MainClass(QObject *parent) : QObject(parent), searchProc(NULL)
{
    _currentPath = st.value("user/lastPath", "/").toString();
    _aapt = st.value("user/aapt","aapt6.0").toString();
    //    _shell = "sh";
    if(QFileInfo("/system/bin/su").exists()||QFileInfo("/system/xbin/su").exists()||QFileInfo("/bin/su").exists())
        _shell = "su";
    if(st.value("user/root", _shell=="su"?true:false).toBool())
        _shell = "su";
    else
        _shell = "sh";

    refreshCurrentPath();
    connect(this, SIGNAL(copyFinished()), this, SLOT(refreshCurrentPath()));
    connect(this, SIGNAL(deleteFinished()), this, SLOT(refreshCurrentPath()));
    connect(this, SIGNAL(cutFinished()), this, SLOT(refreshCurrentPath()));
    connect(this, SIGNAL(signFinished()), this, SLOT(refreshCurrentPath()));
    connect(this, SIGNAL(taskFinished(QString,QString,QString)), this, SLOT(refreshCurrentPath()));
    /*
    QProcess proc;
    proc.start("id");
    proc.waitForFinished();
    qWarning()<<proc.readAllStandardOutput();
*/

}

MainClass::~MainClass()
{
    st.setValue("user/lastPath", _currentPath);
    st.setValue("user/aapt", _aapt);
}

void MainClass::refreshCurrentPath()
{
    //    if(listProc.state()==QProcess::Running)
    //       listProc.kill();
    listProc.start(_shell, QStringList()<<"-c"<<"toolbox ls -al "+_currentPath);
    listProc.waitForFinished();
    /*
    if(listProc.exitCode()==2){
        _currentPath = "/";
        listProc.start(_shell, QStringList()<<"-c"<<"ls -l "+_currentPath);
        listProc.waitForFinished();
    }
*/
    qDeleteAll(fList);
    fList.clear();
    QByteArray output = listProc.readAllStandardOutput();

    //    qWarning()<<output;
    //    qWarning()<< listProc.readAllStandardError();
    QTextStream out(&output);
    QString line, filename, fileinfo, sortTag;
    QString symtarget;
    if(_currentPath!="/")
        fList.append(new FileModelItem("..", _currentPath));

    while(!out.atEnd()){
        line = out.readLine();

        if(line.startsWith('l')){
            int nameOffset1 = line.indexOf(':')+4;
            int nameOffset2 = line.indexOf(" ->");
            filename = line.mid(nameOffset1, nameOffset2 - nameOffset1);
            fileinfo =line.left(nameOffset1)+ "  "+line.right(line.length() - nameOffset2) ;
            symtarget = line.right(line.length() - nameOffset2 - 4);
            if(QFileInfo(_currentPath, symtarget).isDir())
                sortTag = "1";
            else
                sortTag = "2";
            sortTag += filename;
        }
        else{
            int nameOffset1 = line.indexOf(':')+4;
            filename = line.right(line.length() - nameOffset1);
            fileinfo =line.left(nameOffset1);
            if(QFileInfo(_currentPath, filename).isDir())
                sortTag = "1";
            else
                sortTag = "2";
            sortTag += filename;
        }

        fList.append(new FileModelItem(filename, fileinfo, sortTag, symtarget));
    }
    if(fList.count()>2)
        std::sort(fList.begin()+1, fList.end(), cmpFileModel);

    emit fileModelChanged();
}

void MainClass::singlePress(int index)
{

    FileModelItem *item = qobject_cast<FileModelItem *>(fList[index]);
    if(index==0&&_currentPath!="/"){
        QDir dir(_currentPath);
        dir.cdUp();
        _currentPath = dir.absolutePath();
        if(!_currentPath.endsWith('/')){
            _currentPath+="/";
        }
        refreshCurrentPath();
    }
    else if(item->info().startsWith('d')){
        QFileInfo finfo(_currentPath, item->name());
        if(_shell=="su"||(finfo.isReadable()&&finfo.isExecutable())){
            _currentPath +=  item->name() + "/";
            refreshCurrentPath();
        }
    }
    else if(item->info().startsWith('-')){
        emit clickFile(QFileInfo( item->name()).suffix());
    }
    else if(item->info().startsWith('l')){
        /*        if(listProc.state()==QProcess::Running)
            listProc.kill();

        listProc.start(_shell, QStringList()<<"-c"<<"ls -ld "+ item->sym());
        listProc.waitForFinished();
        if(listProc.readAllStandardOutput().startsWith('d')){
            _currentPath +=  item->name() + "/";
            refreshCurrentPath();
        }
        else{
            emit clickFile(QFileInfo( item->name()).suffix());
        }
        */
        if(QFileInfo(_currentPath, item->sym()).isDir()){
            _currentPath +=  item->name() + "/";
            refreshCurrentPath();
        }
        else
            emit clickFile(QFileInfo( item->name()).suffix());
    }
}

void MainClass::longPress(int index)
{
    FileModelItem *item = qobject_cast<FileModelItem *>(fList[index]);
    if(item->name()==".." || item->info().startsWith('d')){
        emit clickDir();
    }
    else if(item->info().startsWith('-')){
        emit clickFile(QFileInfo( item->name()).suffix());
    }
    else if(item->info().startsWith('l')){
        if(QFileInfo(_currentPath, item->sym()).isDir()){
            emit clickDir();
        }
        else
            emit clickFile(QFileInfo( item->name()).suffix());
    }

}

bool MainClass::hasRoot()
{
    return _shell=="su";
}

void MainClass::selectAll()
{
    for(int i=0;i<fList.count();i++){
        FileModelItem *item = qobject_cast<FileModelItem *>(fList[i]);
        item->setChecked(true);
    }

}

void MainClass::unselectAll()
{
    for(int i=0;i<fList.count();i++){
        FileModelItem *item = qobject_cast<FileModelItem *>(fList[i]);
        item->setChecked(false);
    }

}

void MainClass::reverseSelect()
{
    for(int i=0;i<fList.count();i++){
        FileModelItem *item = qobject_cast<FileModelItem *>(fList[i]);
        item->setChecked(!item->checked());
    }

}

void MainClass::combineApkDex()
{
    QString zip, dex;
    for(int i=0;i<fList.count();i++){
        FileModelItem *item = qobject_cast<FileModelItem *>(fList[i]);
        if(item->checked()){
            if(item->name().endsWith(".apk", Qt::CaseInsensitive)||item->name().endsWith(".jar", Qt::CaseInsensitive)){
                if(zip.isEmpty())
                    zip = item->name();
                else{
                    emit combineHelp();
                    return;
                }

            }
            else if(item->name().endsWith(".dex")){
                if(dex.isEmpty())
                    dex = item->name();
                else{
                    emit combineHelp();
                    return;
                }
            }
            else{
                emit combineHelp();
                return;
            }
        }
    }
    if(dex!="classes.dex"){
        if(QFileInfo(_currentPath+"classes.dex").exists())
            if(!QFile::remove(_currentPath+"classes.dex")){
                emit combineHelp();
                return;
            }
        if(!QFile::rename(_currentPath+dex, _currentPath+"classes.dex")){
            emit combineHelp();
            return;
        }
    }

    TaskModelItem *task = new TaskModelItem("cd "+_currentPath+";aapt5.0 a "+zip+ " classes.dex", _shell);
    connect(task,SIGNAL(finished(QString,QString,QString)),this,SIGNAL(taskFinished(QString,QString,QString)));
    task->startTask();
    tList.append(task);
}

void MainClass::deleteSelected()
{
    QString filesList;
    for(int i=0;i<fList.count();i++){
        FileModelItem *item = qobject_cast<FileModelItem *>(fList[i]);
        if(item->checked()){
            filesList+=_currentPath + item->name()+ " ";
        }
    }
    TaskModelItem *task = new TaskModelItem(QString("busybox rm -r ")+filesList, _shell);
    connect(task,SIGNAL(finished(QString, QString ,QString)),this,SIGNAL(deleteFinished()));
    task->startTask();
    tList.append(task);
}

bool MainClass::noItemSelected()
{
    for(int i=0;i<fList.count();i++){
        FileModelItem *item = qobject_cast<FileModelItem *>(fList[i]);
        if(item->checked())
            return false;
    }
    return true;
}

int MainClass::taskNum()
{
    int runningTasks=0;
    for(int i=0;i<tList.count();i++){
        TaskModelItem *item = qobject_cast<TaskModelItem *>(tList[i]);
        if(item->state()=="task_running")
            runningTasks++;
    }
    return runningTasks;
}

void MainClass::genKey()
{
/*
    _key = new keyThread;
    connect(_key, SIGNAL(gotKey(QString)), this, SIGNAL(gotKey(QString)));
    connect(_key, SIGNAL(finished()), this, SLOT(deleteKey()));
    _key->start();
*/
}

void MainClass::deleteKey()
{
    delete _key;
    _key=NULL;
}

void MainClass::saveSelected()
{
    _selectedFiles.clear();
    _oldPath = _currentPath;
    for(int i=0;i<fList.count();i++){
        FileModelItem *item = qobject_cast<FileModelItem *>(fList[i]);
        if(item->checked())
            _selectedFiles+=_currentPath+ item->name()+" ";
    }
}

bool MainClass::copySelected(bool cover)
{
    if(_currentPath==_oldPath){
        return false;
    }
    TaskModelItem *task = new TaskModelItem(QString("busybox cp -r ")+(cover?"-f ":"") +_selectedFiles +" "+ _currentPath, _shell);
    connect(task,SIGNAL(finished(QString,QString,QString)),this,SIGNAL(copyFinished()));
    task->startTask();
    tList.append(task);
    return true;
}

bool MainClass::cutSelected(bool cover)
{
    if(_currentPath==_oldPath){
        return false;
    }
    TaskModelItem *task = new TaskModelItem(QString("busybox mv ")+(cover?"-f ":"-n ") +_selectedFiles +" "+ _currentPath, _shell);
    connect(task,SIGNAL(finished(QString,QString,QString)),this,SIGNAL(cutFinished()));
    task->startTask();
    tList.append(task);
    return true;
}

void MainClass::rename(QString oldName, QString newName)
{
    if(QFile(_currentPath+newName).exists()){
        emit sameNameExist();
        return;
    }

    QFile(_currentPath+oldName).rename(_currentPath+newName);
    refreshCurrentPath();
}

void MainClass::createNewFile(QString name, bool type)
{
    if(type){
        QFile f(_currentPath+name);
        if(f.exists()||!f.open(QIODevice::WriteOnly)){
            return;
        }
        f.close();
    }
    else
        QDir(_currentPath).mkdir(name);

    refreshCurrentPath();
}

void MainClass::decApk(QString apkFile, QString options, bool rootPerm)
{
    QString cmd("/data/data/per.pqy.apktool/apktool/apktool.sh ");
    cmd += options;
    cmd += _currentPath + apkFile + " -o " +_currentPath + apkFile.left(apkFile.length()-4) + "_src";
    TaskModelItem *task = new TaskModelItem(cmd,rootPerm?_shell:"sh");
    connect(task,SIGNAL(finished(QString,QString,QString)),this,SIGNAL(taskFinished(QString,QString,QString)));
    task->startTask();
    tList.append(task);
}

void MainClass::recApk(QString sourceDir, QString options, QString aapt, bool rootPerm)
{
    _aapt = aapt;
    QString cmd("/data/data/per.pqy.apktool/apktool/apktool.sh ");
    cmd += options;
    cmd += _currentPath + sourceDir + " -o " +_currentPath  + sourceDir + ".apk -a /data/data/per.pqy.apktool/apktool/openjdk/bin/"+aapt;
    TaskModelItem *task = new TaskModelItem(cmd,rootPerm?_shell:"sh");
    connect(task,SIGNAL(finished(QString,QString,QString)),this,SIGNAL(taskFinished(QString,QString,QString)));
    task->startTask();
    tList.append(task);
}

void MainClass::signApk(QString apkFile)
{
    QString cmd("/data/data/per.pqy.apktool/apktool/signapk.sh ");
    cmd += _currentPath  +apkFile + " " + _currentPath  + QFileInfo(apkFile).baseName()+"_sign.apk";
    TaskModelItem *task = new TaskModelItem(cmd, _shell);
    connect(task,SIGNAL(finished(QString,QString,QString)),this,SIGNAL(signFinished()));
    task->startTask();
    tList.append(task);
}

void MainClass::openFile(QString file)
{
#if defined(Q_OS_ANDROID)
    QAndroidJniObject filePath = QAndroidJniObject::fromString(_currentPath+file);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    if(file.endsWith(".apk", Qt::CaseInsensitive))
        QAndroidJniObject::callStaticMethod<void>("per/pqy/apktool/Extra", "installApk", "(Lorg/qtproject/qt5/android/bindings/QtActivity;Ljava/lang/String;)V",
                                                  activity.object<jobject>(), filePath.object<jstring>());
    else
        QAndroidJniObject::callStaticMethod<void>("per/pqy/apktool/Extra", "openFile", "(Lorg/qtproject/qt5/android/bindings/QtActivity;Ljava/lang/String;)V",
                                                  activity.object<jobject>(), filePath.object<jstring>());
#endif
}

void MainClass::importFramework(QString apkFile)
{
    QString cmd("/data/data/per.pqy.apktool/apktool/apktool.sh if ");
    cmd += _currentPath + apkFile;
    TaskModelItem *task = new TaskModelItem(cmd, _shell);
    connect(task,SIGNAL(finished(QString,QString,QString)),this,SIGNAL(taskFinished(QString,QString,QString)));
    task->startTask();
    tList.append(task);
}

void MainClass::oat2dex(QString odexFile)
{
    if(!(QFileInfo(_currentPath+ "dex").exists() || QFileInfo(_currentPath+ "boot.oat").exists())){
        emit noBootClass();
        return;
    }
    QString cmd("/data/data/per.pqy.apktool/apktool/oat2dex.sh ");
    cmd += _currentPath+odexFile;
    TaskModelItem *task = new TaskModelItem(cmd, _shell);
    connect(task,SIGNAL(finished(QString,QString,QString)),this,SIGNAL(taskFinished(QString,QString,QString)));
    task->startTask();
    tList.append(task);
}

void MainClass::removeTask(int i)
{
    delete tList[i];
    tList.removeAt(i);
    emit taskModelChanged();
}


void MainClass::removeFinishedTasks()
{
    for(int i=0;i<tList.count();i++){
        TaskModelItem *item = qobject_cast<TaskModelItem *>(tList[i]);
        if(item->state()!="task_running"){
            delete tList[i];
            tList.removeAt(i);
            i--;
        }
    }
    emit taskModelChanged();
}

void MainClass::stopAllTasks()
{
    for(int i=0;i<tList.count();i++){
        TaskModelItem *item = qobject_cast<TaskModelItem *>(tList[i]);
        if(item->state()=="task_running"){
            item->stopTask();
        }
    }
}

void MainClass::searchFiles(QString cmd)
{
    if(!searchProc){
        searchProc = new QProcess;
        QProcessEnvironment env = searchProc->processEnvironment();
        QString path = env.value("PATH");
        env.insert("PATH", "/data/data/per.pqy.apktool/apktool/openjdk/bin:"+path);
        searchProc->setProcessEnvironment(env);
        connect(searchProc, SIGNAL(finished(int)), this, SLOT(searchResult()));
    }
    else if(searchProc->state()==QProcess::Running)
        searchProc->kill();

    searchProc->start(_shell,QStringList()<<"-c"<<"cd "+_currentPath+";"+cmd);
}

void MainClass::searchResult()
{
    qDeleteAll(sList);
    sList.clear();
    QString output = searchProc->readAllStandardOutput();
    QTextStream stream(&output);
    while(!stream.atEnd()){
        QString fname = stream.readLine();
        QFileInfo f(_currentPath+fname);
        QString finfo ;//= qtPerm2unix(f.permissions()) + "    " + (f.isDir()?"    ":qtFileSize(f.size())) + "    "+ qtDate(f.lastModified()) + (f.isSymLink()?("    -> "+f.symLinkTarget()):"");
        sList.append(new FileModelItem(fname, finfo));
    }
    emit searchModelChanged();

}

void MainClass::setTheme(QString type, QString fname)
{
    if(!fname.isEmpty()){
        if(type=="bg"){
            QFile::remove(QDir::homePath()+"/bg");
            if(QFile::copy(fname, QDir::homePath()+"/bg"))
                st.setValue("theme/background", "custom");
            else
                st.setValue("theme/background", "");
        }

        else if(type=="itembg"){
            QFile::remove(QDir::homePath()+"/itembg");
            if(QFile::copy(fname, QDir::homePath()+"/itembg"))
                st.setValue("theme/itembackground", "custom");
            else
                st.setValue("theme/itembackground", "");
        }
        else if(type=="buttonbg"){
            QFile::remove(QDir::homePath()+"/buttonbg");
            if(QFile::copy(fname, QDir::homePath()+"/buttonbg"))
                st.setValue("theme/buttonbackground", "custom");
            else
                st.setValue("theme/buttonbackground", "");
        }
    }
    else{
        if(type=="bg"){
            QFile::remove(QDir::homePath()+"/bg");
            st.setValue("theme/background", "");
        }

        else if(type=="itembg"){
            QFile::remove(QDir::homePath()+"/itembg");
            st.setValue("theme/itembackground", "");
        }

        else if(type=="buttonbg"){
            QFile::remove(QDir::homePath()+"/buttonbg");
            st.setValue("theme/buttonbackground", "");
        }
    }
    st.sync();
    emit themeChanged();
}

int MainClass::intValue(QString key)
{
    if(key=="user/itemNum")
        return st.value(key, 15).toInt();
    return st.value(key).toInt();
}

QString MainClass::strValue(QString key)
{
    return st.value(key).toString();
}

bool MainClass::boolValue(QString key)
{
    return st.value(key).toBool();
}

QColor MainClass::colorValue(QString key)
{
    QColor color(st.value(key, "#000000").toString());
    if(!color.isValid())
        color = "#000000";
    return color;
}

void MainClass::setIntValue(QString key, int value)
{
    st.setValue(key, value);
}

void  MainClass::setStrValue(QString key, QString value)
{
    st.setValue(key,value);
}

void MainClass::setBoolValue(QString key, bool value)
{
    st.setValue(key,value);
}

void MainClass::setColorValue(QString key, QColor value)
{
    st.setValue(key, value.name());
}

void MainClass::setShell(bool root)
{
    if(root)
        _shell = "su";
    else
        _shell = "sh";
}

void MainClass::getProcList()
{
    qDeleteAll(pList);
    pList.clear();
    QProcess proc;
    proc.start(_shell, QStringList()<<"-c"<<"ps");
    proc.waitForFinished();
    QByteArray output = proc.readAllStandardOutput();
    QTextStream out(&output);
    bool showKthread = st.value("process/showKthread", false).toBool();
    while(!out.atEnd()){
        QString line = out.readLine();
        QStringList splitStr = line.split(QRegExp("\\s+"));
        if(splitStr.count()<9)
            continue;
        if(!showKthread&&splitStr[2]=="2")
            continue;
        pList.append(new ProcModelItem(splitStr[8], splitStr[0], splitStr[4], splitStr[1], splitStr[2]));
    }
    st.setValue("process/upsort", !st.value("process/upsort", true).toBool());
    sortProc(st.value("process/sortType", 3).toUInt());
}

void MainClass::sortProc(uint type)
{
    if(st.value("process/sortType", 3).toUInt()==type)
        st.setValue("process/upsort", !st.value("process/upsort", true).toBool());
    else
        st.setValue("process/sortType", type);
    if(pList.count()>1){
        if(st.value("process/upsort", true).toBool()){
            switch(type){
            case 0:
                std::stable_sort(pList.begin(), pList.end(), cmpProcModelUp0);
                break;
            case 1:
                std::stable_sort(pList.begin(), pList.end(), cmpProcModelUp1);
                break;
            case 2:
                std::stable_sort(pList.begin(), pList.end(), cmpProcModelUp2);
                break;
            case 3:
                std::sort(pList.begin(), pList.end(), cmpProcModelUp3);
                break;
            case 4:
                std::stable_sort(pList.begin(), pList.end(), cmpProcModelUp4);
                break;
            }
        }
        else{
            switch(type){
            case 0:
                std::stable_sort(pList.begin(), pList.end(), cmpProcModelDown0);
                break;
            case 1:
                std::stable_sort(pList.begin(), pList.end(), cmpProcModelDown1);
                break;
            case 2:
                std::stable_sort(pList.begin(), pList.end(), cmpProcModelDown2);
                break;
            case 3:
                std::sort(pList.begin(), pList.end(), cmpProcModelDown3);
                break;
            case 4:
                std::stable_sort(pList.begin(), pList.end(), cmpProcModelDown4);
                break;
            }
        }

    }
    emit procModelChanged();
}

void MainClass::sendSignal(uint pid, uint signal)
{
    QProcess proc;
    proc.start(_shell, QStringList()<<"-c"<<"kill -"+QString::number(signal)+" "+QString::number(pid));
    proc.waitForFinished();
    getProcList();
}

