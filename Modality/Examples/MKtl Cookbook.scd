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
	x.set(\freq,Êelem.value.linexp(0, 1, 40, 1000));
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
	x.set(\preAmp,Êelem.value.linlin(0, 1, 0.5, 15));
})

a.addFuncElem(\sl3_1, \freq, {|elem|
	x.set(\amp,Êelem.value);
})
*/


// Connect a slider on a BCF2000 to the frequency (freq) of my Synth. Setting the value of the Synth updates the (motor-)fader's state.
