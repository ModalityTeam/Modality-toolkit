// ToDolity

* FuncChain:
  * add move methods

* MKtl:
	* interface protocol: 
		setting values on the device, sendMsg
	* default devSpec files in quarks, custom ones in userAppSupportDir
	* gesture recording / playback, a class MKtlLoop based on CtLoop?
	* wrap Description stuff into a separate class? E.g. MKtlDescription?
	* add optional locacionID args to *new
    * deal more gracefully with:
        - controllers for which no spec is found - (print out a template, suggest to start a configuring routine)
        - shortnames which can/should be found in the specs, but that are not connected (store shortnames in index? or just generate them)

* PKtl - add option to sequence MKtls too
		
* MKtlDescription
	* write a bunch of device descriptions
		* Manta
		* MPD24
		* TriggerFinger
		* Logitech Extreme3d Pro
		* Saitec Cyborg Evol
		* Cyborg Keyborg
		* UC33
		* BCR (just copy)
		* BCF
	* write some generic device descriptions (mouse, keyboard, general gamepad)
    * device: could be multiple devices for devices with the same spec

* HIDMKtl:
	* test "crossplatform" on osx. Cannot test until HID is broken on osx.

* MKtlElement:
	* composites? somewhat important (LFSaw)

* MIDIMKtl:
	* get destination to work

* write more [stub] subclasses, finish by demand:
	* KeysMKtl
	* OSCMKtl
	* SerialMKtl
	* GuiMKtl
	* WiiMKtl
	* SETOMKtl
	* DataNodeMKtl
	* KintectMKtl

* Dispatch:
	* default template files in quarks, custom ones in userAppSupportDir
	* pattern matching very slow on Dispatches with many outputs...
	* no defaults when creatings dispatch because of passing arguments in an array… what to do ????
	* do templates:
		acc, 
		Level Of Activity (with decay), 
		from actionFunc:	\speedAbove,\speedBelow,\delay,\slew.
	 	regions(e.g. launchpad,)

* GUI
	* auto-generate based on controller description 
		(postpone 'til QT gui is settled?)
	* MKtlAllGui -> turn on an off posting, or get a graphic representation ?
	
* modality mapping, learning, etc.
	copyMap(\sl1, \sl2)
	switchMap(\sl1, \sl2)
	