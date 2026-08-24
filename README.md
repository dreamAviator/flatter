# flatter

A cross platform Navidrome client

**all data for the servers, including passwords are currently saved in plaintext in a databse, this will be fixed later on**

## features

- Cross Platform
  - Android
  - iOS
  - Linux
  - Windows
  - MacOS

### planned

- automatically fetch Lyrics from the web
- play local music
  - batch metadata editor built in


## other stuff
### Notice regarding the flutter_staggered_gridview_package
In this app, the [flutter_staggered_gridview](https://pub.dev/packages/flutter_staggered_grid_view) package is used. It contains a bug however, that was fixed in a different [branch](https://github.com/letsar/flutter_staggered_grid_view/tree/feature/masonry_cache?tab=readme-ov-file). Because this branch is not yet published on pub.dev, the whole branch is included in this project and repository (using a github url did not work for me).