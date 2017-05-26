/*
clip to an integer range and ensure integer type
*/
IntegerClip {
	var <minval,<maxval, <defaultValue;


	*new { |minval, maxval, defaultValue|
		^super.newCopyArgs( minval,maxval,defaultValue ).init;
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

