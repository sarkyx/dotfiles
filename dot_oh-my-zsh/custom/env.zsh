# environment
for f in ~/.env/*; do source "$f" &>/dev/null; done

# path
export PATH="$PATH:$HOME/.sh:$HOME/.cargo/bin"
