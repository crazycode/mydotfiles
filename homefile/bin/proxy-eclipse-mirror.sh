#!/bin/bash

eclipse_home=/opt/eclipse/eclipse-3.6.1
dst_repo=/opt/eclipse/mirrors-emacs
dst_name=LocalEmacsPlusMirror


function mirror() {
    echo "update mirror: $1 ..."
    if [ ! -d $1 ]; then

    fi
    $eclipse_home/eclipse \
        -application org.eclipse.equinox.p2.artifact.repository.mirrorApplication \
        -nosplash \
        -source $1 \
        -destination $dst_repo \
        -destinationName $dst_name \
        -verbose \
        -compare

    $eclipse_home/eclipse \
        -application org.eclipse.equinox.p2.metadata.repository.mirrorApplication \
        -nosplash \
        -source $1 \
        -destination $dst_repo \
        -destinationName $dst_name \
        -verbose \
        -compare
}


# emcas+ - need proxy
mirror http://www.mulgasoft.com/emacsplus/update-site

