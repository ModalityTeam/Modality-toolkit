+ MXHID {

	getSlotsForCookies{
		var cookieDict = IdentityDictionary.new;
		
		device.elements.do{ |ele,i|
			cookieDict.put( ele.cookie, MXHIDCookieSlot( device, ele.cookie ) );
		};
		^cookieDict;
	}
}
