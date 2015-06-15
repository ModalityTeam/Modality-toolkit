/*

~itspec = ItemsSpec.new( ["off","amber","red"], 0 );

~itspec.map( 0 );
~itspec.map( 0.5 );
~itspec.map( 0.8 );
~itspec.map( 1 );

// check that ranges are equal size
~itspec.map( (0, 0.05..1) );

// change warp to bend ranges
~itspec.spec.warp = 4;
~itspec.unmap( "off" );
~itspec.unmap( "amber" );
~itspec.unmap( "red" );


*/

ItemsSpec {
	var <items;
	var <spec;
	var <default;

	*new { |items, warp = \linear, default|
		^super.newCopyArgs( keys, warp, default );
	}

	init {
		spec = [ 0, keys.size, warp, 1].asSpec;
		// default is in mapped range, not unmapped
		// if none given, take first key
		if (names.includes(default).not) { default = keys[0] };
	}

	// from number to item - equal parts of the range
	map { |inval|
		^items.clipAt( spec.map( inval ).asInteger );
	}

	// from string to number
	unmap { |inval|
		var index = items.indexOfEqual( inval );
		if ( index.notNil ){
			^spec.unmap( index );
		};
		^nil;
	}

	asSpec {
		^this;
	}

}