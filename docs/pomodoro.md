# studytools.pomodoro

**Pomodoro** adds a simple pomodoro timer that can be invoked with commands!

## Usage

There are three commands that you need to know:

| Commands | Function |
| -------- | -------- |
| `:StudytoolsPomodoro <workMinutes> <breakMinutes>` | Start a pomodoro session, specifying how long work and break sessions are in minutes |
| `:StudytoolsPomodoroStop` | Stop the pomodoro session |
| `:StudytoolsPomodoroStatus` | See the current session and how much time is remaining until the next session |

## Setup

To set up, simply add the following to your `init.lua` file, or wherever you configure your plugins:

```lua
require("studytools.pomodoro").setup()
```
