#include "keyclass.h"
#include <QSettings>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <QFileInfo>
#include <QDir>
#include <QDateTime>
#include <stdlib.h>
#include <stdio.h>
#include <pwd.h>
#include <unistd.h>
#include <sys/types.h>
#include <string.h>
#include <QProcess>
#include <QDebug>



KeyClass::KeyClass(QObject *parent) : QObject(parent)
{
    char *home;
    if((home = getenv("HOME")) == NULL){
        home = getpwuid(getuid())->pw_dir;
    }
    _keyfile = (char*)malloc(strlen(home)+10);
    strcpy(_keyfile, home);
//    qWarning()<<_keyfile;
    strcat(_keyfile, "/keyfile");
//    qWarning()<<_keyfile;

}

KeyClass::~KeyClass()
{
    free(_keyfile);
}

bool KeyClass::isRegisterd()
{
    return true;
    /*
    QFileInfo finfo(_keyfile);
    if(!finfo.exists() || finfo.owner()!=getlogin())
        return false;
    QString userkey = userKey(true);


    for(int i=userkey.length()-2;i>0;i-=3){
        int j = userkey[i].toLatin1()-'0';
        userkey.remove(i, 1);
        if(j%2){
            userkey[i-1] = (userkey[i-1].toLatin1() - '0' -j +10)%10 +'0';
            userkey[i] = (userkey[i].toLatin1() - '0' -j +10)%10 +'0';
        }else{
            userkey[i] = (userkey[i].toLatin1() - '0' +j )%10 +'0';
            userkey[i-1] = (userkey[i-1].toLatin1() - '0' +j)%10 +'0';
        }
    }

    quint64 key = userkey.toLongLong() - getuid();
    struct stat st;
    stat(_keyfile, &st);
    quint64 validkey = st.st_mtime;
    return key==validkey;
    */
}


QString KeyClass::userKey(bool crypt)
{
    QSettings settings;
    if(crypt)
        return settings.value("key/cryptkey","000000000000000").toString();
    return settings.value("key/userkey","000000000000").toString();
}

void KeyClass::verifyKey(QString userKey)
{
    _userKey = userKey;
    timer = new QTimer;
    timer->setSingleShot(true);
    connect(timer, SIGNAL(timeout()),this, SIGNAL(verifyTimeout()));
    timer->start(3000);
    key = new keyThread;
    connect(key, SIGNAL(gotKey(QString)),this, SLOT(_verifyKey(QString)));
    key->start();
}

void KeyClass::_verifyKey(QString _validKey)
{
    quint64 _user, _valid;
    QString userKey = QString::number(_userKey.toLongLong(0, 16));
    QString validKey = QString::number(_validKey.toLongLong(0, 16));
    timer->stop();
    delete timer;
    _user = userKey.toLongLong();
    if((_user-1)%keyThread::_divisor){
        emit verifyFail();
        return;
    }
    for(int i=userKey.length()-2;i>0;i-=3){
        //        qDebug()<<userKey;
        userKey.remove(i, 1);
    }
    _user = userKey.toLongLong();
    for(int j=validKey.length()-2;j>0;j-=3)
        validKey.remove(j, 1);
    _valid = validKey.toLongLong();
    if(llabs(_user-_valid)<3600L*24-1){
        QSettings settings;
        settings.setValue("key/userkey", _userKey);
        createKeyFile();
        if(isRegisterd()||_secondVerify())
            emit verifySuccess();
        else{
            emit registerBug();
            return;
        }

    }
    else
        emit verifyFail();
}

void KeyClass::createKeyFile()
{
    QSettings settings;    
    struct stat st;
    QDir::home().mkpath(".");
    unlink(_keyfile);
    FILE *fp = fopen(_keyfile, "w");
    qsrand(time(NULL));
    for(int i=0;i<32;i++){
        fputc(qrand()%128, fp);
    }
    fstat(fileno(fp), &st);
    fclose(fp);
    QString cryptKey = QString::number(st.st_mtime + getuid());
    qsrand(time(NULL));

    for(int i=cryptKey.length()-1; i>0;i-=2){
        int j = qrand()%10;
        if(j%2){
            cryptKey[i-1] =  '0' + (cryptKey[i-1].toLatin1() - '0' + j)%10;
            cryptKey[i] =  '0' + (cryptKey[i].toLatin1() - '0' + j)%10;
        }else{
            cryptKey[i-1] =  '0' + (cryptKey[i-1].toLatin1() - '0' - j +10)%10;
            cryptKey[i] =  '0' + (cryptKey[i].toLatin1() - '0' -  j + 10)%10;
        }
        cryptKey.insert(i, '0'+ j);
    }

    settings.setValue("key/cryptkey", cryptKey);
}

bool KeyClass::_secondVerify()
{
    struct stat st;
    if(stat(_keyfile, &st))
        return false;
    QString cryptKey = QString::number(st.st_mtime + getuid());
    qsrand(time(NULL));

    for(int i=cryptKey.length()-1; i>0;i-=2){
        int j = qrand()%10;
        if(j%2){
            cryptKey[i-1] =  '0' + (cryptKey[i-1].toLatin1() - '0' + j)%10;
            cryptKey[i] =  '0' + (cryptKey[i].toLatin1() - '0' + j)%10;
        }else{
            cryptKey[i-1] =  '0' + (cryptKey[i-1].toLatin1() - '0' - j +10)%10;
            cryptKey[i] =  '0' + (cryptKey[i].toLatin1() - '0' -  j + 10)%10;
        }
        cryptKey.insert(i, '0'+ j);
    }
    QSettings settings;
    settings.setValue("key/cryptkey", cryptKey);
    settings.sync();
    return isRegisterd();

}

int KeyClass::runCount()
{
    QSettings settings;
    if(settings.isWritable())
        return settings.value("user/runCount", 15).toUInt();
    else
        return 15;
}

QString KeyClass::genBugMsg()
{
    struct stat st;
    QString userkey = userKey(true);
    for(int i=userkey.length()-2;i>0;i-=3){
        int j = userkey[i].toLatin1()-'0';
        userkey.remove(i, 1);
        if(j%2){
            userkey[i-1] = (userkey[i-1].toLatin1() - '0' -j +10)%10 +'0';
            userkey[i] = (userkey[i].toLatin1() - '0' -j +10)%10 +'0';
        }else{
            userkey[i] = (userkey[i].toLatin1() - '0' +j )%10 +'0';
            userkey[i-1] = (userkey[i-1].toLatin1() - '0' +j)%10 +'0';
        }
    }
    userkey+="\n";
    if(!stat(_keyfile, &st)){
        userkey+= QString::number(st.st_mtime + getuid());
    }
    else{
        userkey+=("xxxxxxxxxxxx");
    }
    userkey+="\n";
    userkey+="home:"+QDir::homePath();
    userkey+= "\n";
    userkey+=_keyfile;
    QProcess proc;
    char *home;
    if((home = getenv("HOME")) == NULL){
        home = getpwuid(getuid())->pw_dir;
    }
    proc.start("ls", QStringList()<<"-la"<<home);
    proc.waitForFinished();
    userkey+= "\n";
    userkey+= proc.readAllStandardOutput();
    return userkey;

}


