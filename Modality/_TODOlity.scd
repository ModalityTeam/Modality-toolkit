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
	* test "crossplatform" on osx

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
	* pattern matching very slow on Dispatches with many outputs...
	* read File with definitions - factory of common functionality
		average, 
		acc, 
		LOA, 
		stuff that is in actionFunc,
	 	times things, 
	 	regions(e.g. launchpad,)

* MKtlBasicElement
	* writeToBus
	* kr
	* freeBus

* GUI
	* auto-generate based on controller description 
		(postpone 'til QT gui is settled?)
	* MKtlAllGui
	
* modality mapping, learning, etc.
	copyMap(\sl1, \sl2)
	switchMap(\sl1, \sl2)
	