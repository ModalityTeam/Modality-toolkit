/*
888~-_   ,e,                              d8           888      
888   \   "   d88~\ 888-~88e    /~~~8e  _d88__  e88~~\ 888-~88e 
888    | 888 C888   888  888b       88b  888   d888    888  888 
888    | 888  Y88b  888  8888  e88~-888  888   8888    888  888 
888   /  888   888D 888  888P C888  888  888   Y888    888  888 
888_-~   888 \_88P  888-_88"   "88_-888  "88_/  "88__/ 888  888 
                    888                                       
*/

MIDIMKtl.find
//average
(
a = MIDIMKtl('bcr0');
// MDispatch
d = MDispatch.new;

d.mapToElem( a, \sl1_1, \myController1 );
d.mapToElem( a, \sl2_1, \myController1 );

d.createOutput(\average);

d.addToProc( \average, { |dis|
	var val = [\sl1_1,\sl2_1].collect{ |it| 
		dis.getInput( \myController1, it ) 
	}.sum;
	dis.setOutput( \average, val/2 );
} );

d.addToOutput(\average,\blah,{ |element| postln("average is "++element.value) })
)

d.remove;
d.verbose = true;


//same ktl, different controls to different sources
(
k = MIDIMKtl('bcr0');
d = MDispatch.new;
~sliders =  d.map(k, k.elementsOfType(\slider).collect(_.name) , \nksliders);
~buttons =  d.map(k, k.elementsOfType(\button).collect(_.name) , \nkbuttons);
)
d.remove

//------- TEMPLATES-----------------------

//paged launchpad
(
~paged = MDispatch.make(\paged,MIDIMKtl('lnch0'),\left,\right,32);
~paged.verbose = true
)
~paged.remove

//paged nanoKontrol
(
MIDIMKtl('bcr0').reset;
~paged = MDispatch.make(\paged,MIDIMKtl('bcr0'),\rew,\fwd);
~paged.verbose = true
)



//velocity
(
MIDIMKtl('bcr0') .reset;
~dis = MDispatch.make(\velocity, MIDIMKtl('bcr0') );
~dis.verbose = true;
)

~dis.addFuncElem(\knF1,\blah,{Ê|elem| elem.value.postln })

(
w = Window.new.front;
~sl = Slider(w, Rect(20, 60, 150, 20));
~dis.addFuncElem(\knF1,\blah,{Ê|elem| { ~sl.value_(elem.value/10) }.defer; x.set(\freq,elem.value*300)  });
~dis.addFuncElem(\knF2,\blah,{ |elem|  x.set(\mod, elem.value)  })
)
~dis.reset
x = { |freq= 400, mod = 1| Saw.ar( Lag.kr(freq,1)+30 ) * SinOsc.ar(Lag.kr(mod) ).range(0.0,1.0)* 0.5 }.play

x = { |freq= 400, mod = 1| Saw.ar( Lag.kr(freq,1)+30 ) * SinOsc.ar(Lag.kr(mod) ).range(0.0,1.0)* 0.5 }.play
Ndef(\y,{ |freq= 400, mod = 1| Saw.ar( Lag.kr(freq,1)+200 ) * SinOsc.ar(Lag.kr(mod,1) ).range(0.0,1.0)* 0.5 }).play
Ndef(\y,{ |freq= 400, mod = 1| Saw.ar( Lag.kr(freq,1)+200 ) * 0.5 })
~dis.addFuncElem(\knF1,\blah,{Ê|elem| { ~sl.value_(elem.value/10) }.defer; Ndef(\y).set(\freq,elem.value*300)  });
~dis.addFuncElem(\knF2,\blah,{ |elem|  Ndef(\y).set(\mod, elem.value*5)  })
x.free
x = { |freq= 400, mod = 1| Saw.ar( LeakDC.kr( Lag.kr(freq)) + 100 ) * SinOsc.ar( LeakDC.kr( Lag.kr(mod), 0.990) + 1 ).range(0.0,1.0)* 0.5 }.play



// paged and then velocity
(
MIDIMKtl('bcr0').reset;
~dis1 = MDispatch.make(\paged, MIDIMKtl('bcr0'),\rew,\fwd,4);
~dis2 = MDispatch.make(\velocity, ~dis1);
~dis2.verbose = true
)
~dis2.recursiveRemove



