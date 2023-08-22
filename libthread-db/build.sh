step_download() {
    :
}

step_make() {
	cd $MY_DIR

    $CC -c -O2 -I. libthread_db.c -o libthread_db.o
    $AR rc libthread_db.a libthread_db.o
}

step_install() {
    install -v -t $INCLUDE_DIR "$MY_DIR/thread_db.h"
	install -v -t $LIB_DIR "$MY_DIR/libthread_db.a"
}

