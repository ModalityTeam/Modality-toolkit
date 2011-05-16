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

a = (); // pseudoktl
a.put( \me, 1 )

b = (); // pseudoktl
b.put( \me, 2 )


// Dispatch
d = Dispatch.new;

d.mapToElem( a, \slider1, \nano );
d.mapToElem( a, \slider2, \nano );
d.mapToElem( a, \slider3, \nano );
d.mapToElem( a, \button, \nano ); // should this set a default value?

d.mappedElems

d.value( a, \slider1, 0.3 );
d.value( a, \slider2, 0.5 );

d.sources
d.funcChain
d.ktlToSources
d.changedOuts
d.envir
d.outputs

// initialize the scene
d.setVar( \scene, 0 );
d.addFunction( \setScene, { |dis| 
	var mybutton = dis.getInput( \nano, \button );
	if ( (mybutton.value == 1) && mybutton.changed ){
		// select one of five scenes;
		dis.setVar( \scene, (dis.getVar( \scene ) + 1).wrap(0,5) );
		"scene %\n".postf( dis.getVar( \scene ) );
	};
} );

d.value( a, \button, 1 );

d.value( a, \slider1, 0.2 );

d.getInput( \nano, \slider2)
d.setOutput( \average, 0.4)

d.ktlToSources
d.sources

d.changedOuts

d.addFunction( \average, { |dis|
	var val = [\slider1,\slider2].collect{ |it| dis.getInput( \nano, it ) }.sum;
	dis.setOutput( \average, val/2 );
} );

d.addFunction( \averageBut, { |dis|
	var val = dis.getInput( \me, \average );
	dis.setVar( \avinter, val/2 );
} );


now \slider1 when a value changes will call
.value

slider -> value( ktlname, slider, value )

d.ktlToSources

d.value( a )

d.map( source, ctl, name );
value->
(source,ctl)-pairs to names;

d.map( \nanoktl, \slider1, \myslidervalue );
d.map( \guinano, \slider1, \myslidervalue );

( \me -> this Dispatch )
( \source1 -> Ktl )
sources
source1 -> collection of ctls
   ctl -> name

d.mapsource( \source1, d )

d.addFunction( \setSlider1, {
	d.setOutput( \slider1, 0.5 );
});

d.addFunction( \average, { |value,ctl,dis,ktl| 
	envir.put( \average, [\slider1,\slider2,\slider3].collect{ |it| envir[it] }/3 );
	[\average,\otherstuff]
} );


envir[\myslidervalue]

look up name for source, ctl
envir.name = value

d.addFunction( \average, { |value,ctl,dis,ktl| 
	envir.put( \average, [\slider1,\slider2,\slider3].collect{ |it| envir[it] }/3 );
	[\average,\otherstuff]
} );

d.addFunction( \average, { |value,ctl,dis,ktl| 
	envir.put( \average, [\slider1,\slider2,\slider3].collect{ |it| envir[it] }/3 );
	dis.setOutput( \average, val )
} );


~d2 = Dispatch.new;
d.addFunction( \dispatcher2, ~d2 );

// all values of the ktl in an array
ktl.elements.collect{ |it| it.value };


