BASE_DIR=$(cd $(dirname $0);  pwd -P)
sudo ln -sf bash /bin/sh
source $BASE_DIR/bootstrap/os_meta_info.sh
########################################
########################################
####    
####   INSTALL CURL
####
########################################
########################################

# Test if easy_install if not install manually
command -v curl >/dev/null 2>&1
INSTALLED=$?
echo ""

if [ ! $INSTALLED == 0 ] ; then
	echo "[INFO] $OS_NAME is current OS"
	echo "INSTALLING: [ curl ]"
	# determining os distribution in case of linux and taking action accordingly
	while true; do
		case $OS_DISTRO in
	        	"CentOS" ) 
	        		sudo yum install curl-devel 
	        		break;;
	
			"Ubuntu" ) 
				sudo apt-get install -y curl 
				break;;
	 		
			* ) 	#Cases for other Distros such as Debian,SuSe,Solaris etc
				echo "Install curl"
				break;;
		esac
	done
	echo "INSTALLED: [ curl installed successfully]"
else
    echo "INSTALLED: [ curl ]"
fi

########################################
########################################
####    
####   INSTALL GIT
####
########################################
########################################

INSTALL_GIT=''
VERSION_GIT=''
REQUIRED_GIT_VERSION=1.8
GIT_FILE=''
GIT_DOWNLOAD_URL=''
GIT_INSTALL_CMD=''
UNINSTALL_GIT=''

command -v git --version >/dev/null 2>&1
INSTALLED=$?
echo ""

if [ $INSTALLED == 0 ] ; then
    #  Git is installed
    
    # git version 1.7.4.4
    
    VERSION_GIT=`git --version | awk '{print $3}'`
    
    echo "INSTALLED: [ Git ]"
    printf "\t"
    echo "$VERSION_GIT"

    $BASE_DIR/bootstrap/version_compare.py $VERSION_GIT $REQUIRED_GIT_VERSION
    CMP_RESULT=$?
    # Test if installed version is less than required version
    if [ $CMP_RESULT -lt 2 ] ; then
        # Remove GIT if not verion: $REQUIRED_GIT_VERSION
        # http://stackoverflow.com/questions/226703/how-do-i-prompt-for-input-in-a-linux-shell-script
    
        echo "Current Git Version: $VERSION_GIT"
        echo "Required Git Version: $REQUIRED_GIT_VERSION"
        echo ""
    
        echo "Install Correct Git (Delete and Install)?"
            read -p "Is this ok [y/N]:" yn
            while true; do
            case $yn in
                [Yy]* ) 
                    echo "Setting Git to be removed";
                    UNINSTALL_GIT=1
                    while true; do
	                    case $OS_NAME in
	                         "Linux" )
	                            echo "$OS_NAME Proceeding"
	                            while true; do
		                            case $OS_DISTRO in
		                                "CentOS" )
		                                    echo "$OS_DISTRO-$OS_NAME Proceeding"
		                                    GIT=`which git`
		                                    sudo rm $GIT
		                                    #### also git direcotry in home needs to be removed
		                                    break;;
		                                "Ubuntu" )
		                                    echo "$OS_DISTRO-$OS_NAME Proceeding"
		                                    GIT=`which git`
		                                    sudo rm $GIT
		                                    #### also git direcotry in home needs to be removed
		                                    break;;
		                                * )
		                                     #Cases for other Distros such as Debian,Ubuntu,SuSe etc may come here 
		                                      echo "Script for $OS_DISTRO has not been tested yet."
		                                      echo "Submit Patch to https://github.com/DemandCube/developer-setup."
		                                    break;;
		                            esac
		                    done
	                            break;;
	                         "Darwin" )
	                            echo "Mac OS X Proceeding"
	                            # For Mac OS X
	                            #Navigate to /Library/Git/GitVirtualMachines and remove the directory whose name matches the following format:*
	                            #    /Library/Git/GitVirtualMachines/jdk<major>.<minor>.<macro[_update]>.jdk
	                            #For example, to uninstall 7u6:
	                            #    % rm -rf jdk1.7.0_06.jdk
	                            GIT=`which git`
	                            sudo rm $GIT
	                            #### also needs git direcotry in home removed
	                            break;;
	                          * )
	                            #Cases for other Distros such as Debian,Ubuntu,SuSe etc may come here 
	                            echo "Script for $OS_NAME has not been tested yet."
	                            echo  "Submit Patch to https://github.com/DemandCube/developer-setup."
	                            break;;
	                    esac   
	            done
                    INSTALL_GIT=1
                    break;;
                [Nn]* ) echo "Skipping"; break;;
                * ) 
                echo "Please answer yes or no.";;
            esac
        done
    
    fi
else
    # Git is not installed
    INSTALL_GIT=1
    echo "Not Installed"
fi

