do_install_kde() {
	if (whiptail --title "Install a Desktop Environment" --yesno "You are about to install the KDE desktop. Are you sure?" 8 78) then {
		trap 'error "Install a Desktop Environment" "Installation has been aborted."; return 1' INT
		
		zypper refresh
		
		zypper install -y \
			xserver-xorg-video-fbturbo \
			libvdpau-sunxi \
			libump \
			libcedrus \
			patterns-openSUSE-kde \
			patterns-openSUSE-kde_plasma
		
		if [ $? -eq 0 ]; then
			sed -i 's/DISPLAYMANAGER=.*/DISPLAYMANAGER="sddm"/g' /etc/sysconfig/displaymanager
			if (whiptail --title "Install a Desktop Environment" --yesno "This tool will now require a reboot in order to finish up the installation. Reboot now?" 8 78) then
				shutdown -r now
			fi
		elif [ $? -eq 1 ]; then
			echo "##############################################################################"
			echo "##      ERROR: The installation process failed. Please try again later      ##"
			echo "##      Press ENTER to continue...                                          ##"
			echo "##############################################################################"
			read
		else
			error "Install a Desktop Environment" "ERROR: An unknown error has been detected. ($?)"
		fi		
		return 0
	}
	else
		return 0
	fi
}
