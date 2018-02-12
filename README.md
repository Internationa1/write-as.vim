# Write-As.Vim

*Author: [international](https://cybre.space/international)  [&#128231;](mailto:international@airmail.cc) <a class="bmc-button" target="_blank" href="https://www.buymeacoffee.com/intrntnl"><img src="https://www.buymeacoffee.com/assets/img/BMC-btn-logo.svg" alt=""><span style="margin-left:5px">Buy me a coffee</span></a>*



This is a simple plugin for vim that allows one to upload blogposts to [write.as](https://write.as/) from the VIM Buffer.

# Installation

The easiest way to install this plugin is, obviously, by a package manager like [Pathogen](https://github.com/tpope/vim-pathogen) or [Vundle](https://github.com/VundleVim/Vundle.vim).

```Vundle
Plugin 'internationa1/write-as.vim'
```

Then, add this somewhere into your *.vimrc*:

```VimScript
" Writeas Blog Info
let g:writeas_b = 'YOUR BLOG'
```

Now open vim and run `:WriteAsAuth`

```VimScript
:WriteAsAuth
Username: janedoe
Password: *******
Success. Add to .vimrc:
let g:writeas_t = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
```

And add that line to your *.vimrc*:

```VimScript
" Writeas Blog Info
let g:writeas_b = 'YOUR BLOG'
let g:writeas_t = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
```

**Optionally** you can supply your username and password, instead.

```VimScript
" Writeas User Info
let g:writeas_u = 'YOUR_USERNAME'
let g:writeas_p = 'YOUR_PASSWORD'
let g:writeas_b = 'YOUR BLOG'
```

# Usage

Make sure you're in the buffer that you intend to upload as a blog post.

## Anonymous Posting

```VimScript
:AnonPost POST TITLE
Authenticated.
Post Uploaded.
```

It will then dump some information into the file, for later use:

```Vimscript
write.as/*url*
posted: 2018-01-27 T 03:31:58 Z
```

## Blog Posting

```VimScript
:BlogPost POST TITLE
Authenticated.
Blog Updated.
```

It will then dump some information in the file:

```VimScript
write.as/blog/post_title
posted: 2018-01-27 T 03:33:29 Z
```

Couldn't be simpler.

# Notes & The Future

You must have an account at write.as for this plugin to work. Experimentation with accountless access
was tried, but I found that tracking tokens and slugs was a bit too much trouble then its worth, and
didn't want to be the one at fault for clogging up write.as with uneditable posts.

### Some things in the pipeline:

1. Retrieving and editing posts
2. Crossposting



