ToDolity

* FuncChain:
  * simplify methods, unify method names
  * test that all variants of adding and removing work

* MKtl:
	* ? move subclass methods up ... 
		(LFSaw: mostly done)

	* populate with MKtlElements
	* interface protocol: 
		get/setting values, 
		add/remove functions
		sendMsg
	* default devSpec files in quarks, custom ones in userAppSupportDir
        on linux hid device names show up differently (including vendor name)
        how is device protocol, device name (os dependent) handled?
	* gesture recording / playback, MKtlLoop based on CtLoop?

* HIDMKtl:
	* populate with MKtlElements
	* make crossplatform!! 
		test, then use getAllCookies

* MKtlElement:
	* composites? somewhat important (LFSaw)

* MIDIMKtl:
	* respond to noteOn, noteOff (LFSaw: done)
	* test crossplatform
	* addFunc should conform to super.addFunc

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
	* common interface between MKtlElement and DispatchOut
	* factory of common functionality (average, page ctrl, trigger, acc, LOA, stuff that is in actionFunc,
	 times things, regions(e.g. launchpad,), transform trigger buttons (that go 127 when pressed and 0 when depressed) into just a trigger, eventually WOLRD DOMINATION UHAHAAHAHAHAHAHAHAH)
	* several things are the same source, how to deal with it?
	* easy way to compose several Dispatchs
	* add verbose posting
	------------------------------------------------------------------------------------
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
	