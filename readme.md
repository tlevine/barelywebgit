BarelyWebGit
===========

BarelyWebGit statically generates a barely-web-site that inside of a
[NearlyFreeSpeech.net](http://nearlyfreespeech.net) (NFSN) site. Well you
could host the site somewhere else, but the default configuration uses
NFSN's directory structure, and you'd probably be able
to use something fancier if you were hosting somewhere.

## How to

First, set up the public version.

```#sh
# Download
git clone git@github.com:tlevine/barelywebgit.git
cd barelywebgit

# Install dependencies
./barelywebgit deps

# Create a bare repository on the server.
accountname_sitename=tom_thomaslevine-git # <-- Change this for your site.
git remote add nfsn $accountname_sitename@ssh.phx.nearlyfreespeech.net:barelywebgit.git
ssh $accountname_sitename@ssh.phx.nearlyfreespeech.net:barelywebgit.git 'git init --bare barelywebgit.git'

# Switch to the deploy branch
git checkout deploy
git push -u origin deploy
```

Edit your configuration inside of deploy. If you want to change BarelyWebGit,
make a branch from master so that it's easy to contribute upstream; master is
set up to ignore the configuration files.

Now we can configure a password.

```#sh
echo Dunno how this will work yet
```

Or not. Then we push our private repositories to `/home/private`, which is
also `$HOME`.

```#sh
cd some/other/repository_name
./barelywebgit init origin $accountname_sitename@ssh.phx.nearlyfreespeech.net
git push -u origin master
```

### More how-to

In case you're curious, `barelywebgit init` just runs this

```#sh
repository_name="`basename \`pwd\``"
git remote add origin "$accountname_sitename@ssh.phx.nearlyfreespeech.net:$repository_name.git"
ssh "$accountname_sitename@ssh.phx.nearlyfreespeech.net:barelywebgit.git git init --bare $repository_name.git"
```

If you want to change the directory structure, probably because you're not
using NFSN, edit `settings`.

```#sh
$EDITOR settings
```

If you want to use public key authentication on NFSN, read
[this](https://members.nearlyfreespeech.net/support/faq?q=SSHKeys#SSHKeys).

## Architecture
BarelyWebGit uses a 

## Privacy

### Repositories

The git repositories themselves are stored wherever you want, so
if you don't want people to be able to download them, just put them
anywhere that the web server won't serve them. So in NFSN, they can
go in `/home/private`.

### Titles

The titles are displayed in the index of web-served directory, so
`/home/private/index.html` if you use the default configuration.
You can use basic HTTP auth by editing the `.htpasswd` and
`.htaccess`. This is not secure on NFSN because NFSN doesn't support
SSL, but that's not a big deal as long as your repositories' titles
don't contain private information.

## Potential enhancements

### Serving both public and private

With some small changes, BarelyWebGit could be made to present both
public and private information in the same site. It might work like this.

* `/home/private/private` contains private repositories
* `/home/private/public` contains public repositories
* `/home/public/private/index.html` says the names of private repositories
* `/home/public/public/index.html` says the names of public repositories
* `/home/public/index.html` explains the permissions levels and links to
     `/public` and `/private`

## Alternatives
If you want a static git site generator and BarelyWebGit is too bare,
you might try [git2html](http://hssl.cs.jhu.edu/~neal/git2html/).

If you want something fancy and dynamic, check out the
[list of web interfaces](https://git.wiki.kernel.org/index.php/Interfaces,_frontends,_and_tools#Web_Interfaces)
on the kernel.org wiki. Most of them are pretty easy to install,
just not on NearlyFreeSpeech.
