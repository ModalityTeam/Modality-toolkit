ToDolity

* FuncChain:
  * simplify methods, unify method names
  * test that all variants of adding and removing work

* MKtl:
	* ? move subclass methods up ... 
	* interface protocol: 
		get/setting values, 
		add/remove functions
		sendMsg
	* default devSpec files in quarks, custom ones in userAppSupportDir
	* gesture recording / playback, MKtlLoop based on CtLoop?

* HIDMKtl:
	* populate with MKtlElements
	* make crossplatform!! 
		test, then use getAllCookies

* MKtlElement:
	* composites? somewhat important (TB)

* MIDIMKtl:
	* populate with MKtlElements
	* test crossplatform
	* respond to noteOn, noteOff
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

* Dispatch: 
	* use/test cases for dummies
	* hierarchy of outputs
	* factory of common functionality (average, page ctrl, trigger, acc, LOA, stuff that is in actionFunc, times things, regions(e.g. launchpad,), eventually WOLRD DOMINATION UHAHAAHAHAHAHAHAHAH)
	* several things are the same source, how to deal with it?
	* naming of addFunc/register/etc.

* GUI
	* auto-generate based on controller description 
		(postpone 'til QT gui is settled?)
	* MKtlAllGui
	
* modality mapping, learning, etc.
	copyMap(\sl1, \sl2)
	switchMap(\sl1, \sl2)
	