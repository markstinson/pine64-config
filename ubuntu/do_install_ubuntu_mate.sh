do_install_ubuntu_mate() {
	if (whiptail --title "Install a Desktop Environment" --yesno "You are about to install the Ubuntu MATE desktop. Are you sure?" 8 78) then {
		echo 'Dpkg::Progress-Fancy "1";' > /etc/apt/apt.conf.d/99progressbar
		
		trap 'error "Install a Desktop Environment" "Installation has been aborted."; return 1' INT
		
		apt update
		
		apt -y install \
			xserver-xorg-video-fbturbo \
			sunxi-disp-tool \
			libvdpau-sunxi1 \
			libump \
			libcedrus1 \
			ubuntu-mate-core \
			ubuntu-mate-desktop \
			ubuntu-mate-lightdm-theme \
			ubuntu-mate-wallpapers-xenial \
			lightdm
		
		if [ $? -eq 0 ]; then
			if (whiptail --title "Install a Desktop Environment" --yesno "This tool will now require a reboot in order to finish up the installation. Reboot now?" 8 78) then
				shutdown -r now
			fi
		elif [ $? -eq 1 ]; then
			error "Install a Desktop Environment" "ERROR: Looks like another process is using the package manager at the moment. Try again later. ($?)"
		else
			error "Install a Desktop Environment" "ERROR: An unknown error has been detected. ($?)"
		fi		
		return 0
	}
	else
		return 0
	fi
}
