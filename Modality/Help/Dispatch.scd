
MIDIMKtl.find
//temporary dispatchs
//evaluate this
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
};


~threshZones = { |source,elemKeys, sourceKey, threshs|
	d = Dispatch.new;
	d.map(source, elemKeys);	
	d.createOutputsFromInputs;
	d.sources.pairsDo{ |sourceKey,keysDict|
		d.envir.put(sourceKey,keysDict.collect{0});
		keysDict.pairsDo{ |key|
			threshs.do{ |a,i|
				d.createOutput((key++"_"++i).asSymbol)
			}
		};
	};
	threshs = threshs.sort;
	d.addToProc( \calc, { |dis,e|
		var in = dis.changedIn;
		var key = in[\key];
		var source = in[\source];
		var value = in[\val];
		var prevTresh;
		var currentTresh;
		var currentTreshIndex;
		
		threshs.do{ |th,i|
			if( value > th ) {
				currentTresh = th;	
				currentTreshIndex = i;						};
			if( e[source][key] > th ) {
				prevTresh = th;								};				
		};
		
		if( prevTresh != currentTresh ) {
			if( currentTreshIndex.notNil ) {
				dis.setOutput((key++"_"++currentTreshIndex).asSymbol,  1);
			}
		};
		e[source][key] = value;
	
	} );
   d
};

~up = { |source,elemKeys, sourceKey|
	d = Dispatch.new;
	d.map(source, elemKeys);	
	d.createOutputsFromInputs;
	d.sources.pairsDo{ |sourceKey,keysDict|
		d.envir.put(sourceKey,keysDict.collect{0})
	};
	
	d.addToProc( \calc, { |dis,e|
		var in = dis.changedIn;
		var key = in[\key];
		var source = in[\source];
		var value = in[\val];
		
		if( value > e[source][key] ) {			dis.setOutput(key, value );
		};
		e[source][key] = value;
	
	} );
   d
};

