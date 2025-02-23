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

$global:HEADER=@"
╔═╗╔═╗╔╦╗╦ ╦╔═╗
╚═╗║╣  ║ ║ ║╠═╝
╚═╝╚═╝ ╩ ╚═╝╩  
"@

# Global variables
$global:SETUP_SCRIPT="setup"
$global:SETUP_SCRIPT_DIR="$HOME/.local/bin"

$global:SETUP_OS
$global:SETUP_SHELL
$global:SETUP_SHELL_RC
$global:SETUP_DIR="$HOME/.setup"
$global:SETUP_DIR_WINDOWS="$SETUP_DIR/platform/windows"

function main()
{
	if (!$args -or $args[0] -eq "help") {
    	print_usage
	} elseif ($args[0] -eq "install") {
		setup_install
	} elseif ($args[0] -eq "pull") {
		setup_pull
	} elseif ($args[0] -eq "push") {
		setup_push
	}
	exit $LASTEXITCODE
}

#============================================================================= #
#  ╦╔╗╔╔═╗╔╦╗╔═╗╦  ╦                                                           #
#  ║║║║╚═╗ ║ ╠═╣║  ║                                                           #
#  ╩╝╚╝╚═╝ ╩ ╩ ╩╩═╝╩═╝                                                         #
#============================================================================= #

function setup_install()
{
	$local:header_install="
	╦╔╗╔╔═╗╔╦╗╔═╗╦  ╦  
	║║║║╚═╗ ║ ╠═╣║  ║  
	╩╝╚╝╚═╝ ╩ ╩ ╩╩═╝╩═╝"

	print_text "Blue" $HEADER "delay"
	print_text "White" $header_install "delay"
	exit 0
}

#==============================================================================#
#  ╔═╗╦ ╦╦  ╦                                                                  #
#  ╠═╝║ ║║  ║                                                                  #
#  ╩  ╚═╝╩═╝╩═╝                                                                #
#==============================================================================#

function setup_pull()
{
	$local:header_pull="
	╔═╗╦ ╦╦  ╦  
	╠═╝║ ║║  ║  
	╩  ╚═╝╩═╝╩═╝"

	print_text "Blue" $HEADER "delay"
	print_text "White" $header_pull "delay"

	# Update all local config files and repo
	setup_aliases "pull"
	setup_editor "pull"
	setup_git "pull"
	setup_font "pull"
	setup_shell "pull"
	setup_terminal "pull"
	setup_dev_directory "pull"
	exit 0
}

#==============================================================================#
#  ╔═╗╦ ╦╔═╗╦ ╦                                                                #
#  ╠═╝║ ║╚═╗╠═╣                                                                #
#  ╩  ╚═╝╚═╝╩ ╩                                                                #
#==============================================================================#

function setup_push()
{
	$local:header_push="
	╔═╗╦ ╦╔═╗╦ ╦
	╠═╝║ ║╚═╗╠═╣
	╩  ╚═╝╚═╝╩ ╩"

	print_text "Blue" $HEADER "delay"
	print_text "White" $header_push "delay"

	# Export all local config files and repo
	setup_aliases "push"
	setup_editor "push"
	setup_git "push"
	setup_font "push"
	setup_shell "push"
	setup_terminal "push"
	setup_dev_directory "push"

	Push-Location $SETUP_DIR &> /dev/null
	git add .;`
	git commit -m "Update files using setup --push";`
	git push origin
	Pop-Location $SETUP_DIR &> /dev/null
	exit 0
}

#==============================================================================#
#  DOTFILES                                                                    #
#==============================================================================#

#==============================================================================#
#  UTILS                                                                       #
#==============================================================================#

function print_usage()
{
	Write-Host "Usage: " -NoNewline -ForegroundColor White
	Write-Host "setup [options]`n"
	Write-Host "Options:" -ForegroundColor White
	Write-Host "  --help`t Print this message"
	Write-Host "  --install`t When first time to use after download"
	Write-Host "  --pull`t Update all existing files"
	Write-Host "  --push`t Send all current modification to the github repo"
	exit 0
}

function print_text()
{
	$local:color=$args[0]
	$local:text=$args[1]
	$local:mode=$args[2]

	[System.Console]::CursorVisible = $false
	if ($mode -and $mode -eq "delay") {
		for ($i = 0; $i -lt $text.Length; $i++) {
			Write-Host -NoNewline -ForegroundColor $color $text[$i]
			Start-Sleep -Milliseconds 25
		}
	} else {
		Write-Host -NoNewline -ForegroundColor $color $text
	}
	[System.Console]::CursorVisible = $true
}

main $args