SRC_URL="https://android.googlesource.com/platform/ndk/+archive/refs/tags/ndk-22/sources/android/libthread_db.tar.gz"

WOKSPACE_DIR="$1"
NDK_DIR="$2"
ARCH="$3"
API="$4"

SRC_DIR="$WOKSPACE_DIR/src"
INSTALL_DIR="$WOKSPACE_DIR/install"
INCLUDE_DIR="$INSTALL_DIR/include"
LIB_DIR="$INSTALL_DIR/lib"
mkdir -p "$SRC_DIR"
mkdir -p "$INSTALL_DIR"
mkdir -p "$INCLUDE_DIR"
mkdir -p "$LIB_DIR"

TOOLCHAIN_DIR="$NDK_DIR/toolchains/llvm/prebuilt/linux-x86_64"
TOOLCHAIN_PREFIX="$TOOLCHAIN_DIR/bin/$ARCH-linux-android$API"
if [ "$ARCH" = "arm" ] ; then
    TOOLCHAIN_PREFIX="$TOOLCHAIN_DIR/bin/armv7a-linux-androideabi${API}"
fi

export CC="${TOOLCHAIN_PREFIX}-clang"
export CXX="${TOOLCHAIN_PREFIX}-clang++"
export LD="${TOOLCHAIN_DIR}/bin/ld.lld"
export AR="${TOOLCHAIN_DIR}/bin/llvm-ar"
export OBJCOPY="${TOOLCHAIN_DIR}/bin/llvm-objcopy"
export RANLIB="${TOOLCHAIN_DIR}/bin/llvm-ranlib"
export STRIP="${TOOLCHAIN_DIR}/bin/llvm-strip"
export CPPFLAGS="-I$INCLUDE_DIR/"

build() {
    echo "Building $1 for $ARCH"

    MY_DIR=$WOKSPACE_DIR/$1
    source $MY_DIR/build.sh

    step_download || exit $?
    step_make || exit $?
    step_install || exit $?
}

build "libthread-db"
build "gdbserver"