# Install Git
if [ -n "$INSTALL_GIT" ] ; then
    echo "Install Git"

    while true; do
	    case $OS_NAME in
	      "Linux" )
	         echo "$OS_NAME Proceeding"
	         while true; do
		         case $OS_DISTRO in
		             "CentOS" )
		                 echo "$OS_DISTRO-$OS_NAME Proceeding"
		                 GIT_FILE="$HOME/Downloads/git-1.8.5.3.tar.gz"
		                 GIT_DOWNLOAD_URL="http://git-core.googlecode.com/files/git-1.8.5.3.tar.gz"
		                 GIT_INSTALL_CMD="sudo yum install curl-devel expat-devel gettext-devel zlib-devel perl-ExtUtils-MakeMaker asciidoc xmlto openssl-devel && cd $HOME/Downloads && tar -xzf $GIT_FILE && cd git-1.8.5.3 && ./configure --prefix=/usr --without-tcltk  && make && sudo make install"
		                 break;;
		             "Ubuntu" )
		                 echo "$OS_DISTRO-$OS_NAME Proceeding"
		                 GIT_FILE="$HOME/Downloads/git-1.8.5.3.tar.gz"
		                 GIT_DOWNLOAD_URL="http://git-core.googlecode.com/files/git-1.8.5.3.tar.gz"
		                 GIT_INSTALL_CMD="sudo apt-get install libcurl4-gnutls-dev libexpat1-dev gettext zlib1g-dev libz-dev libssl-dev &&  cd $HOME/Downloads && tar -xzf $GIT_FILE && cd git-1.8.5.3 && ./configure --prefix=/usr --without-tcltk && make && sudo make install"
		                 break;;
		             * )
		                 #Cases for other Distros such as Debian,Ubuntu,SuSe etc may come here 
		                 echo "Script for $OS_DISTRO has not been tested yet."
		                 echo "Submit Patch to https://github.com/DemandCube/developer-setup."
		                 break;;
		         esac
		  done
	          if [ ! -d "$GIT_FILE" ] ; then
	            #checking for Downloads folder
	            if [ ! -d "$HOME/Downloads" ]; then
	                mkdir "$HOME/Downloads"
	            fi  
	            curl -Lk $GIT_DOWNLOAD_URL -o $GIT_FILE
	          fi 
	          #http://stackoverflow.com/questions/2005192/how-to-execute-a-bash-command-stored-as-a-string-with-quotes-and-asterisk
	          $GIT_INSTALL_CMD
	          rm $GIT_FILE
	          break;;
	      "Darwin" )
	        echo "Mac OS X Proceeding"
	        GIT_FILE="$HOME/Downloads/git-1.8.4.2-intel-universal-snow-leopard.dmg"
	        if [ ! -d "$GIT_FILE" ] ; then
	            # Find version here
	            # curl -L --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com;" http://download.oracle.com/otn-pub/git/jdk/7u51-b13/jdk-7u51-macosx-x64.dmg -o jdk-7u51-macosx-x64.dmg
	            # http://download.oracle.com/otn-pub/git/jdk/7u51-b13/jdk-7u51-macosx-x64.dmg
	            # http://download.oracle.com/otn-pub/git/jdk/7u51-b13/jdk-7u51-linux-x64.rpm
	            
	            # check if Downloads directory exists, other create it
	            if [ ! -d "$HOME/Downloads" ]; then
	                mkdir "$HOME/Downloads"
	            fi            
	            curl -L https://git-osx-installer.googlecode.com/files/git-1.8.4.2-intel-universal-snow-leopard.dmg -o $GIT_FILE
	        fi
	        VOLUME_PATH_GIT='/Volumes/Git 1.8.4.2 Snow Leopard Intel Universal/'
	        PACKAGE_NAME_GIT='git-1.8.4.2-intel-universal-snow-leopard.pkg'
	        
	        hdiutil attach $GIT_FILE
	        
	        if [ -n "$INSTALL_GIT" ] ; then
	            sudo "${VOLUME_PATH_GIT}uninstall.sh"
	        fi
	        
	        sudo installer -package "${VOLUME_PATH_GIT}${PACKAGE_NAME_GIT}" -target '/Volumes/Macintosh HD'
	        sudo "${VOLUME_PATH_GIT}setup git PATH for non-terminal programs.sh"
	        
	        hdiutil detach "$VOLUME_PATH_GIT"
	        
	        NEW_VERSION_GIT=`git --version | awk '{print $3}'`
	        
	        if [ "$VERSION_GIT" == "$NEW_VERSION_GIT" ] ; then
	            echo "Installed git version isn't matching so creating symbolic link to correct version"
	            sudo mv /usr/bin/git /usr/bin/git-{$VERSION_GIT}
	            sudo ln -s /usr/local/git/bin/git /usr/bin/git
	            TEST_VERSION_GIT=`git --version | awk '{print $3}'`
	            if [ "$VERSION_GIT" == "$TEST_VERSION_GIT" ] ; then
	                echo "Didn't work!"
	                echo ""
	                echo "YOU!!!!!"
	                echo " Need to investigate why GIT didn't update properly, probably a path issue"
	                echo "Should install git to /usr/local/git"
	                echo "which git"
	                echo "git --version"
	                echo "ls -al `which git`"
	            else
	                echo "INSTALLED: [ Git ]"
	                printf "\t"
	                echo "$TEST_VERSION_GIT"
	            fi
	        fi
	        
	        echo "Remove downloaded file ($GIT_FILE) ?"
	        while true; do
	            read -p "Is this ok [y/N]:" yn
	            case $yn in
	                [Yy]* ) 
	                    rm $GIT_FILE
	                    break;;
	                [Nn]* ) echo "Skipping"; break;;
	                * ) echo "Please answer yes or no.";;
	            esac
	        done
	        break;;
	      * )
	        #Cases for other Distros such as Debian,Ubuntu,SuSe etc may come here 
	        echo "Script for $OS_NAME has not been tested yet."
	        echo "Submit Patch to https://github.com/DemandCube/developer-setup."
	        break;;
	   esac
   done
fi
echo "Deployment successfully completed..."
# BASE_DIR=$(cd $(dirname $0);  pwd -P)
# ansible-playbook $BASE_DIR/helloworld_local.yaml -i $BASE_DIR/inventoryfile
