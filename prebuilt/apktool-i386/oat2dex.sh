#!/system/bin/sh
#export LD_LIBRARY_PATH=/data/data/per.pqy.apktool/apktool/lix
#in some targets,LD_PRELOAD will cause a error.
export LD_PRELOAD=
export LD_LIBRARY_PATH=/data/data/per.pqy.apktool/apktool/openjdk/lib/i386:/data/data/per.pqy.apktool/apktool/openjdk/lib/i386/jli:$LD_LIBRARY_PATH
umask 000
PARENT=`busybox dirname $1`
cd $PARENT
[ -d dex ] || /data/data/per.pqy.apktool/apktool/openjdk/bin/java -jar /data/data/per.pqy.apktool/apktool/oat2dex.jar boot boot.oat

/data/data/per.pqy.apktool/apktool/openjdk/bin/java -jar /data/data/per.pqy.apktool/apktool/oat2dex.jar $1 dex

