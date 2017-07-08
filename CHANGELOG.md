# Changelog for Modality-toolkit v0.2.0


## Major

+ Complete refactoring 
  * source code overhaul
  * unifying and streamlining usage
+ Help files
  * more and better help files
  * short tutorials on specific topics
+ experimental windows support
+ OSC support via OSCMKtl
  - added OSCMon, a monitor for OSC traffic
  - MKtlLookup for OSCMKtl supports changing ip addresses
+ HID support via HIDMktl
  - HIDExplorer, explore an HID device's functionality
+ MIDI support via MIDIMktl
  - MIDIExplorer, explore a MIDI device's functionality
+ unified `MKtl` entrypoint for OSC, MIDI and HID devices
  * added `MKtl:allElements`
  * renamed `MKtl:elementAt` to `MKtl:elAt`
+ cleanup of helper classes to only include those used directly within the Modality toolkit

## New functionality

+ Pattern support via PKtl
+ Composite MKtls via CompMKtl
+ Support of hardware-specific controller paging (both hard- and soft-wired)
+ MKtlDevice
  * multiIndex support
  * sendSpecialMessage / sysex support
+ GUI support via MktlGUI
  * MPadView
  * MHexPad 
  * MRoundPad
  * Piano
+ SoftSet, RelSet - intelligently set an object's parameters
+ MKtlElement:
  * instrocuction of common types and ControlSpecs in MKtlElement.types
  * MKtlElement:elAt supports wildcards
  * MKtlElement:elAt supports multi-level expansion
+ MKtlElementGroup
  * groupAction 
+ Create custom element groups via MKtlElementCollective
+ Dictionary (extension of standard library)
  * traversePut
  * traverseAt
  * traverseDo
  * traverseCollect
+ Documentation
  * Script to autogenerate markdown files for http://modalityteam.github.io/controllers/.
+ MIDISim, simulate input from MIDI controllers
+ MChanVoicer, a monophonic voicer for midi channel polyphony
+ Moved to VariousMixedThings quark
  * FuncChain
  * FCdef, 
  * FC2def 
  * FuncChain, 
  * FuncChain2
  * OSCExplorer



## Hardware device support

+ unification of device description files (`.desc`) to comply with updated format
+ support for generic HID devices (like mouse, computer keyboard)
+ external midi port support
+ supported devices:
  + ableton push 2
  + ableton push
  + akai apc40
  + akai apcmini
  + akai lpd8
  + akai midimix
  + akai mpd18
  + akai mpkmini
  + akai mpkmini2
  + arturia minilab
  + beatstep
  + behringer bcf2000
  + behringer bcr2000
  + cinematix wheel
  + cthrumusic axis49
  + decampo joybox
  + doepfer pocketfader
  + eowave ribbon
  + evolution ucontrol uc33
  + faderfox uc4
  + fio somo
  + generic mouse
  + gyrosc ga
  + icon icontrols 101
  + icon icontrols pro
  + icon istage
  + icontrols
  + jesstech dual analog rumble
  + jesstech dual analog
  + korg microkey
  + korg nanokey
  + korg nanokey2
  + korg nanokontrol
  + korg nanokontrol2
  + korg nanopad2
  + linnstrument
  + livid guitar wing
  + logitech extreme 3d pro
  + m audio oxygen49
  + m audio triggerfinger
  + makenoise 0coast
  + native instruments traktor kontrol z2
  + nordDrum 2
  + novation launchcontrol xl
  + novation launchcontrol
  + novation launchpad
  + organelle
  + keith-mcmillen qunexus
  + rme audio totalmix
  + saitek cyborg command pad unit
  + saitek cyborg x
  + saitek impact gamepad
  + sensestage minibee1 xpee
  + sensestage minibee1 xpree
  + sensestage minibee1
  + shanwan wireless gamepad
  + snyderphonics manta
  + snyderphonics manta mc
  + steinberg cmc fd
  + steinberg cmc qc
  + steinberg cmc pd
  + teenage engineering op 1
  + thrustmaster megaworldectronics
  + thrustmaster run n drive wireless
  + thrustmaster run n drive
  + touchosc simple1
  + vmeter vmeter
  + xio x-osc




----------------




