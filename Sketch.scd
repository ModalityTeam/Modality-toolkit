Ktl - collection of 
controls with
- rawValue,
- value (normalised value),
- hardware scene,
- semantic description of the control
- spec (how to map)

- deals with hardware protocols

Dispatch - 



//Ktl - containing some sliders
k = Ktl.new;
k.elements = [\slider1,\slider2,\slider3]

// Dispatch
d = Dispatch.new;
k.addFunction( \slider1, \dispatch1, d );
k.addFunction( \slider2, \dispatch1, d );
k.addFunction( \slider3, \dispatch1, d );

slider -> value( ktlname, slider, value )

d.addFunction( \addSliderValue, { |value,ctl,dis,ktl| 
	if ( [\slider1,\slider2,\slider3].contains(key) ){
		envir.put( key, val );
	};
} );
d.addFunction( \average, { |value,ctl,dis,ktl| 
	envir.put( \average, [\slider1,\slider2,\slider3].collect{ |it| envir[it] }/3 );
} );

// initialize the scene
d.set( \scene, 0 );
d.addFunction( \setScene, { |ktl,key,value,envir| 
	if ( key == \button1 ){
		// select one of five scenes;
		envir.put( \scene, (envir[\scene] + 1).wrap(0,5) );
	};
} );

~d2 = Dispatch.new;
d.addFunction( \dispatcher2, ~d2 );

// all values of the ktl in an array
ktl.elements.collect{ |it| it.value };


