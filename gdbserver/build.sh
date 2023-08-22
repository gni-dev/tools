GDB_VERSION="13.2"
MY_SRC_DIR="$SRC_DIR/gdb-$GDB_VERSION"

step_download() {
    wget --no-show-progress https://sourceware.org/pub/gdb/releases/gdb-$GDB_VERSION.tar.gz
    tar xf gdb-$GDB_VERSION.tar.gz -C $SRC_DIR

    for i in $MY_DIR/*.patch; do
        patch -d$MY_SRC_DIR -p0 < $i;
    done
}

step_make() {
    GDBSERVER_HOST="$ARCH-linux-android"
    if [ "$ARCH" = "arm" ] ; then
        GDBSERVER_HOST="arm-linux-androideabi"
    fi

    cd $MY_SRC_DIR

    # disable unneeded components to reduce build time https://sourceware.org/gdb/wiki/BuildingCrossGDBandGDBserver
    ./configure \
    --disable-gdb \
    --disable-ld \
    --disable-gas \
    --disable-sim \
    --disable-gprofng \
    --disable-inprocess-agent \
    --disable-werror \
    --host=$GDBSERVER_HOST \
    --prefix=$INSTALL_DIR \
    --with-libthread-db=$INSTALL_DIR/lib/libthread_db.a \
    LDFLAGS="-static"

    make -j$(nproc)
}

step_install() {
    cd $MY_SRC_DIR

    make install-strip
}
