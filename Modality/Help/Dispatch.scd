
MIDIMKtl.find
//temporary dispatchs
//evaluate this
(
~makeVelocityDispatch = { |source, elementKeys, sourceKey|
	d = Dispatch.new;
	
	if( elementKeys.isNil ) {
		d.mapAll(source,sourceKey)
	} {
		elementKeys.do{ |elemKey| d.mapToElem(source,elemKey,sourceKey)}
	};
	
	d.createOuputsFromInputs;
	
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
};

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
};

~mergeDispatch = { |dispatchs|

	d = Dispatch.new;
	
	dispatchs.do{ |arr|
		var disp,elemKeys;
		#disp, elemKeys = arr;
		d.map(disp, elemKeys)		
	};
	
	d.createOuputsFromInputs;
	
	d.addToProc( \velocityCalc, { |dis,e|
		var in = dis.changedIn;
		dis.setOutput(in[\key], in[\val] );
	});
  	d
};

~triggerDispatch = { |source,elemKeys, sourceKey|
	d = Dispatch.new;
	d.map(source, elemKeys);	
	d.createOuputsFromInputs;
	
	d.addToProc( \velocityCalc, { |dis,e|
		var in = dis.changedIn;
		if( in[\val] == 1 ) {
			dis.setOutput(in[\key], 1)
		}
	});
  	d
};

~multipleClickDispatch = { |source,elemKeys, sourceKey, numClicks = 2|
	d = Dispatch.new;
	d.map(source, elemKeys);	
	d.createOuputsFromInputs;
	source.elementNames.do{ |elemKey| d.envir.put(elemKey,0) };
	d.addToProc( \velocityCalc, { |dis,e|
		var in = dis.changedIn;
		var key = in[\key];
		if( (in[\val] == 1) ) {
			
			if( e[key] == numClicks) { 
				dis.setOutput(key, 1);
				e[key] = 0;
			} {			
				e[key] = e[key] + 1;
			}
		}
	});
  	d
};
)

//k = MIDIMKtl(\nano1, -1871034450);

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

//paged launchpad
(
~paged = ~makePagedVersion.(MIDIMKtl('lnch0'),\left,\right,32);
~paged.verbose = true
)
~paged.remove

//paged nanoKontrol
(
~paged = ~makePagedVersion.(MIDIMKtl('nnkn0'),\rew,\fwd)
~paged.verbose = true
)
~paged.remove

//velocity
(
~dis = ~makeVelocityDispatch.(MIDIMKtl('nnkn0'));
w = Window.new.front;
~sl = Slider(w, Rect(20, 60, 150, 20));
d.addToOutput(\sl1_1,\blah,{Ê|a,b,c| { ~sl.value_(c/4000) }.defer; x.set(\freq,c*2)  });
d.addToOutput(\sl2_1,\blah,{ |a,b,c| { ~sl.value_(c/4000) }.defer; x.set(\mod, c/40)  })
)
x = { |freq= 400, mod = 1| Saw.ar( Lag.kr(freq) ) * SinOsc.ar(Lag.kr(mod) ).range(0.0,1.0)* 0.5 }.play

x = { |freq= 400, mod = 1| Saw.ar( LeakDC.kr( Lag.kr(freq)) + 100 ) * SinOsc.ar( LeakDC.kr( Lag.kr(mod), 0.990) + 1 ).range(0.0,1.0)* 0.5 }.play

d.remove
// paged and then velocity
(
~dis1 = ~makePagedVersion.(MIDIMKtl('nnkn0'),\rew,\fwd,4);
~dis2 = ~makeVelocityDispatch.(~dis1);
~dis2.verbose = true
)
~dis2.recursiveRemove

//make slider output velocity but keep the rest of controls absolute and merge into just one controller
(
k = MIDIMKtl('nnkn0');

~sliders =  ~makeVelocityDispatch.(k, k.elementsOfType(\slider).collect(_.name) );

~restOfElems = k.elements.select{ |elem|
	elem.deviceDescription[\type] != \slider
}.collect(_.name);

~result = ~mergeDispatch.([[~sliders,nil],[k,~restOfElems]]);
~result.verbose = true;
~sliders.verbose = true;
)
~result.remove // only removes the merge dispatch
~result.recursiveRemove // removes all dispatchs going down the chain

//same ktl, different controls to different sources
(
k = MIDIMKtl('nnkn0');
d = Dispatch.new;
~sliders =  d.map(k, k.elementsOfType(\slider).collect(_.name) , \nksliders);
~buttons =  d.map(k, k.elementsOfType(\button).collect(_.name) , \nkbuttons);
)

// trigger
(
~tr =  ~triggerDispatch.( MIDIMKtl('nnkn0'));
~tr.verbose = true;
)
~tr.remove

// multiple trig
(
~tr =  ~multipleClickDispatch.( MIDIMKtl('nnkn0'));
~tr.verbose = true;
)
~tr.remove



k.verbose = true
k = MIDIMKtl('nnkn0')