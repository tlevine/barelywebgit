BarelyWebGit
===========

BarelyWebGit statically generates a barely-web-site that inside of a
[NearlyFreeSpeech.net](http://nearlyfreespeech.net) (NFSN) site. Well you
could host the site somewhere else, but the default configuration uses
NFSN's directory structure, and you'd probably be able
to use something fancier if you were hosting somewhere.

## How to

```#sh

git clone git@github.com:tlevine/barelywebgit.git
cd barelywebgit
```

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
