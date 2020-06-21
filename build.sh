#!/bin/bash
## build wine with vkd3d + deps
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

for ARG in $ARGS
    do
        if [[ $ARG == "--threads"* ]];then
            THRD=1
            threads=$(echo $ARG | cut -d'=' -f2)
        elif [ $ARG == "--only-repos" ];then
            REPOFLAG=1
        elif [[ $ARG == "--dest"* ]];then
            DST=1
            DEST=$(echo $ARG | cut -d'=' -f2)
        elif [ $ARG == "--h" ] || [ $ARG == "--help" ] || [ $ARG == "-h" ];then
            echo "
supported flags:
--only-repos            : Only pull git repos and download tar packages.
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

process_repos() {
    
    if [ ! -d "xfce4-dev-tools" ];then
        git clone https://gitlab.xfce.org/xfce/xfce4-dev-tools
    else
        cd ./xfce4-dev-tools
        git clean -xdf
        git reset --hard HEAD
        git pull origin master
        cd ..
    fi
    
    if [ ! -d "libxfce4util" ];then
        git clone https://gitlab.xfce.org/xfce/libxfce4util
    else
        cd ./libxfce4util
        git clean -xdf
        git reset --hard HEAD
        git pull origin master
        cd ..
    fi
    
    if [ ! -d "xfconf" ];then
        git clone https://gitlab.xfce.org/xfce/xfconf
    else
        cd ./xfconf
        git clean -xdf
        git reset --hard HEAD
        git pull origin master
        cd ..
    fi
    
    if [ ! -d "libxfce4ui" ];then
        git clone https://gitlab.xfce.org/xfce/libxfce4ui
    else
        cd ./libxfce4ui
        git clean -xdf
        git reset --hard HEAD
        git pull origin master
        cd ..
    fi
    
    if [ ! -d "garcon" ];then
        git clone https://gitlab.xfce.org/xfce/garcon
    else
        cd ./garcon
        git clean -xdf
        git reset --hard HEAD
        git pull origin master
        cd ..
    fi
    
    if [ ! -d "exo" ];then
        git clone https://gitlab.xfce.org/xfce/exo
    else
        cd ./exo
        git clean -xdf
        git reset --hard HEAD
        git pull origin master
        cd ..
    fi
    
    if [ ! -d "thunar" ];then
        git clone https://gitlab.xfce.org/xfce/thunar
    else
        cd ./thunar
        git clean -xdf
        git reset --hard HEAD
        git pull origin master
        cd ..
    fi
    
    if [ ! -d "xfce4-panel" ];then
        git clone https://gitlab.xfce.org/xfce/xfce4-panel
    else
        cd ./xfce4-panel
        git clean -xdf
        git reset --hard HEAD
        git pull origin master
        cd ..
    fi
    
    if [ ! -d "xfce4-settings" ];then
        git clone https://gitlab.xfce.org/xfce/xfce4-settings
    else
        cd ./xfce4-settings
        git clean -xdf
        git reset --hard HEAD
        git pull origin master
        cd ..
    fi
    
    if [ ! -d "xfce4-session" ];then
        git clone https://gitlab.xfce.org/xfce/xfce4-session
    else
        cd ./xfce4-session
        git clean -xdf
        git reset --hard HEAD
        git pull origin master
        cd ..
    fi
    
    if [ ! -d "xfdesktop" ];then
        git clone https://gitlab.xfce.org/xfce/xfdesktop
    else
        cd ./xfdesktop
        git clean -xdf
        git reset --hard HEAD
        git pull origin master
        cd ..
    fi
    
    if [ ! -d "xfwm4" ];then
        git clone https://gitlab.xfce.org/xfce/xfwm4
    else
        cd ./xfwm4
        git clean -xdf
        git reset --hard HEAD
        git pull origin master
        cd ..
    fi
    
    if [ ! -d "xfce4-appfinder" ];then
        git clone https://gitlab.xfce.org/xfce/xfce4-appfinder
    else
        cd ./xfce4-appfinder
        git clean -xdf
        git reset --hard HEAD
        git pull origin master
        cd ..
    fi
    
    if [ ! -d "tumbler" ];then
        git clone https://gitlab.xfce.org/xfce/tumbler
	else
        cd ./tumbler
        git clean -xdf
        git reset --hard HEAD
        git pull origin master
        cd ..
    fi
    
    if [ ! -d "xfce4-wavelan-plugin" ];then
        git clone https://gitlab.xfce.org/panel-plugins/xfce4-wavelan-plugin
	else
        cd ./xfce4-wavelan-plugin
        git clean -xdf
        git reset --hard HEAD
        git pull origin master
        cd ..
    fi
    
    if [ ! -d "xfce4-pulseaudio-plugin" ];then
        git clone https://gitlab.xfce.org/panel-plugins/xfce4-pulseaudio-plugin
	else
        cd ./xfce4-pulseaudio-plugin
        git clean -xdf
        git reset --hard HEAD
        git pull origin master
        cd ..
    fi
    
    if [ ! -d "xfce4-notifyd" ];then
        git clone https://gitlab.xfce.org/apps/xfce4-notifyd
	else
        cd ./xfce4-notifyd
        git clean -xdf
        git reset --hard HEAD
        git pull origin master
        cd ..
    fi
	
	if [ ! -d "xfce4-battery-plugin" ];then
        git clone https://gitlab.xfce.org/panel-plugins/xfce4-battery-plugin
	else
        cd ./xfce4-battery-plugin
        git clean -xdf
        git reset --hard HEAD
        git pull origin master
        cd ..
	 fi
	
	

}

