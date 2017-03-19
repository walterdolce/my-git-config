#!/usr/bin/env bash

function configure_email_address()
{
    local email_address="${1}"

    if [[ $(should_configure_email_address ${email_address}) == 1  ]]; then
        read -p "Please configure your email address for Git (global config): " email_address
        email_address=$(configure_email_address ${email_address})
    fi

    echo ${email_address}
}

function configure_gpg_signing_key()
{
    local gpg_signing_key="${1}"

    if [[ $(should_configure_signing_key ${gpg_signing_key}) == 1  ]]; then
        read -p "Please configure your GPG signing key for Git (global config): " gpg_signing_key
        gpg_signing_key=$(configure_gpg_signing_key ${gpg_signing_key})
    fi

    echo ${gpg_signing_key}
}

function should_configure_email_address()
{
    local current_git_email_address="${1}"
    if [[ "${current_git_email_address}" != "" && "${current_git_email_address}" != "!undefined!" ]]; then
        echo 0
    else
        echo 1
    fi
}

function should_configure_signing_key()
{
    local current_git_signing_key="${1}"
    if [[ "${current_git_signing_key}" != "" && "${current_git_signing_key}" != "!undefined!" ]]; then
        echo 0
    else
        echo 1
    fi
}

echo "Verifying email address configured in Git (global config)..."
current_git_email_address=$(git config --global --get user.email)
email_address=""
if [[ $(should_configure_email_address ${current_git_email_address}) == 1 ]]; then
    echo "Email address needs configured as it seems to be either empty or !undefined!..."
    email_address=$(configure_email_address ${current_git_email_address})
    echo "Email address to be configured is: ${email_address}."
    echo "Adding ${email_address} to Git (global confing)..."
else
    echo "Email address looks to be already configured to ${current_git_email_address}. Skipping configuration."
    email_address=${current_git_email_address}
fi

echo "Verifying GPG signing key configured in Git (global config)..."
current_signing_key=$(git config --global --get user.signingkey)
signing_key=""
if [[ $(should_configure_signing_key ${current_signing_key}) ]]; then
    echo "GPG signing key needs configured as it seems to be either empty or !undefined!..."
    signing_key=$(configure_gpg_signing_key ${current_signing_key})
    echo "GPG signing key to be configured is: ${current_signing_key}."
    echo "Adding ${current_signing_key} to Git (global confing)..."
else
    echo "GPG signing key looks to be already configured to ${current_signing_key}. Skipping configuration."
    signing_key=${current_signing_key}
fi

echo "Copying .gitconfig to ${HOME}/.gitconfig..."
cp ./.gitconfig ~/.gitconfig

git config --global --unset-all user.email
git config --global --add user.email ${email_address}

git config --global --unset-all user.signingkey
git config --global --add user.signingkey ${signing_key}

