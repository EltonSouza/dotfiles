#!/bin/bash

#HOME=/home/esouza
HOME=$( getent passwd "$USER" | cut -d: -f6 )
DIR=$(pwd)
cd /tmp/
system_info=$(ls -l)
#echo "$system_info" 
echo "$HOME"

command_exists() {
    command -v "$1" &> /dev/null ;
}

# Add RPM Fusion repo
printf "\nAdd RPM Fusion repo\n"
sudo rpm -Uvh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo rpm -Uvh http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# installing gnome-tweak-tool
printf "\n\ninstalling gnome-tweak-tool\n"
if ! command_exists gnome-tweak-tool; then
	sudo dnf install gnome-tweak-tool -y
else
	echo "gnome-tweak-tool is already installed"
fi
printf "done\n"

# installing chrome-gnome-shell
printf "\n\ninstalling chrome-gnome-shell\n"
if ! command_exists chrome-gnome-shell; then
    sudo dnf install chrome-gnome-shell -y
else
	echo "chrome-gnome-shell is already installed"
fi
printf "done\n"

# installing fuse-exfat
printf "\n\ninstalling fuse-exfat\n"
if ! command_exists mount.exfat-fuse; then
	 sudo dnf -y install fuse-exfat
else
	echo "fuse-exfat is already installed"
fi
printf "done\n"

# installing vlc
printf "\n\ninstalling vlc\n"
if ! command_exists vlc; then
	 sudo dnf install vlc -y
else
	echo "vlc is already installed"
fi
printf "done\n"

# installing spotify
printf "\n\ninstalling spotify\n"
if ! command_exists spotify; then
	sudo dnf config-manager --add-repo=http://negativo17.org/repos/fedora-spotify.repo
	sudo dnf install spotify -y
else
	echo "spotify is already installed"
fi
printf "done\n"

# installing git
printf "\n\ninstalling git\n"
if ! command_exists git; then
    sudo dnf install -y git
    echo "Informe o Nome para o usuario do git"
    read userNameGit;
    echo "Informe email do git"
    read emailGit
    git config --global user.name "$userNameGit"
    git config --global user.email "$emailGit"
    #git config --global push.default simple
    git config --global url."git@github.com:".insteadOf "https://github.com/"
else
    echo "git is already installed"
fi
printf "done\n"

# installing vim and related
printf "\n\ninstalling vim\n"
if ! command_exists vim; then
	sudo dnf install vim -y
else
	echo "vim is already installed"
fi
printf "done\n"

# installing tmux
printf "\n\ninstalling tmux\n"
if ! command_exists tmux; then
	sudo dnf install tmux -y
else
	echo "tmux is already installed"
fi
printf "done\n"

# installing htop 
printf "\n\ninstalling htop\n"
if ! command_exists htop; then
	sudo dnf install htop -y
else
	echo "htop is already installed"
fi
printf "done\n"

# installing curl
printf "\n\ninstalling curl\n"
if ! command_exists curl; then
	sudo dnf install curl -y
else
	echo "curl is already installed"
fi
printf "done\n"

# installing composer
printf "\n\ninstalling composer\n"
if ! command_exists composer; then
	sudo dnf install composer -y
else
	echo "composer is already installed"
fi
printf "done\n"

# installing
printf "\n\ninstalling some extra stuff\n"
    sudo dnf -y install dnf-plugins-core util-linux-user lm_sensors
printf "done\n"

# installing docker
printf "\n\ninstalling docker\n"
if ! command_exists docker; then
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf config-manager --set-enabled docker-ce-edge
    #sudo dnf config-manager --set-enabled docker-ce-testing
    #sudo dnf makecache fast
    sudo dnf install docker-ce -y
    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo systemctl enable docker
    sudo systemctl start docker

    if ! command_exists docker-compose; then
        sudo dnf install docker-compose -y
        #sudo dnf install docker-machine
    fi
else
    echo "docker is already installed"
fi
printf "done\n"

# installing postgresql-server
printf "\n\ninstalling postgresql-server\n"
if ! command_exists postgres; then
    sudo dnf install -y postgresql-server
    sudo systemctl enable postgresql
    sudo postgresql-setup --initdb
    sudo systemctl start postgresql

    # set a password for user postgres
    # $ sudo -u postgres psql
    # \password
    # Enter password: ...
    # \q
    # maybe will necessary to change the file /var/lib/pgsql/data/pg_hba.conf
    # # IPv4 local connections:
    # host    all             all             127.0.0.1/32            password
    # IPv6 local connections:
    # host    all             all             ::1/128                 password

else
    echo "postgres-server is already installed"
fi
printf "done\n"

# installing exiftool
printf "\n\ninstalling exiftool\n"
if ! command_exists exiftool; then
    sudo dnf install -y perl-Image-ExifTool
else
    echo "exiftool is already installed"
fi
printf "done\n"

# installing vscode
printf "\n\ninstalling vscode\n"
if ! command_exists code; then
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo dnf install code
else
    echo "vscode is already installed"
fi
printf "done\n"

# installing zsh
printf "\n\ninstalling zsh and other bash stuff\n"
if ! command_exists zsh; then
    sudo dnf install -y zsh terminator

    # cloning Powerline fonts
    git clone https://github.com/powerline/fonts.git --depth=1
    # install
    cd fonts
    ./install.sh
    # clean-up a bit
    cd ..
    rm -rf fonts

    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
else
    echo "zsh is already installed"
fi
printf "done\n"

cd $HOME
if [ ! -d $HOME/.git ]; then
    git init
    git remote add origin git@github.com:EltonSouza/dotfiles.git
    git fetch origin
    git reset --hard origin/master
fi

vim +PlugInstall +qall

mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf

# go back
cd $DIR