prepare(){
    cd "$DIRECTORY"
    if [ ! -d "xfce4-prepare" ];then
        mkdir xfce4-prepare
        sleep 1
    fi
    
    cp -rf xfce4-dev-tools xfce4-prepare/xfce4-dev-tools
	cp -rf libxfce4util xfce4-prepare/libxfce4util
	cp -rf xfconf xfce4-prepare/xfconf
	cp -rf libxfce4ui xfce4-prepare/libxfce4ui
	cp -rf garcon xfce4-prepare/garcon
	cp -rf exo xfce4-prepare/exo
	cp -rf thunar xfce4-prepare/thunar
	cp -rf xfce4-panel xfce4-prepare/xfce4-panel
	cp -rf xfce4-settings xfce4-prepare/xfce4-settings
	cp -rf xfce4-session xfce4-prepare/xfce4-session
	cp -rf xfdesktop xfce4-prepare/xfdesktop
	cp -rf xfwm4 xfce4-prepare/xfwm4
	cp -rf xfce4-appfinder xfce4-prepare/xfce4-appfinder
	cp -rf tumbler xfce4-prepare/tumbler
	cp -rf xfce4-wavelan-plugin xfce4-prepare/xfce4-wavelan-plugin
    cp -rf xfce4-pulseaudio-plugin xfce4-prepare/xfce4-pulseaudio-plugin
	cp -rf xfce4-notifyd xfce4-prepare/xfce4-notifyd
	cp -rf xfce4-battery-plugin xfce4-prepare/xfce4-battery-plugin

}


disable_gtkdoc(){
	CONF=""
	if [ "$NAME" == "tumbler" ];then
		CONF="configure.ac"
	else
		CONF="configure.ac.in"
	fi
	
	sed -i 's+GTK_DOC_CHECK+#GTK_DOC_CHECK+g' $CONF
	sed -i 's+docs/Makefile++g' $CONF
	sed -i 's+docs/design/Makefile++g' $CONF
	sed -i 's+docs/papers/Makefile++g' $CONF
	sed -i 's+docs/reference/Makefile++g' $CONF
	sed -i 's+docs/reference/version.xml++g' $CONF
	sed -i 's+docs/reference/thunarx/Makefile++g' $CONF
	sed -i 's+docs/reference/thunarx/version.xml++g' $CONF
	sed -i 's+docs/reference/tumbler/Makefile++g' $CONF
	sed -i 's+docs/reference/tumbler/version.xml++g' $CONF
	sed -i 's+docs/references/Makefile++g' $CONF
	sed -i 's+docs/references/version.xml++g' $CONF
	sed -i 's+docs/spec/Makefile++g' $CONF
    sed -i 's+docs/version.xml++g' $CONF
	sed -i 's+docs+#docs+g' Makefile.am
	sed -i 's+gtk-doc.make+#gtk-doc.make+g' Makefile.am
	sed -i 's+--enable-gtk-doc+#--enable-gtk-doc+g' Makefile.am
}


