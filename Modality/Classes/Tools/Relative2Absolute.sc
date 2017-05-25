/*
set a value from a relative increment or decrement
useful for encoders or jogwheels

Test:

a = Relative2Absolute.new( 0, 1024 );
a.value
a.delta_( 4 )
a.value
a.value_( 600 ); a.value;
a.delta_( -10 ); a.value;
a.value_( 0 ); a.value;
a.delta_( -10 ); a.value;
a.value_( 1023 ); a.value;
a.delta_( 10 ); a.value;

*/

Relative2Absolute {
	var <minval,<maxval, <initVal;
	var <value;

	*new { |minval, maxval, initVal|
		^super.newCopyArgs( minval,maxval,initVal ).init;
	}

	init {
		if ( initVal.isNil ){ initVal = minval+maxval/2 };
		this.reset;
	}

	reset{
		value = initVal;
	}

	delta_{ |delta|
		value = value + delta;
		value = value.clip( minval, maxval );
	}

	value_{ |val|
		("Relative2Absolute: setting value directly to:"+val).warn;
		value = val;
	}

}

MIDIRelative2AbsoluteFloat{
	var <rawMinVal, <rawMaxVal, <rawInitVal;
	var <spec;
	var <r2a;

	*new { |rawminval, rawmaxval, rawInitVal|
		^super.newCopyArgs( rawminval,rawmaxval,rawInitVal ).init;
	}

	init {
		r2a = Relative2Absolute.new( rawMinVal, rawMaxVal, rawInitVal );
		spec = [ rawMinVal, rawMaxVal, \linear, 1 ].asSpec;
	}

	midiDelta_{ |val|
		if ( val > 64 ){ val = 64-val; };
		this.delta_( val );
	}

	delta_{ |dl|
		r2a.delta_( dl );
	}

	value{
		^spec.unmap( r2a.value );
	}

	value_{ |inval|
		r2a.value_( spec.map( inval ) );
	}

}