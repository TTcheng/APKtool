#include "sysinfo.h"
#include <fstream>
#include <iostream>
//#include <QDebug>

SysInfo::SysInfo(QObject *parent) : QObject(parent)
{

}

void SysInfo::memoryInfo()
{
    std::string tmp;
    std::ifstream file("/proc/meminfo");
    qint64 tmem=0, umem=0;

    while (file >> tmp){
          if (!(tmp.compare (0, tmp.length () - 1, "MemTotal")&&tmp.compare (0, tmp.length () - 1, "SwapTotal"))){
          file >> tmp;
          tmem += atol (tmp.c_str ());
         }
         else if (!
            (tmp.compare (0, tmp.length () - 1, "MemFree")
             && tmp.compare (0, tmp.length () - 1, "Buffers")
             && tmp.compare (0, tmp.length () - 1, "Cached")
             && tmp.compare (0, tmp.length () - 1, "SwapFree")))
        {
            file >> tmp;
            umem -= atol (tmp.c_str ());
        }

   }
    file.close();
   umem+=tmem;
//   qWarning()<<tmem<<" "<<fmem;
   emit meminfo(QString("%1M").arg(tmem/1024), QString("%1M").arg(umem/1024), (qreal)umem/tmem);


}
