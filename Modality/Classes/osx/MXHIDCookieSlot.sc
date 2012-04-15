MXHIDCookieSlot{
	var <device, <cookie, value=0,  <>action;
	
	*new { | device, evtType, evtCode, evtCookie |
		^super.newCopyArgs(device, evtCookie)
	}
	
	rawValue {
		^value
	}
	value {
		^value
	}
	
	value_ { | rawValue |
		value = rawValue;
		action.value(this);
		//device.action.value( 0, 0, rawValue, this.value );
	}
	next {
		^this.value
	}
}