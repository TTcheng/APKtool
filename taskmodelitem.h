 #ifndef TASKMODELITEM
#define TASKMODELITEM

#include <QObject>
#include <QProcess>
#include <QTime>
#include <sys/types.h>
#include <signal.h>
#include <QDebug>



class TaskModelItem :public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString cmd READ cmd CONSTANT)
    Q_PROPERTY(QString state READ state CONSTANT)
    Q_PROPERTY(QString output READ output CONSTANT)
    Q_PROPERTY(QString duration READ duration CONSTANT)

public:

    TaskModelItem(const QString &cmd):_cmd(cmd),  _process(NULL), _state("task_running"){
        /*
        _process = new QProcess;
        _process->setProcessChannelMode(QProcess::MergedChannels);
         connect(_process,SIGNAL(finished(int)),this, SLOT(finish_work()));
        _process->start("sh",QStringList()<<"-c"<<_cmd);
        */
    }
    ~TaskModelItem(){
    }

    QString cmd() const{ return _cmd; }
    QString state() { return _state; }
    QString output() { return _output ;}
    QString duration() { return _duration; }

signals:
    void finished(QString cmd, QString output, QString duration);
    void newTaskRunning();
    void stateChanged();

public:

    void startTask(){
        QProcessEnvironment env = _process.processEnvironment();
        QString path = env.value("PATH");
        env.insert("PATH", "/data/data/per.pqy.apktool/apktool/openjdk/bin:"+path);
        _process.setProcessEnvironment(env);
        _process.setProcessChannelMode(QProcess::MergedChannels);
        connect(&_process, SIGNAL(started()),this, SIGNAL(newTaskRunning()));
        connect(&_process,SIGNAL(finished(int)),this, SLOT(finish_work(int)));
        time.start();
        _process.start("sh",QStringList()<<"-c"<<_cmd);
    }

    Q_INVOKABLE void stopTask(){
        if( _process.state()!=QProcess::NotRunning){
            _process.kill();
        }
    }

private slots:
    void finish_work(int i){
        _output = _process.readAll();
        if(i==0)
            _state = "task_ok";
        else{
            if(_process.exitStatus()==QProcess::NormalExit)
                _state = "task_error";
            else
                _state = "task_terminate";
        }
        int duration = time.elapsed()/1000;
        if(duration>60)
            _duration =  QString("%1m %2s").arg(duration/60).arg(duration%60);
        else
            _duration = QString("%1s").arg(duration);
        emit finished(_cmd, _output, _duration);
//        delete _process;
//        _process = NULL;
        emit stateChanged();
    }
private:
    QString _cmd;
    QProcess _process;
    QString _state; //0: task_running; 1: task_ok; 2: task_error; 3: task_terminate
    QByteArray _output;
    QTime time;
    QString _duration;
};



#endif // TASKMODELITEM

