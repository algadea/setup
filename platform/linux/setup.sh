#!/bin/bash

#==============================================================================#
#  ╔═╗╔═╗╔╦╗╦ ╦╔═╗                                                             #
#  ╚═╗║╣  ║ ║ ║╠═╝   Synchronize dotfiles and repositories the quick way       #
#  ╚═╝╚═╝ ╩ ╚═╝╩     on Linux, Mac, Windows and BSD.                           #
#                                                                              #
#  Developed by Anska.                                                         #
#  Contact me by mail at anska@tuta.io or on github https://github.com/algadea #
#  if you have any issues or questions.                                        #
#                                                                              #
#  Published under MIT license, please do enjoy!                               #
#==============================================================================#

HEADER="\
╔═╗╔═╗╔╦╗╦ ╦╔═╗
╚═╗║╣  ║ ║ ║╠═╝
╚═╝╚═╝ ╩ ╚═╝╩  "

# Global variables
VERSION="1.0.0"
SETUP_SHELL=none
SETUP_SHELL_RC=none
SETUP_DIR="$HOME/.setup"
SETUP_DIR_LINUX="$SETUP_DIR/platform/linux"
SETUP_LINUX_SCRIPT="$SETUP_DIR_LINUX/setup.sh"
SETUP_BIN_DIR="$HOME/.local/bin"
SETUP_BIN="setup"
SETUP_BIN_ABSOLUTE_PATH="$SETUP_BIN_DIR/$SETUP_BIN"

# Text formating
DEFAULT="\033[0m"
BOLD="\033[1m"
ITALIC="\033[3m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"

main()
{
	# Set SIGINT handler
	trap signal_handler SIGINT

	if [ $# -eq 1 ]; then
		case $1 in
			"--install")
			setup_install
			;;
			"--pull")
			setup_pull
			;;
			"--push")
			setup_push
			;;
			"--set-dir")
			;;
			"--unset-dir")
			;;
			"--set-font")
			;;
			"--unset-font")
			;;
			"--version")
			echo -e "$BOLD${WHITE}setup $VERSION$DEFAULT"
			;;
			"--help" | *)
			print_usage
			;;
		esac 
	else
		print_usage
	fi
	exit 0
}

#============================================================================= #
#  ╦╔╗╔╔═╗╔╦╗╔═╗╦  ╦                                                           #
#  ║║║║╚═╗ ║ ╠═╣║  ║                                                           #
#  ╩╝╚╝╚═╝ ╩ ╩ ╩╩═╝╩═╝                                                         #
#============================================================================= #

setup_install()
{
	local header_install="\
	╦╔╗╔╔═╗╔╦╗╔═╗╦  ╦  
	║║║║╚═╗ ║ ╠═╣║  ║  
	╩╝╚╝╚═╝ ╩ ╩ ╩╩═╝╩═╝"

	# Print introduction
	print_text "$BLUE" "$HEADER" delay
	print_text "$BOLD$WHITE" "$header_install" delay
	echo

	# Ask the user if he wants to proceed this action
	echo -e "$BOLD${YELLOW}WARNING$DEFAULT"
	echo -en "$BOLD${WHITE}This action will replace any local config files "
	echo -en "that are used in this script and create the setup binary "
	echo -en "located into the $HOME/.local/bin directory, "
	echo -e "do you really want to proceed?$DEFAULT"
	echo -e "y: yes\nn: no"
	while true; do
		read answer
		if [ $answer ]; then
			case $answer in 
				"y" | "yes")
				echo
				break
				;;
				"n" | *)
				echo -e "$BOLD${WHITE}\nAbort...$DEFAULT"
				exit 0
				;;
			esac
		fi
	done

	# Check for the last script version and install it before execution
	setup_check_version

	# Get the local running shell
	get_setup_shell

	# Install the script in user home directory
	mkdir -p $SETUP_BIN_DIR
	cp $SETUP_LINUX_SCRIPT $SETUP_BIN_ABSOLUTE_PATH
	
	# Check if the PATH exist or is not already defined into the rc file
	if ! grep "$SETUP_BIN_DIR" <(echo $PATH) &> /dev/null \
		|| ! grep "$PATH" $SETUP_SHELL_RC &> /dev/null; then
		echo -e "\n# SETUP new PATH" >> $SETUP_SHELL_RC
		echo -e 'export PATH=$PATH:'"$SETUP_BIN_DIR" >> $SETUP_SHELL_RC
	fi
	source $SETUP_SHELL_RC

	# Install all config files locally
	setup_aliases install
	# setup_editor install
	# setup_git install
	# setup_font install
	# setup_shell install
	# setup_terminal install
	setup_directories install
	echo -e "$BOLD${GREEN}\nProgram installed successfully.$DEFAULT"
	exit 0
}