//merge
//make slider output velocity but keep the rest of controls absolute and merge into just one controller
(
k = MIDIMKtl('bcr0');
k.reset;
~sliders =  MDispatch.make(\velocity,k, k.elementsOfType(\slider).collect(_.name) );

~restOfElems = k.elements.select{ |elem|
	elem.deviceDescription[\type] != \slider
}.collect(_.name);

~result = MDispatch.make(\merge,[[~sliders,nil],[k,~restOfElems]]);
~result.verbose = true;
~sliders.verbose = true;
)
~result.remove // only removes the merge dispatch
~result.recursiveRemove // removes all dispatchs going down the chain

MIDIMKtl('bcr0').verbose = true;

// trigger
(
MIDIMKtl('bcr0').reset;
~disp =  MDispatch.make(\trigger, MIDIMKtl('bcr0') );
~disp.verbose = true;
)
~disp.remove
MIDIMKtl('bcr0').verbose = false



// multiple trig
(
MIDIMKtl('bcr0').reset;
~disp  =  MDispatch.make(\multipleClick,MIDIMKtl('bcr0'));
~disp .verbose = true;
)
~disp .insp
~disp .remove



// thresh
(
MIDIMKtl('bcr0').reset;
~disp =  MDispatch.make(\threshold, MIDIMKtl('bcr0'), thresh: 0.5 );
~disp.verbose = true;
)
~disp.remove

MIDIMKtl('bcr0').verbose = true;

// thresh up
(
MIDIMKtl('bcr0').reset;
~disp =  MDispatch.make(\thresholdUp, MIDIMKtl('bcr0'), thresh: 0.5 );
~disp.verbose = true;
)
~disp.remove



// thresh down
(
MIDIMKtl('bcr0').reset;
~disp =  MDispatch.make(\thresholdDown, MIDIMKtl('bcr0'), thresh: 0.5 );
~disp.verbose = true;
)
~disp.remove



// thresh zones
(
MIDIMKtl('bcr0').reset;
~disp =  MDispatch.make(\threshZones, MIDIMKtl('bcr0'), [0.2,0.5,0.8] );
~disp.verbose = true;
)
~disp.remove


9.do{ |i|
	3.do{ |j|
		var r = rrand(300,3000);
		~disp.addToOutput(("sl"++i++"_1_"++j).asSymbol, \sound,{ { FreeVerb.ar(0.1*SinOsc.ar(r) * EnvGen.ar(Env.perc, doneAction:2),0.5,0.9) }.play });
	}
}


// up
(
MIDIMKtl('bcr0').reset;
~disp =  MDispatch.make(\up, MIDIMKtl('bcr0') );
~disp.verbose = true;
)
~disp.remove

// down
(
k = MIDIMKtl('bcr0').reset;
~disp =  MDispatch.make(\down, k);
~disp.verbose = true;
)

// inRange
(
k = MIDIMKtl('bcr0').reset;
~disp =  MDispatch.make(\inRange, k, nil, nil, [0.5,1.0]);
~disp.verbose = true;
)

// match
(
k = MIDIMKtl('bcr0').reset;
~disp =  MDispatch.make(\match, k, [0.0,1.0]);
~disp.verbose = true;
)

// change
(
k = MIDIMKtl('bcr0').reset;
~disp =  MDispatch.make(\change, k, nil, nil, [0.0,1.0]);
~disp.verbose = true;
)
~disp.remove

// changeDirection
(
k = MIDIMKtl('bcr0').reset;
~disp =  MDispatch.make(\changeDirection, k, nil, nil, [0.0,1.0]);
~disp.verbose = true;
)
~disp.remove

// wait
(
k = MIDIMKtl('bcr0').reset;
~disp =  MDispatch.make(\wait, k);
~disp.verbose = true;
)

// within - only if values come in within n seconds of each other.
(
k = MIDIMKtl('bcr0').reset;
~trigger = MDispatch.make(\trigger,k);
~disp =  MDispatch.make(\within, ~trigger, 1.3);
~disp.verbose = true;
)


// delay - only if values come in within n seconds of each other.
(
k = MIDIMKtl('bcr0').reset;
~disp =  MDispatch.make(\delay, k, 1);
~disp.verbose = true;
)

~disp.remove
~disp.insp

k.verbose = true
k = MIDIMKtl('bcr0')