#!/bin/bash

FILE=$(basename ${BASH_SOURCE})

while test $# -gt 0; do
  case ${1} in
    -h|--help)
      echo "${FILE} - set HI-DPI scaling factor for GDM"
      echo " "
      echo "${FILE} [options] application [arguments]"
      echo " "
      echo "options:"
      echo "-h, --help                show brief help"
      echo "-s, --scale-factor        floating point value eg. 1, 1.0, 1.5, 1.75, 2, 2.0 etc"
      exit 0
      ;;
    -s|--scale-factor) 
      SCALE_FACTOR=${2}
      echo "-----------------------------------------------"
      echo "This configuration must be run as the ROOT user"
      echo "Please enter the password for the ROOT user    "
      echo "when prompted.                                 "
      echo "-----------------------------------------------"
      su - root -c 'echo "[org.gnome.desktop.interface]" > /usr/share/glib-2.0/schemas/93_hidpi.gschema.override;
      		    echo "scaling-factor='${SCALE_FACTOR}'" >> /usr/share/glib-2.0/schemas/93_hidpi.gschema.override;
      		    glib-compile-schemas /usr/share/glib-2.0/schemas'
      exit 0 
      ;;
  esac
done