#==============================================================================#
#  ╔═╗╦ ╦╦  ╦                                                                  #
#  ╠═╝║ ║║  ║                                                                  #
#  ╩  ╚═╝╩═╝╩═╝                                                                #
#==============================================================================#

setup_pull()
{
	local header_pull="\
	╔═╗╦ ╦╦  ╦  
	╠═╝║ ║║  ║  
	╩  ╚═╝╩═╝╩═╝"

	print_text "$BLUE" "$HEADER" delay
	print_text "$BOLD$WHITE" "$header_pull" delay

	# Check for the last script version and install it before execution
	setup_check_version

	# Get the local running shell
	get_setup_shell

	# Update all local config files and repo
	setup_aliases pull
	# setup_editor pull
	# setup_git pull
	# setup_font pull
	# setup_shell pull
	# setup_terminal pull
	setup_directories pull
	exit 0
}

#==============================================================================#
#  ╔═╗╦ ╦╔═╗╦ ╦                                                                #
#  ╠═╝║ ║╚═╗╠═╣                                                                #
#  ╩  ╚═╝╚═╝╩ ╩                                                                #
#==============================================================================#

setup_push()
{
	local header_push="\
	╔═╗╦ ╦╔═╗╦ ╦
	╠═╝║ ║╚═╗╠═╣
	╩  ╚═╝╚═╝╩ ╩"

	print_text "$BLUE" "$HEADER" delay
	print_text "$BOLD$WHITE" "$header_push" delay

	# Check for the last script version and install it before execution
	setup_check_version

	# # Get the local running shell
	get_setup_shell

	# Export all local config files and repo
	setup_aliases push
	setup_editor push
	# setup_git push
	# setup_font push
	# setup_shell push
	# setup_terminal push
	setup_directories push

	pushd $SETUP_DIR &> /dev/null
	git add . \
	&& git commit -m "Update files using setup --push" \
	&& git push origin
	popd $SETUP_DIR &> /dev/null
	exit 0
}

#==============================================================================#
#  DOTFILES                                                                    #
#==============================================================================#

setup_aliases()
{
	local setup_aliases="$SETUP_DIR/dotfiles/alias/alias.txt"
	local shell_aliases="$HOME/.${SETUP_SHELL}_aliases"

	echo -en "$BOLD$ITALIC${BLUE}ALIAS: ${DEFAULT}"
	if [ $1 = "install" ] || [ $1 = "pull" ]; then
		if [ ! -f "${shell_aliases}" ] \
			|| ! diff -q "${setup_aliases}" "${shell_aliases}" &> /dev/null;
		then
			cp "${setup_aliases}" "${shell_aliases}"
			if [ $? -ne 0 ]; then
				echo -e "$BOLD${RED}✖$DEFAULT"
				throw_error_and_exit "$git_output"
			fi
		fi
		# echo -e "${BOLD}${WHITE}${SETUP_SHELL}rc:${DEFAULT}"
		if ! grep -q "source ${shell_aliases}" "$SETUP_SHELL_RC" &> /dev/null;
		then
			echo "source ${shell_aliases}" >> "$SETUP_SHELL_RC"
		fi
	elif [ $1 = "push" ]; then
		if [ -f "${shell_aliases}" ] \
			&& diff -q "${setup_aliases}" "${shell_aliases}" &> /dev/null;
		then
			cp "${shell_aliases}" "${setup_aliases}"
			if [ $? -ne 0 ]; then
				echo -e "$BOLD${RED}✖$DEFAULT"
				throw_error_and_exit "$git_output"
			fi
		fi
	fi
	echo -e "$BOLD${GREEN}✔$DEFAULT"
}

