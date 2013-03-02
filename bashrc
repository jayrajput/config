# If not running interactively, don't do anything more
case "$-" in
*i*) echo "" ;;
*)   return ;;
esac

function addToPath () 
{
   add_me=$1
   # in bash v3, we could say this -> if [[ ! ":$PATH:" =~ ":$d:" ]] ; then
   if [ $(echo ":$PATH:" | grep -c ":$add_me:") -eq 0 ] ; then
      PATH="$PATH:$add_me"
   fi
}
function addToPythonpath()
{
   add_me=$1
   if [ $(echo ":$PYTHONPATH:" | grep -c ":$add_me:") -eq 0 ] ; then
      export PYTHONPATH=$PYTHONPATH:$add_me
   fi
}

# Putty Window Title Functions
# In all of these, ^[ is really the "escape" character. You put it into
# a file using vi, by typing control-V and then hitting the Escape key.
# Likewise, ^G is the control-G character.  Again, hit control-V then
# hit control-G Change Putty window Title
wt ()
{
    echo -n "]2;${@}"  
}
it ()
{
    echo -n "]0;${@}"
}
defwt ()
{
    echo -n "]2;$(whoami) @ $(hostname)"
}
cls ()
{
    # works only for vt100's and the like
    echo "[;H[2J"
}

# show the last dir in the pwd inside square brackets followed by dollar sign.
# \W = last dir in the pwd.
export PS1="[\W]\$"

set dunique      # Remove duplicate entries in directory stack

# set fignore=(\~) # files ending in ~ will be ignored by completion
# Automatically correct spelling mistake in the cd command.
# see http://linux.101hacks.com/cd-command/shopt-s-cdspell/
shopt -s cdspell

# source any system specific script
bashDir=~/.bash
if [ -e $bashDir ]; then
    for file in $(ls $bashDir); do
        source $bashDir/$file
    done
fi

export pySearchSelect=~/bin/pySearchSelect.py
