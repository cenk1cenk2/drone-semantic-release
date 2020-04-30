# semantic-release-drone

Drone plugin for making semantic releases based on https://github.com/semantic-release/semantic-release.

## Usage

See [commit message format](https://github.com/semantic-release/semantic-release#commit-message-format) to use it.

Add the following to the drone configuration

```yml
kind: pipeline
name: default

steps:
- name: semantic-release
  image: cenk1cenk2/semantic-release
  settings:
    mode: release # "release" means the actual release and "predict" means to generate the version in dry run to use it e.g. before build
    git_method: gh # set for git authentication with gh (Github), gl (GitLab), bb (BitBucket), cr (Credentials)
    use_local_rc: false # use defaults or a custom rc file true | false
    # arguments: -- # arguments for passing to the semantic-release
    version_file: .tags # the file where the version will be persisted, defaults to .release-version
    git_user_name: bot # semantic release committer name (git config user.name)
    git_user_email: bot@example.com # semantic release committer email (git config user.email)
    github_token: # semantic release token (for authentication)
      from_secret: github_token
    npm_token: # semantic release token (for authentication)
      from_secret: npm_token
```

or for BitBucket

```yml
    bitbucket_token: # semantic release token (for authentication)
      from_secret: token
```

or for GitLab

```yml
    gitlab_token: # semantic release token (for authentication)
      from_secret: token
```

or for any git server (including BitBucket cloud which does not support tokens):

```yml
    git_login: bot
    git_password:
      from_secret: password
```

## What it does

Runs on master branch only. Skips any actions below while on other branches.

- automatically creates a semantic version number
- attaches the version number as repo's git tag
- exposes the version number into the file `.release-version`
- automatically creates, populates and pushes CHANGELOG.md to your master branch

If `mode: predict` is specified, only the `.release-version` file is generated; no tag is attached. Typical use-case is when you want to embed the version into your file for the cli `--version` command

## License

MIT
