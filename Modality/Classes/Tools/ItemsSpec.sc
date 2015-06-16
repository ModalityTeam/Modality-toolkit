/*

~itspec = ItemsSpec.new( ["off","amber","red"] );

// check that ranges are equal size: 21 values, 7 each
~itspec.map( (0, 0.05..1) );
x = [ 0-0.5, 3-0.5, 0, 1].asSpec;
x.map((0, 0.05..1));

// anything in [0, 0.3333] -> "off", [0.3334, 0.6666] -> amber, [0.6667, 1] -> red

// unmapping returns the center of the ranges, not the borders:
x.unmap([0, 1, 2]); // [ 0.1667, 0.5, 0.8333 ]

// change warp to bend ranges
~itspec.warp = 4;
~itspec.map( (0, 0.05..1) ); // off has wider part of the range now
~itspec.unmap( "off" );
~itspec.unmap( "amber" );
~itspec.unmap( "red" );


*/

ItemsSpec {
	var <items, <warp, <default, spec;

	*new { |items, warp = 0, default|
		^super.newCopyArgs( items, warp, default ).init;
	}

	init {
		spec = [ -0.5, items.size - 0.5, warp, 1].asSpec;
		// default is in mapped range, not unmapped 0
		// if no default given, take first key
		if (items.includes(default).not) { default = items[0] };
	}

	// from number to item - create equal parts of the range
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

	warp_ { |argWarp| spec.warp_(argWarp) }

}