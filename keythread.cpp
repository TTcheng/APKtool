#include "keythread.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <memory.h>
#include <QTimeZone>
#include <QDebug>


keyThread::keyThread()
{

}

keyThread::~keyThread()
{

}

const quint64 keyThread::_divisor = 2017;


time_t keyThread::getNTPTime()
{
    char host[] = "218.189.210.3";
    int     socket_descriptor = socket(AF_INET, SOCK_DGRAM, 0);
    if (socket_descriptor < 0) return 0;

    struct sockaddr_in client_addr;
    memset( &client_addr, 0, sizeof(client_addr));
    client_addr.sin_family = AF_INET;
    client_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    client_addr.sin_port = htons(0);

    if ( bind(socket_descriptor, (struct sockaddr*)&client_addr, sizeof(client_addr)) < 0)
        return 0;

    struct sockaddr_in server_addr;
    memset( &server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = inet_addr(host);
    server_addr.sin_port = htons(123);

    char buf[1024];
    memset( buf, 0, 1024 );

    char request[48];
    memset( request, 0, 48 );
    request[0] = 0x1b;

    if ( sendto( socket_descriptor, request, 48, 0, (struct sockaddr*)&server_addr, sizeof(server_addr) ) < 0)
        return 0;

    struct sockaddr_in recv_addr;
    socklen_t recv_addr_len = sizeof(recv_addr);
//qWarning()<<"gg";
    recvfrom(socket_descriptor, buf, 1024, 0, (struct sockaddr*)&recv_addr,&recv_addr_len);
//qWarning()<<"hh";

    unsigned long ntpTime = ( buf[40] << 24 ) + ( buf[41] << 16 ) +
                            ( buf[42] << 8  ) +   buf[43];

    ntpTime -= 2208988800UL;    // take off 70 years

    return ntpTime;
}

quint64 keyThread::getNetTime()
{
        time_t ntptime = getNTPTime();
        QDateTime time;
        QTimeZone qZone( "UTC+00:00" );
        time.setTimeSpec( Qt::TimeZone );
        time.setTimeZone( qZone );
        time.setTime_t( ntptime );
        return time.toMSecsSinceEpoch()/1000;
}

void keyThread::run()
{
    quint64 ctime = getNetTime();
    QString keyStr = QString::number(ctime);
    qsrand(ctime);
    for(int i=keyStr.length()-1; i>0;i-=2){
        keyStr.insert(i, '0'+qrand()%10);
    }
    ctime = keyStr.toLongLong();
    ctime+=(keyThread::_divisor-ctime%keyThread::_divisor+1);
    emit gotKey(QString::number(ctime, 16));
}
