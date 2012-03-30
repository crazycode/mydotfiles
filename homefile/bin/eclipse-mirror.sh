#!/bin/bash

eclipse_home=/opt/eclipse/eclipse-3.6.1
dst_repo=/opt/eclipse/mirrors
dst_name=LocalMirror


function mirror() {
    echo "update mirror: $1 ..."
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

mirror http://springide.org/updatesite/

# google
mirror http://dl.google.com/eclipse/inst/d2wbpro/latest/3.6
mirror http://dl.google.com/eclipse/inst/codepro/latest/3.6
mirror http://dl.google.com/eclipse/inst/d2gwt/latest/3.6
mirror http://dl.google.com/eclipse/plugin/3.6

# jboss
mirror http://download.jboss.org/jbosstools/updates/development/

# m2eclipse
mirror http://m2eclipse.sonatype.org/sites/m2e/


# emcas+ - need proxy
# mirror http://www.mulgasoft.com/emacsplus/update-site

