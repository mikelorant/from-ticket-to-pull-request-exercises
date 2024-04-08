#!/usr/bin/env bash

if [[ ! -f $HOME/.gitconfig ]]; then
    name=$(gum input --placeholder="" --header="What is your name?")
    email=$(gum input --placeholder="" --header="What is your email?")

    git config --global user.name "${name}"
    git config --global user.email "${email}"
    git config --global alias.oops "commit --amend --no-edit"
    git config --global alias.push-patch "format-patch main --no-binary"
    git config --global credential.helper store
    git config --global push.autoSetupRemote true
fi

if [[ ! -f $HOME/.profile ]]; then
    editor=$(gum choose --header "Which editor do you want to use?" nano vim)

    cat <<-EOF >"$HOME/.profile"
export EDITOR=${editor}
export PATH="/go/bin:/usr/local/go/bin:\$PATH"

source /usr/share/bash-completion/completions/git
EOF
fi

if [[ ! -f $HOME/.git-credentials ]]; then
    cat <<-EOF >"$HOME/.git-credentials"
https://${USERNAME}:${PASSWORD}@${REPOSITORY}
EOF
fi

name=$(git config --get user.name | tr '[:upper:] ' '[:lower:]-')
branch=$(git branch --show-current)

git branch --move "${name}/${branch}"
git remote set-url origin "https://${REPOSITORY}/${USERNAME}/markdown-viewer.git"

exec /usr/bin/env bash --login