compile(){
    ##FUCK GTK-DOC, DUDE
    NAME="$1"
	disable_gtkdoc "$NAME" &> "$DIRECTORY"/logs/"$NAME".log
    
	CONF_ARGS="--prefix=/opt/xfce4 --disable-gtk2 --libdir=/usr/lib64 --sysconfdir=/etc --datarootdir=/usr/share --disable-man --localstatedir=/var --enable-keybinder --enable-libnotify"
    ./autogen.sh &>> "$DIRECTORY"/logs/"$NAME".log
    ./configure $CONF_ARGS --enable-maintainer-mode &>> "$DIRECTORY"/logs/"$NAME".log
    
    if [ "$NAME" == "xfce4-dev-tools" ];then
        sed -i 's+docs        \\+#docs        \\+g' Makefile
    fi
    
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

build(){
	
	
	#########   xfce4-dev-tools
    NAME="xfce4-dev-tools"
    cd "$DIRECTORY"/xfce4-prepare/"$NAME"
    compile $NAME
    
	#########   libxfce4util
	NAME="libxfce4util"
    cd "$DIRECTORY"/xfce4-prepare/"$NAME"
    compile $NAME
    
	#xfce4-prepare/xfconf
	NAME="xfconf"
    cd "$DIRECTORY"/xfce4-prepare/"$NAME"
    compile $NAME
    
	#xfce4-prepare/libxfce4ui
	NAME="libxfce4ui"
    cd "$DIRECTORY"/xfce4-prepare/"$NAME"
    compile $NAME
    
	#xfce4-prepare/garcon
	NAME="garcon"
    cd "$DIRECTORY"/xfce4-prepare/"$NAME"
    compile $NAME
    
	#xfce4-prepare/exo
	NAME="exo"
    cd "$DIRECTORY"/xfce4-prepare/"$NAME"
    compile $NAME
    
	#xfce4-prepare/thunar
	NAME="thunar"
    cd "$DIRECTORY"/xfce4-prepare/"$NAME"
    compile $NAME
    
	#xfce4-prepare/xfce4-panel
	NAME="xfce4-panel"
    cd "$DIRECTORY"/xfce4-prepare/"$NAME"
    compile $NAME
    
	#xfce4-prepare/xfce4-settings
	NAME="xfce4-settings"
    cd "$DIRECTORY"/xfce4-prepare/"$NAME"
    compile $NAME
    
	#xfce4-prepare/xfce4-session
	NAME="xfce4-session"
    cd "$DIRECTORY"/xfce4-prepare/"$NAME"
    compile $NAME
    
	#xfce4-prepare/xfdesktop
	NAME="xfdesktop"
    cd "$DIRECTORY"/xfce4-prepare/"$NAME"
    compile $NAME
    
	#xfce4-prepare/xfwm4
	NAME="xfwm4"
    cd "$DIRECTORY"/xfce4-prepare/"$NAME"
    compile $NAME
    
	#xfce4-prepare/xfce4-appfinder
	NAME="xfce4-appfinder"
    cd "$DIRECTORY"/xfce4-prepare/"$NAME"
    compile $NAME
    
	#xfce4-prepare/tumbler
	NAME="tumbler"
    cd "$DIRECTORY"/xfce4-prepare/"$NAME"
    compile $NAME
    
	#xfce4-prepare/xfce4-wavelan-plugin
	NAME="xfce4-wavelan-plugin"
    cd "$DIRECTORY"/xfce4-prepare/"$NAME"
    compile $NAME
    
    #xfce4-prepare/xfce4-pulseaudio-plugin
	NAME="xfce4-pulseaudio-plugin"
    cd "$DIRECTORY"/xfce4-prepare/"$NAME"
    compile $NAME
    
	#xfce4-prepare/xfce4-notifyd
	NAME="xfce4-notifyd"
    cd "$DIRECTORY"/xfce4-prepare/"$NAME"
    compile $NAME
    
	#xfce4-prepare/xfce4-battery-plugin
	NAME="xfce4-battery-plugin"
    cd "$DIRECTORY"/xfce4-prepare/"$NAME"
    compile $NAME
    
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
