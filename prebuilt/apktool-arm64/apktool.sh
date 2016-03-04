#!/system/bin/sh
#export LD_LIBRARY_PATH=/data/data/per.pqy.apktool/apktool/lix
#in some targets,LD_PRELOAD will cause a error.
export LD_PRELOAD=
export LD_LIBRARY_PATH=/data/data/per.pqy.apktool/apktool/openjdk/lib/aarch64:/data/data/per.pqy.apktool/apktool/openjdk/lib/aarch64/jli:$LD_LIBRARY_PATH
umask 000
cd /data/data/per.pqy.apktool/apktool
exec /data/data/per.pqy.apktool/apktool/openjdk/bin/java -Xmx1024m -Djava.io.tmpdir=/data/data/per.pqy.apktool -jar /data/data/per.pqy.apktool/apktool/apktool-2.0.3.jar -p /data/data/per.pqy.apktool "$@"
