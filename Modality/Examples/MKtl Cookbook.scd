/* 
The MKtl Cookbook

In this document, you can find typical usage scenarios for MKtl. They are based on very concrete tasks like connecting a slider of your MIDI interface to a parameter in your synth.
Their intention is to give unexperienced users a quick starting point (and reference) on how to use MKtl for a given task. 
*/

// == Content ==
// Connect a slider on a NanoKontrol to the frequency (freq) of my Synth.
// Connect a slider on a BCF2000 to the frequency (freq) of my Synth. Setting the value of the Synth updates the (motor-)fader's state.
// Use a button on a launchpad as a toggle-button for muting a Synth
// Use a specific value of an MDispatch directly in a Synth. (kr method)
// Create a custom MDispatch










// Connect a slider on a NanoKontrol to the frequency (freq) of my Synth.

MIDIMKtl.find;
a = MIDIMKtl('nnkn0');

// the synth
SynthDef(\sliderFreq, {|out = 0, freq = 100, fLag = 0.05, amp = 0.1, preAmp = 0.5, aLag = 0.05|
	Out.ar(out, SinOsc.ar(freq.lag(fLag), 0, preAmp.lag(aLag)).tanh * amp.lag(aLag)!2)
}).add;
x = Synth(\sliderFreq);


// select the first slider in the first page
a.addFuncElem(\sl1_1, \freq, {|elem|
	x.set(\freq, elem.value.linexp(0, 1, 40, 1000));
})


x.free;

/* Discussion
The example first searches for all MIDIMktls and assigns the one named 'nnkn0' to the variable "a".
We add a function to the first slider in the first page. It is called 'freq'. When called, the function is passed the MKtlElement responsible for the first slider. Its value slot contains the current value in the range between 0 and 1.
By calling linexp on it, we remap the value to a range between 40 and 1000.
To view all possible element names to which actions can be hooked, call

	a.elementNames

The other parameters of the Synth can be mapped e.g. by these lines:
  
a.addFuncElem(\sl2_1, \freq, {|elem|
	x.set(\preAmp, elem.value.linlin(0, 1, 0.5, 15));
})

a.addFuncElem(\sl3_1, \freq, {|elem|
	x.set(\amp, elem.value);
})
*/


// Connect a slider on a BCF2000 to the frequency (freq) of my Synth. Setting the value of the Synth updates the (motor-)fader's state.


//---****----- DISPATCH -----*****------

//note: change the key names and controller names to match names existing in your controller

//1 - create a dispatch that inverts the values, i.e. if the incoming value is 0 it becomes 1 and if it's 1 becomes 0.

(
//change 'nnkn0' to the MKtl shortname of your controller
MIDIMKtl.find;
k = MKtl('nnkn0');
k.reset;
k.verbose = false;

//connect automatically adds all elements in k and also creates outputs with the same name 
//as the inputs.
~dis = MDispatch().connect(k);
//only trigger actions if value is 1    
~dis.addToProc( \trigger, { |dis|
     var in = ~changedIn;
     //invert value
	dis.setOutput(in[\key], 1 - in[\val])
});
//set it to true to check if it's working;
~dis.verbose = false;
//now do something when the dispatch outputs data
// change the key to a key that exists in your controller
~dis.addFuncElem(\sl1_1,\nameOfMyAction,{ |x| ("ping: "++x.value).postln })
//giving a name to the action allows to later remove that action:
//d.removeFuncElem(\knG1,\nameOfMyAction)
)

//match multiple keys - could be slow !
~dis.addFuncElem('sl*',\nameOfMyAction,{ |x| ("ping: "++x.name++" "++x.value).postln }, match:true)
//note that since we used the same name for the action, the code above replaced the previous action for knG1
//also if you modify the code above in the line above and run that line again you will replace the actions
//without need to remove the old actions.

// remove dispatch actions from the ktl
~disp.remove


//2 - calculate the average of two controls

