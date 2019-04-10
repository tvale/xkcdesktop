# xkcdesktop
[![Build Status](https://travis-ci.com/tvale/xkcdesktop.svg?branch=master)](https://travis-ci.com/tvale/xkcdesktop)

> _xkcd in the comfort of my desktop? Yes please._―Me

View xkcd comics on your desktop.
Features:
* View comic in its original size or fitted to the window.
* Go to the previous, next, or latest, comic.
* Use the search bar to jump to a specific comic.
* Pick up from the comic you left off.

![Screenshot](https://github.com/tvale/xkcdesktop/raw/master/data/screenshot%402x.png)

## Developing and Building
Development may be done using [elementary OS] 5. If you want to hack on and build xkcdesktop yourself, you'll need the following dependencies:
* `libcurl4-openssl-dev`
* `libxml2-dev`
* `libgranite-dev`
* `libgtk-3-dev`
* `meson` (and `cmake` to find `libxml2`)
* `valac`

You can install them on elementary OS 5 with:
```shell
$ sudo apt install elementary-sdk cmake libcurl4-openssl-dev libxml2-dev
```

Run `meson build` to configure the build environment and run `ninja` to build:
```shell
$ meson build --prefix=/usr
$ cd build
$ ninja
```

To install, use `ninja install`, then execute with `com.github.tvale.xkcdesktop`:
```shell
$ sudo ninja install
$ com.github.tvale.xkcdesktop
```

[elementary OS]: https://elementary.io
