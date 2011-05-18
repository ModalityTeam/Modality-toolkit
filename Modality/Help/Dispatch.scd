
MIDIMKtl.find
a.verbose = false
//average
(
a = MIDIMKtl('nnkn0');
// Dispatch
d = Dispatch.new;

d.mapToElem( a, \sl1_1, \myController1 );
d.mapToElem( a, \sl2_1, \myController1 );
d.createOutput(\average);
d.addToProc( \average, { |dis|
	var val = [\sl1_1,\sl2_1].collect{ |it| dis.getInput( \myController1, it ) }.sum;
	dis.setOutput( \average, val/2 );
} );

d.addToOutput(\average,\blah,{ |a,b,c| postln("average is "++c) })
)
d.remove;
d.verbose = true;
//Delta
(
a = MIDIMKtl(\nano1, -1871034450);
// Dispatch
d = Dispatch.new;

d.mapToElem( a, \sl1_1, \myController1 );
d.mapToElem( a, \sl2_1, \myController1 );

d.addToProc( \velocityCalc, { |dis,e|
	var in = dis.changedIn;
	var key = in[\key];
	var source = in[\source];
	var value = in[\val];
	
	if( e[source].isNil ) {
		e.put(source,Dictionary.new);
	};
	if(	e[source][key].isNil ) {
		e[source][key] = value
	} {
		dis.setOutput(key, value - e[source][key]);
		e[source][key] = value
	}

} );

d.addToOutput(\sl1_1,\blah,{ |a,b,c| postln("delta is "++c) })
)

//Velocity
(
a = MIDIMKtl(\nano1, -1871034450);
// Dispatch
d = Dispatch.new;

d.mapToElem( a, \sl1_1, \myController1 );
d.mapToElem( a, \sl2_1, \myController1 );

d.addToProc( \velocityCalc, { |dis,e|
	var in = dis.changedIn;
	var key = in[\key];
	var source = in[\source];
	var value = in[\val];
	var keyTime = (key++"time").asSymbol;
	var currentTime;
	
	if( e[source].isNil ) {
		e.put(source,Dictionary.new);
	};
	if(	e[source][key].isNil ) {
		e[source][key] = value;
		e[source][keyTime] = Process.elapsedTime;
	} {
		currentTime = Process.elapsedTime;
		dis.setOutput(key, abs( (value - e[source][key]) / ( currentTime - e[source][keyTime] ) ) ) ;
		e[source][key] = value;
		e[source][keyTime] = currentTime;
	}

} );

w = Window.new.front;
~sl = Slider(w, Rect(20, 60, 150, 20));
d.addToOutput(\sl1_1,\blah,{Ê|a,b,c| { ~sl.value_(c/4000) }.defer; x.set(\freq,c*2)  });
d.addToOutput(\sl2_1,\blah,{ |a,b,c| { ~sl.value_(c/4000) }.defer; x.set(\mod, c/40)  })

)
x = { |freq= 400, mod = 1| Saw.ar( Lag.kr(freq) ) * SinOsc.ar(Lag.kr(mod) ).range(0.0,1.0)* 0.5 }.play

x = { |freq= 400, mod = 1| Saw.ar( LeakDC.kr( Lag.kr(freq)) + 100 ) * SinOsc.ar( LeakDC.kr( Lag.kr(mod), 0.990) + 1 ).range(0.0,1.0)* 0.5 }.play

(
~makeVelocityDispatch = { |source|
	d = Dispatch.new;
	d.mapAll(source);
	source.elementNames.do{ |name| d.createOutput(name) };
	d.addToProc( \velocityCalc, { |dis,e|
		var in = dis.changedIn;
		var key = in[\key];
		var source = in[\source];
		var value = in[\val];
		var keyTime = (key++"time").asSymbol;
		var currentTime;
		
		if( e[source].isNil ) {
			e.put(source,Dictionary.new);
		};
		if(	e[source][key].isNil ) {
			e[source][key] = value;
			e[source][keyTime] = Process.elapsedTime;
		} {
			currentTime = Process.elapsedTime;
			dis.setOutput(key, abs( (value - e[source][key]) / ( currentTime - e[source][keyTime] ) ) ) ;
			e[source][key] = value;
			e[source][keyTime] = currentTime;
		}
	
	} );
   d
}
)

//paged ktl
(
~makePagedVersion = { |source, previousSceneKey, nextSceneKey, n = 10|
var d = Dispatch.new;
d.mapAll(source);

// initialize the scene
d.envir[\scene] = 0;
d.envir[\numOfScenes] = n;
d.envir[\values] = n.collect{ Dictionary.new.putPairs(source.elementNames.collect{ |name| [name, source.defaultValueFor(name) ? 0] }) };
n.collect{ |i| source.elementNames.collect{ |name| d.createOutput(("/page"++(i+1)++"/"++name).asSymbol) } };
d.addToProc( \processEvents, {  |dis,e|
	var in = d.changedIn; // (source: \source, key: \sl1)

	e[\values][e[\scene]][in[\key]] = in[\val];
	d.setOutput(("/page"++(e[\scene]+1)++"/"++in[\key]).asSymbol,in[\val])

});
d.addToProc( \changeScene, {  |dis,e|
	var in = d.changedIn; // (source: \source, key: \sl1)

	if( (in[\key] == previousSceneKey) && ( in[\val] == 127 )) {
		e[\scene] = (e[\scene] - 1).min(n);
		postln("Scene is "++e[\scene])	

	};
	if( (in[\key] == nextSceneKey) && ( in[\val] == 127 )) {
		e[\scene] = (e[\scene] + 1).max(0);
		postln("Scene is "++e[\scene])
	};	
});
d
}
)
//k = MIDIMKtl(\nano1, -1871034450);

//could be Dispatch.paged(MIDIMKtl('lnch0'),\left,\right)
~paged = ~makePagedVersion.(MIDIMKtl('lnch0'),\left,\right,32)
n.collect{ |i| source.elementNames.collect{ |name| d.addToOutput(("/page"++(i+1)++"/"++name).asSymbol, \aFunction, { |a,b,c| [a,b,c].postln }) } };

~paged.remove

~paged = ~makePagedVersion.(MIDIMKtl('nnkn0'),\rew,\fwd)
~paged.verbose = true
~paged.remove

~dis1 = ~makePagedVersion.(MIDIMKtl('nnkn0'),\rew,\fwd,32);
~dis2 = ~makeVelocityDispatch.(~dis1);
~dis2.verbose = true
~paged.remove

MIDIMKtl('lnch0').elementNames

d.remove
d.envir[\scene] = 1

k.verbose = true


