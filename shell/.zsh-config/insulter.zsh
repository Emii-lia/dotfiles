command_not_found_handler () {
    local INSULTS=(
        "Don't you know anything?"
	"Brain not found"
        "Hahaha, n00b!"
        "Wow! That was impressively wrong!"
        "What are you doing??"
        "Pathetic"
        "The worst one today!"
        "n00b alert!"
        "Your application for reduced salary has been sent!"
        "lol"
        "u suk"
        "plz uninstall"
        "There is an U in STUPID"
        "ERROR_INCOMPETENT_USER"
        "Incompetence is also competence"
        "What is this...? Amateur hour!?"
        "Nice try."
        "It's all Microsoft's fault"
        "Zura janai, baka da!"
        "What if... you type an actual command the next time!"
        "What if I told you... it is possible to type valid commands."
        "Y u no speak computer???"
        "This is not Windows"
        "Perhaps you should leave the command line alone..."
        "Please step away from the keyboard!"
        "error code: 1D10T"
        "Pro tip: type a valid command!"
        "Go outside."
        "This is not a search engine."
        "So, I'm just going to go ahead and run rm -rf / for you."
        "Why are you so stupid?!"
        "Perhaps computers is not for you..."
        "Why are you doing this to me?!"
        "Don't you have anything better to do?!"
        "I am _seriously_ considering 'rm -rf /'-ing myself..."
        "This is why nobody likes you."
        "Are you even trying?!"
    )

    # Seed "random" generator
    #RANDOM=$(date +%s%N)
    #VALUE=$((${RANDOM}%2))

    #if [[ ${VALUE} -lt 1 ]]; then
    cowsay -f $HOME/.cowsay/cowfiles/zani.cow "$(tput bold)$(tput setaf 1)$(shuf -n 1 -e "${INSULTS[@]}")$(tput sgr0)"
    #fi
    #no need to echo cmd not found, as zsh will do it by self already.
    #echo "SuperZSH: $1: command not found"
    echo ""

    # Return the exit code normally returned on invalid command
    return 127
}
