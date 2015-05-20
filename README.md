# Modality Toolkit

The *Modality Toolkit* is a library to facilitate accessing (hardware) controllers in SuperCollider.
It is designed and developed by the ModalityTeam, a group of people that see themselves as both developers and (advanced) users of SuperCollider.

The central idea behind the Modality-toolkit is to simplify creation of individual (electronic) instruments with SuperCollider, using controllers of various kinds. To this end, a common code interface, MKtl, is used for connecting  controllers from various sources (and protocols). These are atm. HID and MIDI; OSC, Serialport and GUI-based are planned to be integrated.

The name *Modality* arose from the idea to scaffold the creation of modal interfaces, i.e. to create interfaces where one physical controller can be used for different purposes and it is possible to *switch its functionality, even at runtime*.
It is our believe that integration of such on-the-fly remapping features helps to create a setup much more flexible, powerful, and interesting to play. 
Such a modal interface allows to cope with fast changes of overall direction as it can be necessary when e.g. improvising with musicians playing acoustic instruments.

For more information, visit the [Modality page](http://modality.bek.no).

## Installation

There are multiple ways to install Modality to your SuperCollider environment:

+ Quarks (recommended for generic installations of SC 3.7+)
+ git clone (recommended for active development)
+ manual zip-file (recommended for static standalone installations)

### Quarks install

+ evaluate ```Quarks.gui``` in SuperCollider
+ select and install ```Modality-toolkit```

### git

+ Evaluate ````Platform.userExtensionDir```` to get the path to the SuperCollider extension folder.
+ Clone the modality toolkit to that folder via 
```
git clone https://github.com/ModalityTeam/Modality-toolkit.git Modality
```

### manual zip-file

+ download the [zip file](https://github.com/ModalityTeam/Modality-toolkit/archive/master.zip) of the current repository head.
+ Evaluate ````Platform.userExtensionDir```` to get the path to the SuperCollider extension folder.
+ unzip the downloaded file into the extensions folder.

## Getting started

Please read the article on "Modality" in the SuperCollider help system (Here's the [unrendered version](https://github.com/ModalityTeam/Modality-toolkit/blob/master/Modality/HelpSource/Overviews/Modality.schelp) of it if you want to take a peek).

## Acknowledgements
Modality and its research meetings have kindly been supported by [BEK](http://www.bek.no/) and [STEIM](http://steim.org/). The Modality toolkit is free software published under the GPL.

