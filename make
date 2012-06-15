#!/bin/sh

# --------------------------------------------------------------------------- #
# Begin settings
# --------------------------------------------------------------------------- #

# SSH
SSH_ACCOUNT=accountname_sitename@ssh.phx.nearlyfreespeech.net

# HTTP authentication
# Define these to make the web display private.
# USERNAME=tlevine
# PASSWORD=chainsaws

# Filesystem, with trailing slashes
REPOSITORIES_DIR=/home/private/
PUBLIC_HTML_DIR=/home/public/
HTPASSWD_FILE=/home/protected/.htpasswd
BARELYWEBGIT_REPOSITORY=/home/private/barelywebgit/
TMP=/tmp

# --------------------------------------------------------------------------- #
# End settings
# --------------------------------------------------------------------------- #

set -e
cd $BARELYWEBGIT_REPOSITORY

repositories="`find $REPOSITORIES_DIR -name *.git`"

index() {
  # Make rows.
  echo > $TMP/_repository_rows.html
  for repository_full in ${repositories}
    do
    repository_partial="`echo $repository_full|sed s=^${REPOSITORIES_DIR}==`"
    repository_tagged="<span class\&\"path-component\">`
      echo $repository_partial |
      sed s=^${REPOSITORIES_DIR}== |
      sed 's=/=</span><span class&\"path-component\">=g'
    `</span>"
    sed -e "s={{repository_partial}}=${repository_partial}=g" \
      -e "s={{repository_tagged}}=${repository_tagged}=g" \
      -e "s/{{SSH_ACCOUNT}}/${SSH_ACCOUNT}/g" \
      web/_repository_row.html |
      tr '&' '=' >> "${TMP}"/_repository_rows.html
  done

  # Add to the template.
  sed "/id=\"repositories\"/r ${TMP}/_repository_rows.html" \
    web/index.html > $TMP/public_html/index.html
  rm $TMP/_repository_rows.html
}

htpasswd() {

}

# Compilation directory
rm -Rf $TMP/public_html
cp -R web $TMP/public_html

# Dynamic stuff
index
# htpasswd

# Publish
rm -Rf $PUBLIC_HTML_DIR/*
cp -R $TMP/public_html/* $PUBLIC_HTML_DIR
