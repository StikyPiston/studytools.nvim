# studytools.inlineannotations

**Inlineannotations** provides inline annotations to enhance your notes in
Neovim (or code comments, anything really!)

## Usage

To add an annotation to a line, type two exlamation points with the annotation
type inbetween.

The available annotations are:

| Annotations  |
| ------------ |
| !IMPORTANT!  |
| !QUESTION!   |
| !STUDY!      |
| !DEFINITION! |
| !EXAMPLE!    |
| !REVIEW!     |
| !MEMORISE!   |
| !CUSTOM[Text]!     |

**Custom** is a special annotation, in that you can put any text you want
between the square brackets!

## Setup

To set up, simply add the following to your `init.lua` file, or wherever you
configure your plugins:

```lua
require("studytools.inlineannotations").setup()
```
