/*
clip to an integer range and ensure integer type
*/
IntegerClip {
	var <minval,<maxval, <defaultValue;


	*new { |minval, maxval, default|
		^super.newCopyArgs( minval,maxval,default ).init;
	}

	init {
		if ( defaultValue.isNil ){ defaultValue = minval };
	}

	map { |inval|
		^inval.asInteger.clip( minval,maxval );
	}

	// from string to number
	unmap { |inval|
		^inval.asInteger.clip( minval,maxval );
	}

	asSpec {
		^this;
	}
}

