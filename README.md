# CH551-4NES4SNES (Plus 4Play for PSX and PS2 controllers)
- Fork from https://github.com/ishiyakazuo/CH551-4NES4SNES - which itself is forked and ported from https://www.raphnet.net/electronique/4nes4snes/index_en.php
- my aim is to fix some bugs I've found with the above, as well as adapt it to a CH552T (which is admittedly a trivial modification)
- please see the original projects for better documentation

# Current Status (NES/SNES)
- I can't get it working for more than one controller at a time. My aim is to support 2 concurrent/simultaneous NES controller pads.

# Todo
- Track down the source of the issues I'm having, and get both pads to work at once
- I only want/need this to report 8 buttons - 4 D-pad, start/select, and A/B
- Debugging - maybe some LED's, or UART printf?

# Aspirational ideas
- Support for Gravis Gamepad Pro gamepads
- Toggle switch or jumper to switch between gamepad mode and keyboard mode (i.e. have the button presses sent as keyboard keys. This is easier to set up in an emulator)
