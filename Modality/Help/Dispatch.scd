

//average
(
a = MIDIMKtl(\nano1, -1871034450);
// Dispatch
d = Dispatch.new;

d.mapToElem( a, \sl1_1, \myController1 );
d.mapToElem( a, \sl2_1, \myController1 );

d.addToProc( \average, { |dis|
	var val = [\sl1_1,\sl2_1].collect{ |it| dis.getInput( \myController1, it ) }.sum;
	dis.setOutput( \average, val/2 );
} );

d.addToOutput(\average,\blah,{Ê|a,b,c| postln("average is "++c) })
)

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

d.addToOutput(\sl1_1,\blah,{Ê|a,b,c| postln("delta is "++c) })
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
d.addToOutput(\sl2_1,\blah,{Ê|a,b,c| { ~sl.value_(c/4000) }.defer; x.set(\mod, c/40)  })

)
x = {Ê|freq= 400, mod = 1| Saw.ar( Lag.kr(freq) ) * SinOsc.ar(Lag.kr(mod) ).range(0.0,1.0)* 0.5 }.play

x = {Ê|freq= 400, mod = 1| Saw.ar( LeakDC.kr( Lag.kr(freq)) + 100 ) * SinOsc.ar( LeakDC.kr( Lag.kr(mod), 0.990) + 1 ).range(0.0,1.0)* 0.5 }.play