(
MIDIMKtl.find;
k = MKtl('nnkn0');
//make sure the Ktl doesn't have any functions or dispatchs attached.
k.reset;
d = MDispatch.new;

//only listen to the input from these specific knobs:
d.mapToElem( k, \sl1_1, \myController1 );
d.mapToElem( k, \sl2_1, \myController1 );
/*
myController1 is the name that we are giving to the source, which in this case is the BCR2000 controller. This allows to change the source later but keep the same functionality, that is we could later do d.changeSource(\mycontroller1,'bcr1') and it would listen from a second BCR2000 controller instead of the original one.
*/

//in the example above the outputs were automatically created using MDispatch:connect
//with the same name as the inputs. In this case we want to create just one output with a specific name:
d.createOutput(\average);

d.addToProc( \average, { |dis|
        var val = [\sl1_1,\sl2_1].collect{ |key| 
                dis.getInput( \myController1, key ) 
        }.sum;
        dis.setOutput( \average, val/2 );
} );

d.addFuncElem(\average,\blah,{ |element| postln("average is "++element.value) })
)

//3 - chain dispatchs

/*
Dispatchs behave exactly as a Ktl, that is they mimc a real device, therefore they can be chained using
connect or map
*/

(
MIDIMKtl.find;
k = MKtl('nnkn0');
k.reset;
//one dispatch for invert
~dis1 = MDispatch().connect(k);
~dis1.addToProc( \invert, { |dis|
     var in = ~changedIn;
	dis.setOutput(in[\key], 1 - in[\val])
});
//one dispatch to quantize
~dis2 = MDispatch().connect(~dis1);
~dis2.addToProc( \invert, { |dis|
     var in = ~changedIn;
	dis.setOutput(in[\key], in[\val].round(0.2) )
});
~dis2.verbose = true
)

//4 - use templates

/*
The Modality quark provides some built in dispatchs. They are stored in the DispatchTemplates folder. It's possible to list the available 
templates by doing
*/
MDispatch.availableTemplates

(
MIDIMKtl.find;
k = MKtl('nnkn0').reset;
//create a threshZones dispatch, the source is k and [0.2,0.5,0.8] are the threshold points. When the controller passes these points will trigger an action.
~disp =  MDispatch.make(\threshZones, k, [0.2,0.5,0.8] );
~disp.verbose = true;

~disp.addFuncElem('*', \sound,{ 
	{ FreeVerb.ar(0.1*SinOsc.ar(rrand(300,3000)) * EnvGen.ar(Env.perc, doneAction:2),0.5,0.9) }.play 
},match:true);

)


//5 - chain templates

(
MIDIMKtl.find;
k = MKtl('nnkn0').reset;
~disp1 =  MDispatch.make(\up, k );
~disp2 =  MDispatch.make(\velocity, ~disp1 );
~disp2.verbose = true;
)

~disp2.remove // only removes the merge dispatch
~disp2.recursiveRemove // removes all dispatchs going down the chain


//6 - split and merge streams

(
MIDIMKtl.find;
k = MKtl('nnkn0').reset;
/*The dispatch template's 'make' function first arguments usually are:
	source -> the MKtl or MDispatch.
	elemKeys -> an array with the keys to map from the source. All other elements whose keys are not in this array are ignored.
	sourceKey -> the name to give to this source (see 2)
	
  We select only the elements of type slider by providing an array with all such elements and create a velocity dispatch
*/
~sliders =  MDispatch.make(\velocity,k, k.elementsOfType(\slider).collect(_.name) );
/*the merge dispatch just takes the input from multiple sources and outputs it without modification.
  it takes as arguments an array with elements [source,elements]. if elements is nil, all elements are imported from that source.
  By using the merge dispatch we have a result dispatch that behaves as if it was just one controller although we have now modified
  the behaviour of some controls.
*/
~result = MDispatch.make(\merge,[ [~sliders, nil], [k, k.elementsNotOfType(\slider).collect(_.name) ] ]);
~result.verbose = true;
)
~result.remove // only removes the merge dispatch
~result.recursiveRemove // removes all dispatchs going down the chain



