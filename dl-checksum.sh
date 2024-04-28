#!/usr/bin/env sh
set -e
DIR=~/Downloads
APP=trivy
MIRROR=https://github.com/aquasecurity/${APP}/releases/download

dl()
{
    local ver=$1
    local checksums=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-tar.gz}
    local platform=${os}-${arch}
    local file=${APP}_${ver}_${platform}.$archive_type
    printf "    # %s\n" $MIRROR/v${ver}/$file
    printf "    %s: sha256:%s\n" $platform `fgrep $file $DIR/$checksums | awk '{print $1}'`
}

dl_ver() {
    local ver=$1
    local mirror=$MIRROR/v${ver}

    local checksums=${APP}_${ver}_checksums.txt
    if [ ! -e $DIR/$checksums ];
    then
        curl -sSLf -o $DIR/$checksums $mirror/$checksums
    fi


    printf "  # %s\n" $mirror/$checksums
    printf "  '%s':\n" $ver

    dl $ver $checksums Linux 64bit
    dl $ver $checksums Linux ARM64
    dl $ver $checksums Linux PPC64LE
    dl $ver $checksums Linux s390x
    dl $ver $checksums macOS 64bit
    dl $ver $checksums macOS ARM64
}

dl_ver ${1:-0.50.4}
