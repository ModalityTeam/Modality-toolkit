+ HIDMKtl{

	// is this cross platform? Doesn't seem like!
	*postRawSpecsOf { |dev| 
		"HIDMKtl - the reported properties of device: %\n".postf(dev.info.name);
		"	index, type, usage, cookie, min, max, ioType, usagePage, usageType.\n\t".postln;
		
		dev.elements.do { |ele, i|
			("" + i + "\t").post; [ele.type, ele.usage, ele.cookie, ele.min, ele.max, ele.ioType, ele.usagePage, ele.usageType].postln;
		}
	}

	*initHIDDeviceServiceAction{
		"HIDMKtl is overriding the normal GeneralHID HIDDeviceService action, you cannot use HIDMKtl and GeneralHID at the same time".warn;
		HIDDeviceService.action_({arg productID, vendorID, locID, cookie, val;
			//[productID, vendorID, locID, cookie, val].postln;
			//this.locIDtoKtl.postln;
		//	if (debug) {("debug"+[productID, vendorID, locID, cookie, val]).postln;};
			if ( exploring ){
				try{
					[ this.locIDtoKtl.at( locID ), locID, cookie, val].postln
				}
			};
			try {
				this.locIDtoKtl.at( locID ).cookieslots.at( cookie ).value_(val);
			} {
				// fall thru to next action here...
				if (exploring) {
					("fall thru"+[productID, vendorID, locID, cookie, val]).postln;
				}
			}
		});
	}

	setGeneralHIDActions{
		var newElements = (); // make a new list of elements, so we only have the ones that are present for the OS

		
		if ( thisProcess.platform.name == \osx ){	
			cookieslots = cookieslots ?? srcDevice.device.getSlotsForCookies;
		};
		
		this.elements.do{ |el|
			var slot = el.elementDescription[\slot]; // linux
			var cookie = el.elementDescription[\cookie]; // osx
			
			// on linux:
			if ( slot.notNil ){
				srcDevice.slots[ slot[0] ][ slot[1] ].action = { |v| el.rawValueAction_( v.value ) };
				newElements.put( el.name, el );
			};
			// on osx:
			if ( cookie.notNil ){
				elemDict.put(  cookie, el );
			//	srcDevice.dump;
				
				cookieslots.at( cookie ).action = { |slot| this.elemDict[ cookie ].rawValueAction_( slot.rawValue ) };
				//srcDevice.device.slots.at( cookie ).action = { |slot| this.elemDict[ cookie ].rawValueAction_( slot.rawValue ) };
				//srcDevice.hidDeviceAction = { |ck,val| this.elemDict[ ck ].rawValueAction_( val ) };
				newElements.put( el.name, el );
			}
		};
		this.replaceElements( newElements );
	}

}