~down = { |source,elemKeys, sourceKey, thresh = 0.5|
	d = Dispatch.new;
	d.map(source, elemKeys);	
	d.createOutputsFromInputs;
	d.sources.pairsDo{ |sourceKey,keysDict|
		d.envir.put(sourceKey,keysDict.collect{0})
	};
	
	d.addToProc( \calc, { |dis,e|
		var in = dis.changedIn;
		var key = in[\key];
		var source = in[\source];
		var value = in[\val];
		
		if( value < e[source][key] ) {				dis.setOutput(key, value );
		};
		e[source][key] = value;
	
	} );
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


//same ktl, different controls to different sources
(
k = MIDIMKtl('nnkn0');
d = Dispatch.new;
~sliders =  d.map(k, k.elementsOfType(\slider).collect(_.name) , \nksliders);
~buttons =  d.map(k, k.elementsOfType(\button).collect(_.name) , \nkbuttons);
)
d.remove

//------- TEMPLATES-----------------------

//paged launchpad
(
~paged = ~makePagedVersion.(MIDIMKtl('lnch0'),\left,\right,32);
~paged.verbose = true
)
~paged.remove

~paged = ~makePagedVersion.(MIDIMKtl('nnkn0'),\rew,\fwd);
~paged.verbose = true

//paged nanoKontrol
(
~paged = Dispatch(\paged,MIDIMKtl('nnkn0'),\rew,\fwd);
~paged.verbose = true
)
~paged.remove
~paged.insp


//velocity
(
~dis = Dispatch(\velocity, MIDIMKtl('nnkn0') );
~dis.verbose = true;
)

(
w = Window.new.front;
~sl = Slider(w, Rect(20, 60, 150, 20));
d.addToOutput(\sl1_1,\blah,{Ê|a,b,c| { ~sl.value_(c/4000) }.defer; x.set(\freq,c*2)  });
d.addToOutput(\sl2_1,\blah,{ |a,b,c| { ~sl.value_(c/4000) }.defer; x.set(\mod, c/40)  })
)

x = { |freq= 400, mod = 1| Saw.ar( Lag.kr(freq) ) * SinOsc.ar(Lag.kr(mod) ).range(0.0,1.0)* 0.5 }.play

x = { |freq= 400, mod = 1| Saw.ar( LeakDC.kr( Lag.kr(freq)) + 100 ) * SinOsc.ar( LeakDC.kr( Lag.kr(mod), 0.990) + 1 ).range(0.0,1.0)* 0.5 }.play

// paged and then velocity
(
~dis1 = Dispatch(\paged, MIDIMKtl('nnkn0'),\rew,\fwd,4);
~dis2 = Dispatch(\velocity, ~dis1);
~dis2.verbose = true
)
~dis2.recursiveRemove



//merge
//make slider output velocity but keep the rest of controls absolute and merge into just one controller
(
k = MIDIMKtl('nnkn0');

~sliders =  Dispatch(\velocity,k, k.elementsOfType(\slider).collect(_.name) );

~restOfElems = k.elements.select{ |elem|
	elem.deviceDescription[\type] != \slider
}.collect(_.name);

~result = Dispatch(\merge,[[~sliders,nil],[k,~restOfElems]]);
~result.verbose = true;
~sliders.verbose = true;
)
~result.remove // only removes the merge dispatch
~result.recursiveRemove // removes all dispatchs going down the chain



// trigger
(
~tr =  Dispatch(\trigger, MIDIMKtl('nnkn0') );
~tr.verbose = true;
)
~tr.remove
MIDIMKtl('nnkn0').verbose = false



// multiple trig
(
~disp  =  Dispatch(\multipleClick,MIDIMKtl('nnkn0'));
~disp .verbose = true;
)
~disp .insp
~disp .remove



// thresh
(
~disp =  Dispatch(\threshold, MIDIMKtl('nnkn0'), thresh: 0.5 );
~disp.verbose = true;
)
~disp.remove



// thresh up
(
~disp =  Dispatch(\thresholdUp, MIDIMKtl('nnkn0'), thresh: 0.5 );
~disp.verbose = true;
)
~disp.remove



// thresh down
(
~disp =  Dispatch(\thresholdDown, MIDIMKtl('nnkn0'), thresh: 0.5 );
~disp.verbose = true;
)
~disp.remove



// thresh zones
(
~tr =  ~threshZones.( MIDIMKtl('nnkn0'), threshs: [0.2,0.5,0.8] );
~tr.verbose = true;
)
(
~tr =  Dispatch(\threshZones, MIDIMKtl('nnkn0'), nil, nil, [0.2,0.5,0.8] );
~tr.verbose = true;
)
~tr.remove

8.do{ |i|
	3.do{ |j|
		~tr.addToOutput(("sl"++i++"_1_"++j).asSymbol, \sound,{ { SinOsc.ar(rrand(300,3000)) * EnvGen.ar(Env.perc, doneAction:2) }.play });
	}
}

~tr.addToOutput(\sl1_1_2, \blah,{ { SinOsc.ar * EnvGen.ar(Env.perc, doneAction:2) }.play });
~tr.addToOutput(\sl1_1_1, \blah,{ { SinOsc.ar(1200) * EnvGen.ar(Env.perc, doneAction:2) }.play });
~tr.addToOutput(\sl1_1_0, \blah,{ { SinOsc.ar(700) * EnvGen.ar(Env.perc, doneAction:2) }.play });
x = { SinOsc.ar * EnvGen.ar(Env.perc) }.play;
y = { Saw.ar * EnvGen.ar(Env.perc) }.play;
z = { WhiteNoise.ar * EnvGen.ar(Env.perc) }.play;

(
    // strummable guitar
    // use mouse to strum strings
{
	var pitch, mousex, out;
	// e a d g b e
	pitch = [ 52, 57, 62, 67, 71, 76 ];
	mousex = MouseX.kr;
	out = Mix.arFill(pitch.size, { arg i;
		var trigger, pluck, period, string;
		// place trigger points from 0.25 to 0.75
		trigger = HPZ1.kr(mousex > (0.25 + (i * 0.1))).abs;
		pluck = PinkNoise.ar(Decay.kr(trigger, 0.05));
		period = pitch.at(i).midicps.reciprocal;
		string = CombL.ar(pluck, period, period, 4);
		Pan2.ar(string, i * 0.2 - 0.5);
	});
	LPF.ar(out, 12000);
	LeakDC.ar(out);
}.play;
)

// up
(
~tr =  ~up.( MIDIMKtl('nnkn0') );
~tr.verbose = true;
)
~tr.remove


// down
(
~tr =  ~down.( MIDIMKtl('nnkn0'), thresh:0.5 );
~tr.verbose = true;
)

~tr.remove

k.verbose = true
k = MIDIMKtl('nnkn0')