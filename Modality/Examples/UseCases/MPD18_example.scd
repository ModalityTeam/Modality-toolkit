//Modality


MIDIIn.connectAll;
MIDIExplorer.start;


MIDIExplorer.stop;


MIDIExplorer.compile


MIDIMKtl.find




m = MIDIMKtl('kmpd180');

/*
m.elements[\slider].action_({ |elem| [\slider, elem.value].postln });
m.elements[\touch].action_({ |elem| });
*/

s.reboot;
SynthDef(\test, {|outBus = 0, freq = 100, amp = 0.5, harm = 100, gated = 0, ffreq = 1|
	Out.ar( outBus, Blip.ar(freq * ffreq, harm) * amp * EnvGen.ar(Env.adsr(0.01, 0.1, 1, 0.1, 1), gated, doneAction:2));
}).add;


x = Synth(\test, [\gated, 1, \freq, rrand(100,200)]);
x.set(\gated, 0);


(

m.elements[\noteOn][0][3].action_({ |elem|
	x = Synth(\test, [\gated, 1, \freq, rrand(100,200)]);
});

m.elements[\noteOff][0][3].action_({ |elem|
	x.set(\gated, 0);
});

m.elements[\slider].action_({ |elem| x.set(\amp, elem.value) });

m.elements[\touch].action_({ |elem| x.set(\ffreq, elem.value * 2 + 1) });
)










