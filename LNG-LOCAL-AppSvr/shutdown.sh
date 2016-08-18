for i in `ps ax|awk '/java LNGLOCALAppSvr.M/{print $1}'`; do
    kill -9 $i
done
