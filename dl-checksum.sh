#!/usr/bin/env sh
DIR=~/Downloads
APP=trivy
MIRROR=https://github.com/aquasecurity/${APP}/releases/download

dl()
{
    local ver=$1
    local checksums=$2
    local os=$3
    local arch=$4
    local archive_type=$5
    local platform=${os}-${arch}
    local file=${APP}_${ver}_${platform}.$archive_type

    printf "    %s: sha256:%s\n" $platform `fgrep $file $DIR/$checksums | awk '{print $1}'`
}

dl_ver() {
    local ver=$1
    local mirror=$MIRROR/v${ver}

    local checksums=${APP}_${ver}_checksums.txt
    if [ ! -e $DIR/$checksums ];
    then
        wget -q -O $DIR/$checksums $mirror/$checksums
    fi


    printf "  # %s\n" $mirror/$checksums
    printf "  '%s':\n" $ver

    dl $ver $checksums FreeBSD 32bit tar.gz
    dl $ver $checksums OpenBSD 32bit tar.gz
    dl $ver $checksums Linux 32bit tar.gz
    dl $ver $checksums OpenBSD ARM tar.gz
    dl $ver $checksums Linux 64bit tar.gz
    dl $ver $checksums FreeBSD ARM tar.gz
    dl $ver $checksums Linux ARM tar.gz
    dl $ver $checksums Linux ARM64 tar.gz
    dl $ver $checksums Windows 32bit zip
    dl $ver $checksums Windows 64bit zip
    dl $ver $checksums macOS 64bit tar.gz
    dl $ver $checksums macOS 32bit tar.gz
    dl $ver $checksums OpenBSD 64bit tar.gz
    dl $ver $checksums FreeBSD 64bit tar.gz
}

dl_ver ${1:-0.1.7}
