This file explains how the code is structured.

# General flutter stuff
Flutter is made to work on all devices. That's why there is a directory for each os.

In these directories is platform specific code and other stuff. With a really basic flutter app, you don't have to write into these directories.

Most of the relevant code and all of the cross-platform code is inside of the lib directory.

# Structure
| Directory    | What's inside?                                                                               |
|--------------|----------------------------------------------------------------------------------------------|
| assets       | Assets                                                                                       | 
| home         | All UI (except settings)<br/>player_screen folder also contains mini player (if that exists) |
| player       | Player logic<br/>Player (& queue) control logic<br/>Audio Activity & Session logic           |
| Repositories | SSOT of Queue                                                                                |
| Riverpod     | ALl Riverpod logic (State management)                                                        |
| Services     | All network request logic (currently only Subsonic Service)                                  |
| settings     | Settings logic<br/>Settings UI                                                               |
| storage      | Database logic                                                                               |

## main.dart
Initializes a few utility files and classes. (*Some stuff is done badly right now, the databaseControl for example gets accessed from all over the project, which will get fixed later.*)

Also starts the AudioSession and the AudioService and registers it in the operating system.

In the end, the App is started. It contains the logic to either use the Landscape or Portrait Layout. Also sets the theme.

## useful_scripts.dart
Contains some utility classes that I need frequently.

### SubsonicJustAudioCompatibility
is used to convert Subsonic-Song-Maps to just_audio MediaItems

## player
### audio_player.dart
Extends the AudioPlayer class from the just_audio package.

### player_controls_old.dart
Deprecated, only for reference.

### player_controls.dart
Contains all the player and queue control logic. All player and queue specific actions are sent here, if you tap something in the operating system media notification, it also executes actions from here.

Also updates the StreamData.

## Repositories
### queue_repository.dart
This contains my queue and queue logic. The only method to access the Queue like this, is the PlayerControls class.
I have implemented my own Queue and Queue-logic, because the just_audio queue did not have all the features I needed.

## Riverpod
### riverpod_manager.dart
Contains all the Riverpod providers.

## Services
### subsonic_service.dart
Contains all the subsonic logic. This class makes all the requests to the opensubsonic compatible server and returns all the data it gives you. It also handles the authentication process. It gets all the data needed for the login from the database. (*The passwords are currently saved in plain-text, the plan is to integrate the os specific keyrings.*)

## settings
Contains all the settings pages and specific settings UI widgets, located and sorted into the folders.

### settings_controller.dart
Contains all the settings logic.

Contains the Map, the logic to load and save and change settings.

The settings are saved into a .toml document, whenever a setting is changed.

## storage
Contains the logic for everything that is saved in a database and the path logic.

### paths.dart
Uses the pathProvider package to get the operating system specific paths.

### database
Contains the database controller and the files for the specific datbases. Each database file contains the specific sql "code" needed to do the stuff it needs to do.

### database_controller.dart
Contains the database logic. If something is saved to a database, the database controller is used. The database controller is the only class that should acced the specific databases.
