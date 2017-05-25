/*
clip to an integer range and ensure integer type
*/
IntegerClip {
	var <minval,<maxval, <default;

	*new { |minval, maxval, default|
		^super.newCopyArgs( minval,maxval,default ).init;
	}

	init {
		if ( default.isNil ){ default = minval };
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

