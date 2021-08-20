# MuteTeamsWithPlayer for macOS

An app that listens for bluetooth headphones keypress and sends Toggle Mute command to macOS's Microsoft Teams while a call is ongoing.

## Why
Bluetooth headphones are supposed to let You walk away from Your desk – that's why they're wireless, right?
But how can You peacefully wander around if You have to run back to unmute Your microphone all the time?
Solution: toggle mute using Play/Pause button of Your headphones.

On macOS there is currently no easy way to remap Play/Pause buttons of Bluetooth headset – Karabiner and BTT support only keyboards etc.
Instead, This tool pretends to be a media player that starts playback when it detects that MS Teams call has started.

## Caveats
- to detect call state, the tool looks for "isOngoing: " in MS Teams log file `~/Library/Application Support/Microsoft/Teams/logs.txt`
- to toggle mute, tool uses AppleScript keystroke `Cmd+Shift+M`
- both of the above mean that this tool cannot be Sandboxed
- Teams has no AppleScript support itself, so there is no easy way to detect current mute state;
  it can be done by [reading descriptions of buttons in TouchBar](https://github.com/wadimw/Remotes/tree/master/Main/Microsoft%20Teams),
  but it's not implemented here and those without TouchBar are out of luck
- app is still subject to regular Now Playing behavior, i.e. if any other player starts playback AFTER the call has started,
  system will send button press to it instead of this app

## Important
Check if Your headphones still send play/pause events while in Hands-Free Profile
(I implemented all that only to notice that my Huawei Freebuds 4i seem do that only in AD2P rendering the whole thing useless).

Also, due to the above I probably won't be actively maintaining this project.

## Enhancements
You can implement more functionality (e.g. hang up on Previous Track click) - the list of possible commands is in [docs](https://developer.apple.com/documentation/mediaplayer/mpremotecommandcenter)
