#!/system/bin/sh
#export LD_LIBRARY_PATH=/data/data/per.pqy.apktool/apktool/lix
#in some targets,LD_PRELOAD will cause a error.
export LD_PRELOAD=
export LD_LIBRARY_PATH=/data/data/per.pqy.apktool/apktool/openjdk/lib/arm:/data/data/per.pqy.apktool/apktool/openjdk/lib/arm/jli:$LD_LIBRARY_PATH
umask 000
cd /data/data/per.pqy.apktool/apktool
#echo $$ > pid
/data/data/per.pqy.apktool/apktool/openjdk/bin/java -jar /data/data/per.pqy.apktool/apktool/signapk.jar /data/data/per.pqy.apktool/apktool/x509 /data/data/per.pqy.apktool/apktool/pk8 "$@" 

