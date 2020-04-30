#!/bin/sh

export MODE=$PLUGIN_MODE

if [ -z $PLUGIN_GIT_METHOD ]; then
  echo "Variable git_method must be set in settings."
  exit 1
fi

export GIT_AUTHOR_NAME=$PLUGIN_GIT_USER_NAME
export GIT_AUTHOR_EMAIL=$PLUGIN_GIT_USER_EMAIL
export GIT_COMMITTER_NAME=$PLUGIN_GIT_USER_NAME
export GIT_COMMITTER_EMAIL=$PLUGIN_GIT_USER_EMAIL
export NPM_TOKEN=$PLUGIN_NPM_TOKEN

if [ "$PLUGIN_GIT_METHOD" == "gh" ]; then
  export GH_TOKEN=$PLUGIN_GITHUB_TOKEN
elif [ "$PLUGIN_GIT_METHOD" == "gl" ]; then
  export GL_TOKEN=$PLUGIN_GITLAB_TOKEN
elif [ "$PLUGIN_GIT_METHOD" == "bb" ]; then
  export BB_TOKEN=$PLUGIN_BITBUCKET_TOKEN
elif [ "$PLUGIN_GIT_METHOD" == "cr" ]; then
  export GIT_CREDENTIALS=$(node /semantic-release/create-credentials.js)
else
  echo "Variable git_method must be one of the following: gh (Github), gl (GitLab), bb (BitBucket), cr (Credentials)"
  exit 1
fi

if [ -z "$PLUGIN_GIT_USER_NAME" ]; then
  echo "GIT Username not defined! Please set git_user_name in Drone plugin settings."
  exit 127
elif [ -z "$PLUGIN_GIT_USER_EMAIL" ]; then
  echo "GIT E-Mail not defined! Please set git_user_email in Drone plugin settings."
  exit 127
fi

# Set git variables
git config --global user.name "$GIT_COMMITTER_NAME"
git config --global user.email "$GIT_COMMITTER_EMAIL"

if [ ! -f .releaserc ] || [ "$PLUGIN_USE_LOCAL_RC" = "true" ]; then
  echo ".releaserc not found using defaults"
  cp /semantic-release/.releaserc.json .releaserc
fi

if [ "$MODE" = "predict" ]; then
  echo 'Running semantic release in dry mode...'
  semantic-release -d || exit 1
else
  semantic-release $PLUGIN_ARGUMENTS || exit 1
fi

rm .releaserc
