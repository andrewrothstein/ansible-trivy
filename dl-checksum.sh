#!/usr/bin/env bash
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
    local sum
    sum=$(awk -v f="$file" '$2 == f || $2 == "*" f {print $1}' "$DIR/$checksums")
    if ! printf '%s' "$sum" | grep -Eq '^[0-9a-f]{64}$'; then
        echo "no valid checksum for $file in $checksums" >&2
        exit 1
    fi
    printf "    # %s\n" "$MIRROR/v${ver}/$file"
    printf "    %s: sha256:%s\n" "$platform" "$sum"
}

dl_ver() {
    local ver=$1
    local mirror=$MIRROR/v${ver}

    local checksums=${APP}_${ver}_checksums.txt
    if [ ! -e "$DIR/$checksums" ];
    then
        curl -fsSL --proto '=https' --tlsv1.2 -o "$DIR/$checksums" "$mirror/$checksums"
    fi


    printf "  # %s\n" "$mirror/$checksums"
    printf "  '%s':\n" "$ver"

    dl "$ver" "$checksums" Linux 64bit
    dl "$ver" "$checksums" Linux ARM64
    dl "$ver" "$checksums" Linux PPC64LE
    dl "$ver" "$checksums" Linux s390x
    dl "$ver" "$checksums" macOS 64bit
    dl "$ver" "$checksums" macOS ARM64
}

for v in "${@:-0.76.2}"; do
    dl_ver "$v"
done
