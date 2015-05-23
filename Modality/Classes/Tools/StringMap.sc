/*

~map = StringMap.new( ["off","amber","red"] );

~map.map( 0 );
~map.map( 0.5 );
~map.map( 1 );


~map.unmap( "off" );
~map.unmap( "amber" );
~map.unmap( "red" );


*/

StringMap{
	var <keys;
	var <spec;
	var <default;

	*new{ |keys|
		^super.new.init( keys );
	}

	init{ |names|
		keys = names;
		spec = [ 0, keys.size-1, \linear, 1].asSpec;
		default = spec.minval;
	}

	// from number to string
	map{ |inval|
		^keys.at( spec.map( inval ).asInteger );
	}

	// from string to number
	unmap{ |inval|
		var index = keys.indexOfEqual( inval );
		if ( index.notNil ){
			^spec.unmap( index );
		};
		^nil;
	}

	asSpec{
		^this;
	}

}