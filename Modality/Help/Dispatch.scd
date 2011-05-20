/*
888~-_   ,e,                              d8           888      
888   \   "   d88~\ 888-~88e    /~~~8e  _d88__  e88~~\ 888-~88e 
888    | 888 C888   888  888b       88b  888   d888    888  888 
888    | 888  Y88b  888  8888  e88~-888  888   8888    888  888 
888   /  888   888D 888  888P C888  888  888   Y888    888  888 
888_-~   888 \_88P  888-_88"   "88_-888  "88_/  "88__/ 888  888 
                    888                                       
*/


//average
(
a = MIDIMKtl('nnkn0');
// Dispatch
d = Dispatch.new;

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
k = MIDIMKtl('nnkn0');
d = Dispatch.new;
~sliders =  d.map(k, k.elementsOfType(\slider).collect(_.name) , \nksliders);
~buttons =  d.map(k, k.elementsOfType(\button).collect(_.name) , \nkbuttons);
)
d.remove

//------- TEMPLATES-----------------------

//paged launchpad
(
~paged = Dispatch(\paged,MIDIMKtl('lnch0'),\left,\right,32);
~paged.verbose = true
)
~paged.remove

//paged nanoKontrol
(
MIDIMKtl('nnkn0').reset;
~paged = Dispatch(\paged,MIDIMKtl('nnkn0'),\rew,\fwd);
~paged.verbose = true
)



//velocity
(
MIDIMKtl('nnkn0') .reset;
~dis = Dispatch(\velocity, MIDIMKtl('nnkn0') );
~dis.verbose = true;
)

(
w = Window.new.front;
~sl = Slider(w, Rect(20, 60, 150, 20));
~dis.addToOutput(\sl1_1,\blah,{Ê|elem| { ~sl.value_(elem.value/10) }.defer; x.set(\freq,elem.value*300)  });
~dis.addToOutput(\sl2_1,\blah,{ |elem|  x.set(\mod, elem.value)  })
)

x = { |freq= 400, mod = 1| Saw.ar( Lag.kr(freq) ) * SinOsc.ar(Lag.kr(mod) ).range(0.0,1.0)* 0.5 }.play

x = { |freq= 400, mod = 1| Saw.ar( LeakDC.kr( Lag.kr(freq)) + 100 ) * SinOsc.ar( LeakDC.kr( Lag.kr(mod), 0.990) + 1 ).range(0.0,1.0)* 0.5 }.play



// paged and then velocity
(
MIDIMKtl('nnkn0').reset;
~dis1 = Dispatch(\paged, MIDIMKtl('nnkn0'),\rew,\fwd,4);
~dis2 = Dispatch(\velocity, ~dis1);
~dis2.verbose = true
)
~dis2.recursiveRemove



//merge
//make slider output velocity but keep the rest of controls absolute and merge into just one controller
(
k = MIDIMKtl('nnkn0');
k.reset;
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
MIDIMKtl('nnkn0').reset;
~disp =  Dispatch(\trigger, MIDIMKtl('nnkn0') );
~disp.verbose = true;
)
~disp.remove
MIDIMKtl('nnkn0').verbose = false



// multiple trig
(
MIDIMKtl('nnkn0').reset;
~disp  =  Dispatch(\multipleClick,MIDIMKtl('nnkn0'));
~disp .verbose = true;
)
~disp .insp
~disp .remove



// thresh
(
MIDIMKtl('nnkn0').reset;
~disp =  Dispatch(\threshold, MIDIMKtl('nnkn0'), thresh: 0.5 );
~disp.verbose = true;
)
~disp.remove

MIDIMKtl('nnkn0').verbose = true;

// thresh up
(
MIDIMKtl('nnkn0').reset;
~disp =  Dispatch(\thresholdUp, MIDIMKtl('nnkn0'), thresh: 0.5 );
~disp.verbose = true;
)
~disp.remove



// thresh down
(
MIDIMKtl('nnkn0').reset;
~disp =  Dispatch(\thresholdDown, MIDIMKtl('nnkn0'), thresh: 0.5 );
~disp.verbose = true;
)
~disp.remove



// thresh zones
(
MIDIMKtl('nnkn0').reset;
~disp =  Dispatch(\threshZones, MIDIMKtl('nnkn0'), nil, nil, [0.2,0.5,0.8] );
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
MIDIMKtl('nnkn0').reset;
~disp =  Dispatch(\up, MIDIMKtl('nnkn0') );
~disp.verbose = true;
)
~disp.remove

// down
(
k = MIDIMKtl('nnkn0').reset;
~disp =  Dispatch(\down, k);
~disp.verbose = true;
)

// inRange
(
k = MIDIMKtl('nnkn0').reset;
~disp =  Dispatch(\inRange, k, nil, nil, [0.5,1.0]);
~disp.verbose = true;
)

// match
(
k = MIDIMKtl('nnkn0').reset;
~disp =  Dispatch(\match, k, nil, nil, [0.0,1.0]);
~disp.verbose = true;
)

// change
(
k = MIDIMKtl('nnkn0').reset;
~disp =  Dispatch(\change, k, nil, nil, [0.0,1.0]);
~disp.verbose = true;
)
~disp.remove

// changeDirection
(
k = MIDIMKtl('nnkn0').reset;
~disp =  Dispatch(\changeDirection, k, nil, nil, [0.0,1.0]);
~disp.verbose = true;
)
~disp.remove

// wait
(
k = MIDIMKtl('nnkn0').reset;
~disp =  Dispatch(\wait, k, nil, nil, 0.1);
~disp.verbose = true;
)

// within - only if values come in within n seconds of each other.
(
k = MIDIMKtl('nnkn0').reset;
~trigger = Dispatch(\trigger,k);
~disp =  Dispatch(\within, ~trigger, nil, nil, 0.5);
~disp.verbose = true;
)


k.verbose = true
k = MIDIMKtl('nnkn0')