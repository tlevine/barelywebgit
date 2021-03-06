#!/bin/sh

# --------------------------------------------------------------------------- #
# Begin settings
# --------------------------------------------------------------------------- #

# SSH
SSH_ACCOUNT=tlevine_thomaslevine-git@ssh.phx.nearlyfreespeech.net

# HTTP authentication
# Define these to make the web display private.
# USERNAME=git
# PASSWORD=chainsaws

# Filesystem, with trailing slashes
REPOSITORIES_DIR=/home/private/
PUBLIC_HTML_DIR=/home/public/

AUTHNAME="Private BarelyWebGit Index"
HTPASSWD_FILE=/home/protected/.htpasswd

BARELYWEBGIT_REPOSITORY=/home/private/barelywebgit/
TMP=/tmp

# --------------------------------------------------------------------------- #
# End settings
# --------------------------------------------------------------------------- #

set -e
cd $BARELYWEBGIT_REPOSITORY

repositories="`find $REPOSITORIES_DIR -name *.git`"

render_index() {
  # Make rows.
  echo > $TMP/_repository_rows.html
  for repository_full in ${repositories}
    do
    repository_partial="`echo $repository_full|sed s=^${REPOSITORIES_DIR}==`"
    repository_tagged="<span class|\"path-component\">`
      echo $repository_partial |
      sed s=^${REPOSITORIES_DIR}== |
      sed 's=/=</span> <span class|\"slash">/</span> <span class|\"path-component\">=g'
    `</span>"
    sed -e "s={{repository_partial}}=${repository_partial}=g" \
      -e "s={{repository_tagged}}=${repository_tagged}=g" \
      -e "s/{{SSH_ACCOUNT}}/${SSH_ACCOUNT}/g" \
      web/_repository_row.html |
      tr '|' '=' >> "${TMP}"/_repository_rows.html
  done

  # Add to the template.
  sed "/Rows are added below from a partial/r ${TMP}/_repository_rows.html" \
    web/index.html > $TMP/public_html/index.html
  rm $TMP/_repository_rows.html
}

render_htpasswd() {
  if [ "$USERNAME" != '' ] && [ "$PASSWORD" != '' ]
    then
    rm -f "$HTPASSWD_FILE"
    htpasswd -cb "$HTPASSWD_FILE" "$USERNAME" "$PASSWORD"
  fi
}

render_htaccess() {
  if [ "$USERNAME" != '' ] && [ "$PASSWORD" != '' ]
    then
    echo "AuthType Basic
AuthName \"$AUTHNAME\"
AuthUserFile $HTPASSWD_FILE
AuthGroupFile /dev/null
Require user $USERNAME" > \
    $TMP/public_html/.htaccess
  fi
}

# Compilation directory
rm -Rf $TMP/public_html
cp -R web $TMP/public_html

# Dynamic stuff
render_index
render_htpasswd
render_htaccess

# Publish
rm -Rf $PUBLIC_HTML_DIR/.h* $PUBLIC_HTML_DIR/*
cp -R $TMP/public_html/* $PUBLIC_HTML_DIR
if [ "$USERNAME" != '' ] && [ "$PASSWORD" != '' ]
  then
  cp -R $TMP/public_html/.h* $PUBLIC_HTML_DIR
fi

# Clean up
rm -Rf $TMP/public_html
