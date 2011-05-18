ToDolity

* FuncChain:
  * simplify methods, unify method names
  * test that all variants of adding and removing work

* MKtl:
	* interface protocol: 
		get/setting values, 
		add/remove functions
		sendMsg
	* default devSpec files in quarks, custom ones in userAppSupportDir
        on linux hid device names show up differently (including vendor name)
        how is device protocol, device name (os dependent) handled?
	* gesture recording / playback, MKtlLoop based on CtLoop?

* HIDMKtl:
	* make crossplatform!! 
		test, then use getAllCookies

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

* Dispatch:
	* pattern matching very slow on Dispatches with many outputs...
	* read File with definitions - factory of common functionality
		average, 
		acc, 
		LOA, 
		stuff that is in actionFunc,
	 	times things, 
	 	regions(e.g. launchpad,)
	* BynaryOpDispatch (copy from BinaryOpUGen ? )	- well let's just think about it
	------------------------------------------------------------------------------------
	* read File with definitions - factory of common functionality
		page ctrl,
		trigger, 
	* recursive remove of dispatchs ? good idea ?
	* easy way to compose several Dispatchs (starting to look like UGens, cool)
	* several things are the same source, how to deal with it? (appears to work)
	* common interface between MKtlElement and DispatchOut (done)
	* add verbose posting (done)
	* use/test cases for dummies (Miguuel: done - help file)
	* hierarchy of outputs (Miguel - just use symbols like in osc /page1/string1, done)
	* naming of addFunc/register/etc. (Miguel: done - addToProc and addToOutput)

* GUI
	* auto-generate based on controller description 
		(postpone 'til QT gui is settled?)
	* MKtlAllGui
	
* modality mapping, learning, etc.
	copyMap(\sl1, \sl2)
	switchMap(\sl1, \sl2)
	