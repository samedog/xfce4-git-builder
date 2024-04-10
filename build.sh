#!/bin/bash
## build xfce4
##########################################################################################
# By Diego Cardenas "The Samedog" under GNU GENERAL PUBLIC LICENSE Version 2, June 1991
# (www.gnu.org/licenses/old-licenses/gpl-2.0.html) e-mail: the.samedog[]gmail.com.
# https://github.com/samedog/xfce4-git-builder
##########################################################################################
DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DIRECTORY="$(echo $DIRECTORY | sed 's/ /\\ /g')"


RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
ARGS="$@"
DST=0
DEST=""
REPOFLAG=0
THRD=0
threads=$(grep -c processor /proc/cpuinfo)

if [ ! -d ./logs ];then
	mkdir logs
fi


### just in case we set this
export PATH="/opt/xfce4/bin:/opt/xfce4/sbin:$PATH"
export LD_LIBRARY_PATH="/opt/xfce4/lib:$LD_LIBRARY_PATH"
export CPLUS_INCLUDE_PATH="/opt/xfce4/include:$CPLUS_INCLUDE_PATH" 
export PKG_CONFIG_PATH="/opt/xfce4/lib/pkgconfig:$PKG_CONFIG_PATH"


for ARG in $ARGS
    do
        if [[ $ARG == "--threads"* ]];then
            THRD=1
            threads=$(echo $ARG | cut -d'=' -f2)
        elif [ $ARG == "--pull-only" ];then
            REPOFLAG=1
        elif [[ $ARG == "--dest"* ]];then
            DST=1
            DEST=$(echo $ARG | cut -d'=' -f2) 
        elif [ $ARG == "--h" ] || [ $ARG == "--help" ] || [ $ARG == "-h" ];then
            echo "
supported flags:
--pull-only             : Only pull git repos and download tar packages.
--threads=x             : Number of compiling threads.
--h --help -h           : Show this help and exit.
--dest=/path/to/dest    : DESTDIR like argument.
"
			exit 1
		fi
	done


cleanup(){
    cd "$DIRECTORY"
    if [ -d "xfce4-prepare" ];then
        rm -rf ./xfce4-prepare
        sleep 1
    fi
    
}

process_git(){
	GURL="$1"
	NAME=$(echo $GURL | rev | cut -d '/' -f 1 | rev)
	if [ ! -d "$NAME" ];then
        git clone $GURL
    else
		if  [ "$NAME" == "xfce4-whiskermenu-plugin" ];then
			cd ./$NAME
			git clean -xdf
			git reset --hard HEAD
			git pull origin main
			cd ..
		else
			cd ./$NAME
			git clean -xdf
			git reset --hard HEAD
			git pull origin master
			git submodule update --init --recursive
			cd ..
		fi
    fi
}

LIST="https://gitlab.xfce.org/xfce/xfce4-dev-tools
https://gitlab.xfce.org/xfce/libxfce4util
https://gitlab.xfce.org/xfce/xfconf
https://gitlab.xfce.org/xfce/libxfce4ui
https://gitlab.xfce.org/xfce/garcon
https://gitlab.xfce.org/xfce/exo
https://gitlab.xfce.org/xfce/libxfce4windowing
https://gitlab.xfce.org/xfce/thunar
https://gitlab.xfce.org/xfce/xfce4-panel
https://gitlab.xfce.org/xfce/xfce4-settings
https://gitlab.xfce.org/xfce/xfce4-session
https://gitlab.xfce.org/xfce/xfdesktop
https://gitlab.xfce.org/xfce/xfwm4
https://gitlab.xfce.org/xfce/xfce4-appfinder
https://gitlab.xfce.org/xfce/tumbler
https://gitlab.xfce.org/xfce/xfce4-power-manager
https://gitlab.xfce.org/panel-plugins/xfce4-wavelan-plugin
https://gitlab.xfce.org/apps/xfce4-notifyd
https://gitlab.xfce.org/panel-plugins/xfce4-battery-plugin
https://gitlab.xfce.org/apps/xfce4-terminal
https://gitlab.xfce.org/apps/xfce4-screenshooter
https://gitlab.xfce.org/apps/xfce4-taskmanager
https://gitlab.xfce.org/panel-plugins/xfce4-pulseaudio-plugin
https://gitlab.xfce.org/panel-plugins/xfce4-statusnotifier-plugin"
#https://gitlab.xfce.org/panel-plugins/xfce4-whiskermenu-plugin
#whiskermenu doesnt currently build on frankenpup :(


process_repos() {
    for object in $LIST;do
		 process_git $object
    done
}

prepare(){
    cd "$DIRECTORY"
    if [ ! -d "xfce4-prepare" ];then
        mkdir xfce4-prepare
        sleep 1
    fi
    
    for object in $LIST;do
		 NAME=$(echo $object | rev | cut -d '/' -f 1 | rev)
		 cp -rf $NAME xfce4-prepare/$NAME
    done

}