setup_editor()
{
	local vimrc_local_file="$HOME/.vimrc"
	local vimrc_setup_file="$SETUP_DIR/dotfiles/editor/vim/vimrc"

	echo -e "$BOLD$ITALIC${BLUE}EDITOR: $DEFAULT"

	#### INSTALL | PULL ####
	if [ $1 = "install" ] || [ $1 = "pull" ]; then
		# Nvim
		echo -en "$BOLD${WHITE}  Nvim $DEFAULT"
		echo -e "$BOLD${RED}✖$DEFAULT"

		# Vim
		echo -en "$BOLD${WHITE}  Vim $DEFAULT"
		if [ ! -f "$HOME/.vimrc" ] \
			|| ! diff -q "$vimrc_setup_file" "$vimrc_local_file" &> /dev/null;
		then
			echo "$vimrc_setup_file" > "$vimrc_local_file"
		fi
		echo -e "$BOLD${GREEN}✔$DEFAULT"

		# Vscode
		echo -en "$BOLD${WHITE}  Vscode $DEFAULT"
		echo -e "$BOLD${RED}✖$DEFAULT"

	#### PUSH ####
	elif [ $1 = "push" ]; then
		# Nvim
		echo -en "$BOLD${WHITE}  Nvim $DEFAULT"
		echo -e "$BOLD${RED}✖$DEFAULT"

		# Vim
		echo -en "$BOLD${WHITE}  Vim $DEFAULT"
		if [ -f "$HOME/.vimrc" ] \
			&& diff -q "$vimrc_setup_file" "$vimrc_local_file" &> /dev/null;
		then
			echo "$vimrc_local_file" > "$vimrc_setup_file"
		fi
		echo -e "$BOLD${GREEN}✔$DEFAULT"

		# Vscode
		echo -en "$BOLD${WHITE}  Vscode $DEFAULT"
		echo -e "$BOLD${RED}✖$DEFAULT"
	fi
}

setup_font()
{
	local font_dir="$HOME/.local/share/fonts"
	local firaMono_dir="$font_dir/FiraMonoNerdFont"

	# Only FiraMonoNerdFont supported at the moment
	echo -e "$BOLD$ITALIC${BLUE}FONT: $DEFAULT"
	if [ $1 = "install" ] || [ $1 = "pull" ]; then
		mkdir -p "$font_dir"
		echo -en "$BOLD${WHITE}  FiraMono $DEFAULT"
		if [ ! -d "$firaMono_dir" ]; then
			pushd "$font_dir" &> /dev/null
			mkdir -p "$firaMono_dir"
			wget -q \
			https://github.com/\ryanoasis/nerd-fonts/releases/download/v3.3.0/FiraMono.zip
			unzip -q FiraMono.zip -d "$firaMono_dir"
			rm -rf *.zip
			fc-cache
			popd &> /dev/null
		fi
		echo -e "$BOLD${GREEN}✔$DEFAULT"
	fi
}

setup_git()
{
	local git_user_name
	local git_user_email
	local git_local_file="$HOME/.gitconfig"
	local git_setup_file="$SETUP_DIR/doftiles/git/gitconfig"

	echo -e "$BOLD$ITALIC${BLUE}GIT: ${DEFAULT}"
	git_user_name=$(grep name "$git_local_file" | awk '{print $3}')
	git_user_email=$(grep email "$git_local_file" | awk '{print $3}')

	#### INSTALL | PULL ####
	if [ $1 = "install" ] || [ $1 = "pull" ]; then
		if [ ! -f $git_local_file ] \
			|| ! grep "$git_user_name" "$HOME/.gitconfig" &> /dev/null \
			|| ! grep "$git_user_email" "$HOME/.gitconfig" &> /dev/null;
		then
			git config --global user.name "$git_user_name"
			git config --global user.email "$git_user_email"
			if [ $? -eq 0 ]; then
				echo -e "$BOLD${GREEN}✔$DEFAULT"
			else
				echo -e "$BOLD${RED}✖$DEFAULT"
			fi
		fi
	
	#### PUSH ####
	elif [ $1 = "push" ]; then
		if [ -f $git_local_file ]; then
			cp $git_local_file $git_setup_file
			if [ $? -eq 0 ]; then
				echo -e "$BOLD${GREEN}✔$DEFAULT"
			else
				echo -e "$BOLD${RED}✖$DEFAULT"
			fi
		else
			echo -e "$BOLD${RED}✖$DEFAULT"
		fi
	fi
}

