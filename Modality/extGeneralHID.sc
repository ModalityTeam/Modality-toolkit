+ GeneralHIDDevice {
	getAllCookies{
		^slots.collect{ |type| type.collect{ |it| it.getCookie }.asArray }.asArray.flatten;
	}
}

+ GeneralHIDSlot {
	getCookie{
		^devSlot.getCookie;
	}
}