disable_gtkdoc(){
	CONF=""
	if [ "$NAME" == "xfdesktop" ] || [ "$NAME" == "xfwm4" ] || [ "$NAME" == "xfce4-appfinder" ] || [ "$NAME" == "xfce4-wavelan-plugin" ] || [ "$NAME" == "xfce4-battery-plugin" ] || [ "$NAME" == "xfce4-screenshooter" ] || [ "$NAME" == "xfce4-taskmanager" ] || [ "$NAME" == "xfce4-statusnotifier-plugin" ];then
		CONF="configure.ac.in"
		sed -i '\+docs+d' Makefile.am
		sed -i '\+docs/+d' Makefile.am
	elif [ "$NAME" == "xfce4-terminal" ];then
		CONF="configure.ac.in"
		sed -i '\+doc/Makefile+d' $CONF
		sed -i '\+doc+d' Makefile.am
	else
		#if [ "$NAME" == "libxfce4windowing" ];then
		#	sed -i 's/protocols/#protocols/g' Makefile.am
		#fi
		CONF="configure.ac"
		sed -i '\+docs+d' Makefile.am
		sed -i '\+docs/+d' Makefile.am
	fi
	sed -i 's+GTK_DOC_CHECK+#GTK_DOC_CHECK+g' $CONF
	sed -i '\+docs/+d' $CONF
	sed -i '\+gtk-doc.make+d' Makefile.am
	sed -i 's+--enable-gtk-doc+#--enable-gtk-doc+g' Makefile.am
}

make_func(){
	

	
	make -j"$threads" &>> "$DIRECTORY"/logs/"$NAME".log
    if [ $? -eq 0 ]; then
        if [ $DST -eq 1 ]; then
            make -j"$threads" install DESTDIR="$DEST" &>> "$DIRECTORY"/logs/"$NAME".log
        else
            make -j"$threads" install &>> "$DIRECTORY"/logs/"$NAME".log
        fi
    else
        printf $RED"something went wrong making $NAME\n"$NC
        exit 1
    fi
    
	
}
compile(){
    ##FUCK GTK-DOC, DUDE
    NAME="$1"
    cd "$DIRECTORY"/xfce4-prepare/"$NAME"
	disable_gtkdoc "$NAME" &> "$DIRECTORY"/logs/"$NAME".log
    
	CONF_ARGS="--prefix=/opt/xfce4 --disable-doc --enable-gtk-layer-shell --disable-gtk2 --sysconfdir=/etc --datarootdir=/usr/share --disable-man --localstatedir=/var --enable-keybinder --enable-libnotify"
    ./autogen.sh &>> "$DIRECTORY"/logs/"$NAME".log
    ./configure $CONF_ARGS --enable-maintainer-mode &>> "$DIRECTORY"/logs/"$NAME".log
    
    if [ "$NAME" == "xfce4-dev-tools" ];then
        sed -i 's+docs        \\+#docs        \\+g' Makefile
    fi
    
    make_func
}
compile_cmake(){
    ##FUCK GTK-DOC, DUDE
    NAME="$1"
    cd "$DIRECTORY"/xfce4-prepare/"$NAME"
	disable_gtkdoc "$NAME" &> "$DIRECTORY"/logs/"$NAME".log
    
    CMAKE_ARGS="-DCMAKE_INSTALL_PREFIX=/opt/xfce4  -DCMAKE_INSTALL_DATAROOTDIR=/usr/share -DCMAKE_INSTALL_SYSCONFDIR=/etc -DCMAKE_INSTALL_LOCALSTATEDIR=/var .."
    
	mkdir build
	cd build
	
	cmake $CMAKE_ARGS  ..
	make_func

}

build(){
	for object in $LIST;do
		NAME=$(echo $object | rev | cut -d '/' -f 1 | rev)
		echo "compiling $NAME"
		if [ $NAME == "xfce4-whiskermenu-plugin" ];then
			compile_cmake $NAME
		else
			compile $NAME
		fi
    done    
}


printf $GREEN"HELLO THERE!\n"
printf "THIS SMALL SCRIPT WILL BUILD XFCE4 FROM GIT\n"
printf "\n"
if [ $THRD -eq 1 ] || [ $DST -eq 1 ] || [ $REPOFLAG -eq 1 ];then
    printf $YELLOW"Options:\n"$NC
fi
if [ $THRD -eq 1 ];then
    printf $YELLOW"Using "$threads" threads\n"$NC
fi
if [ $REPOFLAG -eq 1 ];then
    printf $YELLOW"Stopping at repos\n"$NC
fi
if [ $DST -eq 1 ];then
    printf $YELLOW"Using $DEST as target folder\n"$NC
fi

read -p 'is this ok? (Y/N)' uservar
if [ $uservar == "n" ] || [ $uservar == "N" ];then
    printf $RED"Stoppnig\n"$NC
    exit 1
elif [ $uservar == "y" ] || [ $uservar == "Y" ];then
    printf $GREEN"Continuing\n"$NC
else
    printf $YELLOW"Please answer y or n\n"$NC
    printf $RED"Stoppnig\n"$NC
    exit 1
fi

printf "\n"$NC

printf $YELLOW"cleanup\n"$NC
cleanup

printf $GREEN"cloning repos\n"$NC
process_repos
if [ $REPOFLAG -eq 1 ];then
    exit 1
fi

printf $YELLOW"preparing folders...\n"$NC
prepare

printf $YELLOW"building\n"$NC
build

printf $YELLOW"cleanup\n"$NC
cleanup