setup_shell()
{
	$SETUP_SHELL_RC
}

setup_terminal()
{
	echo -e "$BOLD${BLUE}TERMINAL:$DEFAULT"

	# EMULATOR
	echo -e "Emulator"
	# Terminator
	if which terminator; then 
		local terminator_local_dir="$HOME/.config/terminator"
		local terminator_local_file="$terminator_local_dir/config"
		local terminator_setup_file="$SETUP_DIR/dotfiles/terminal/emulator/terminator/config"

		echo -en "$BOLD${WHITE}  Terminator: $DEFAULT"
		mkdir -p "$terminator_local_dir"
		if [ ! -f "$terminator_local_file" ] \
			|| ! diff -q "$terminator_setup_file" "$terminator_local_file";
		then
			echo "$terminator_setup_file" > "$terminator_local_file"
		fi
		echo -e "$BOLD${GREEN}✔$DEFAULT"
	else
		echo -e "$BOLD${RED}✖$DEFAULT"
	fi

	# MULTIPLEXER
	echo -e "Multiplexer"
	# Tmux
	if which tmux; then
		local tmux_local_dir="$HOME/.tmux"
		local tmux_local_config="$HOME/.tmux.conf"
		local tmux_setup_shellrc="$SETUP_DIR/terminal/multiplexer/shellrc.tmux"
		local tmux_setup_config"$SETUP_DIR/terminal/multiplexer/tmux/tmux.config"

		echo -e "${BOLD}${WHITE}Tmux:${DEFAULT}"
		if ! which tmux > /dev/null \
			|| ! grep -q "${tmux_setup_shellrc}" "${SETUP_SHELL_RC}";
		then
			echo >> "${SETUP_SHELL_RC}"
			echo "${tmux_setup_shellrc}" >> "${SETUP_SHELL_RC}"
			echo "Tmux updated."
		else 
			echo -e "Already up to date.\n"
		fi

		if [ ! -f "$tmux_local_config" ] \
			|| ! diff -q "$tmux_conf_file" "$tmux_local_config" > /dev/null;
		then
			echo "$tmux_conf_file" > "$tmux_local_config"
		fi
		echo -e "$BOLD${GREEN}✔$DEFAULT"
	else
		echo -e "$BOLD${RED}✖$DEFAULT"
	fi

	# PROMPT
	echo -e "Prompt:"
	# Startship
	if which starship; then
		local starship_bash='eval "$(starship init bash)"'
		local starship_zsh='eval "$(starship init zsh)"'
		local starship_fish='starship init fish | source'

		case $SETUP_SHELL in 
			"bash")
				if ! grep -q "$starship_bash" $SETUP_SHELL_RC; then
					echo 'eval "$(starship init bash)"' >> $SETUP_SHELL_RC
				fi
			;;
			"fish")
				if ! grep -q "$starship_fish" $SETUP_SHELL_RC; then
					echo 'starship init fish | source' \
					>> "$HOME/.config/fish/config.fish"
				fi
			;;
			"powershell")
				echo 'Invoke-Expression (&starship init powershell)' \
				>> $PROFILE
			;;
			"zsh")
				if ! grep -q "$starship_zsh" $SETUP_SHELL_RC; then 
					echo 'eval "$(starship init zsh)"' >> $SETUP_SHELL_RC
				fi
			;;
		esac
			echo -e "$BOLD${GREEN}✔$DEFAULT"
	else
		# if ! which starship > /dev/null; then
		# 	curl -fsSL https://starship.rs/install.sh | sh -s -- -b ~/.local/bin
		# fi
		echo -e "$BOLD${RED}✖$DEFAULT"
	fi
}

