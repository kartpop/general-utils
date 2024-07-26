
# This is not a bash script, but a snippet to be included in the bashrc file.
# It provides functions to set the prompt prefix.

# Get the last N directory levels of the current path
short_pwd() {
    local max_depth=$1
    local pwd_part="$(pwd)"

    # Split the path into an array
    IFS='/' read -r -a parts <<< "$pwd_part"

    # Calculate the starting index for the last N parts
    local start_index=$(( ${#parts[@]} > max_depth ? ${#parts[@]} - max_depth : 0 ))

    # Build the short path with ellipsis
    local short_path=""
    if [ $start_index -gt 0 ]; then
        short_path=".../"
    fi
    short_path="${short_path}$(IFS='/'; echo "${parts[*]:$start_index}")"

    echo "$short_path"
}

# Set terminal prompt with configurable directory levels (default to 2)
# eg. directory is /home/user/projects/myproject
# terpro 1 --> .../myproject$
# terpro 2 --> .../projects/myproject$
terpro() {
    local levels=${1:-2} # Default to 2 levels if not specified

    export PS1=" \[\033[1;32m\]\$(short_pwd $levels)\[\033[0m\]\$ \[\033[0m\]"
}

# Set terminal prompt with configurable directory levels with python environment
# eg. directory is /home/user/projects/myproject and the python environment is 'pyenv'
# terproenv 1 --> (pyenv) .../myproject$
# terproenv 2 --> (pyenv) .../projects/myproject$
terproenv() {
    local levels=${1:-2} # Default to 2 levels if not specified

    export PS1="\$(conda shell.bash hook &> /dev/null && echo -e \"\$CONDA_PROMPT_MODIFIER\")\[\033[1;32m\]\$(short_pwd $levels)\[\033[0m\]\$ \[\033[0m\]"
}


# Set default terminal prompt
# terprodef --> (pyenv) user@host:~/path$
terprodef() {
    export PS1="\$(conda shell.bash hook &> /dev/null && echo -e \"\$CONDA_PROMPT_MODIFIER\")\[\033[1;32m\]\u@\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[0m\]\$ \[\033[0m\]"
}