setup_directories()
{
	local dir_setup_file="$SETUP_DIR/dotfiles/directory/dir.conf"
	local error_value

	echo -e "$BOLD$ITALIC${BLUE}DIRECTORY: $DEFAULT"
	while IFS=" " read -r dir_path dir_remote_repo; do
		dir_path=$(eval echo "$dir_path")
		echo -n "  ${dir_path}: "
		case $1 in
			"install")
				if [ ! -d $dir_path ]; then
					mkdir -p $dir_path
					rmdir $dir_path
				fi
				error_value=$(git clone $dir_remote_repo $dir_path 2>&1)
				if [ $? -ne 0 ]; then 
					echo -e "$BOLD${RED}✖$DEFAULT"
					echo -e "\t$error_value"
				else
					echo -e "$BOLD${GREEN}✔$DEFAULT"
				fi
			;;
			"pull")
				pushd $dir_path &>/dev/null
				error_value=$(git pull 2>&1)
				if [ $? -ne 0 ]; then 
					echo -e "$BOLD${RED}✖$DEFAULT"
					echo -e "\t$error_value"
				else
					echo -e "$BOLD${GREEN}✔$DEFAULT"
				fi
				popd &> /dev/null
			;;
			"push")
				pushd $dir_path &> /dev/null
				error_value=$(git add . && git commit -m "Update files" && git push origin 2>&1)
				if [ $? -ne 0 ]; then 
					echo -e "$BOLD${RED}✖$DEFAULT"
					echo -e "\t$error_value"
				else
					echo -e "$BOLD${GREEN}✔$DEFAULT"
				fi
				popd &> /dev/null
			;;
		esac
	done < $dir_setup_file

}

#==============================================================================#
#  UTILS                                                                       #
#==============================================================================#

signal_handler()
{
	echo -e "$BOLD${RED}\n\nSCRIPT INTERRUPTED$DEFAULT"
	echo -e "$BOLD${WHITE}Abort...$DEFAULT"
	exit 1
}

setup_check_version()
{
	local git_output

	echo -en "$BOLD$ITALIC${BLUE}SCRIPT VERSION: $DEFAULT"
	git_output=$(git pull 2>&1)
	if [ $? -eq 0 ] ; then
		echo -e "$BOLD${GREEN}✔$DEFAULT"
	else
		echo -e "$BOLD${RED}✖$DEFAULT"
		throw_error_and_exit "$git_output"
	fi
}

get_setup_shell()
{
	local shells=("bash" "zsh" "fish" "powershell")

	# Get the actual running shell with its config files
	for shell in "${shells[@]}"; do
		if grep -q "$shell" <(echo "$SHELL"); then
			SETUP_SHELL="${shell}"
			SETUP_SHELL_RC="$HOME/.${SETUP_SHELL}rc"
			shell_aliases="$HOME/.${SETUP_SHELL}_aliases"
			break
		fi
	done

	if [ -z "$SETUP_SHELL" ]; then
		throw_error_and_exit "Can't find any shell to use."
	fi
}

print_usage()
{
	echo -en "$BOLD${WHITE}Usage: $DEFAULT"
	echo -e "setup [options] [arg]\n"
	echo -e "$BOLD${WHITE}Options:$DEFAULT"
	echo -e "  --help\t\t Print this message"
	echo -e "  --install\t\t Install setup and its environment locally"
	echo -e "  --pull\t\t Update all existing files"
	echo -e "  --push\t\t Send all current modification to the remote repo"
	# echo -e "  --set-dir\t\t Add the current working directory to the dir.conf file"
	# echo -e "  --unset-dir <name>\t Remove the current working directory of the dir.conf file"
	# echo -e "  --set-font\t\t Add the font to the font.conf file"
	# echo -e "  --unset-font <name>\t Remove the font from the font.conf file"
	exit 0
}

print_text()
{
	local color=$1
	local text=$2
	local mode=$3

	tput civis
	echo -en "$color"
	if [ $mode ] && [ $mode = "delay" ]; then
    	for ((i=0; i<${#text}; i++)); do
        	echo -en "${text:$i:1}"
        	sleep 0.025
    	done
	else
		echo -en "$text"
	fi 
	echo -en "$DEFAULT"
	echo
	tput cnorm
}

throw_error_and_exit()
{
	echo -e "$BOLD${RED}\nERROR$DEFAULT"
	echo -e "$1"
	echo -e "$BOLD${WHITE}Abort...$DEFAULT"
	exit 1
}

main "$@"