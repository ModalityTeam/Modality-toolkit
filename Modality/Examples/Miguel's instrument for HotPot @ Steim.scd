
(
k = MIDIMKtl('nnkn0');
k.verbose = false;
//one treshold zones dispatch for sliders
~zones =  Dispatch(\threshZones,k, k.elements.select{ |elem| elem.type == \slider }.collect(_.name), nil, [0.2,0.5,0.8] );
~zones.verbose = false;
//one velocity dispatch for buttons
~vel = Dispatch(\velocity,k,[\kn2_1,\kn1_1]);
~vel.verbose = false;
)

(
SynthDef(\ping, {|out = 0,freq = 400, pan = 0.2|
   Out.ar(out, Pan2.ar(0.8*SinOsc.ar(freq) * EnvGen.ar(Env.perc, doneAction:2), pan) )
}).add;

Ndef(\out).ar;


Ndef(\folter, { |revMix = 0, lfMix = 0|
	var in = Ndef(\out).ar;
   	FreeVerb.ar( SinOsc.ar(2+(lfMix*300)).range(0,1)*in, 0.7, Lag.kr(revMix) )
});
~spec = [0,7.0,\lin].asSpec;

Ndef(\folter).play;

9.do{ |i|
	3.do{ |j|
		var r = rrand(50,3000);
		var pan = rrand(-1.0, 1.0);
		~zones.addToOutput(("sl"++i++"_1_"++j).asSymbol, \sound,{ Synth.grain(\ping,[\out,Ndef(\out).bus.index,\freq,r,\pan,pan]) });
	}
};

~vel.addToOutput(\kn1_1,\rev,{ |elem| Ndef(\folter).set(\revMix, ~spec.unmap(elem.value) ) });
~vel.addToOutput(\kn2_1,\rev,{ |elem| Ndef(\folter).set(\lfMix, ~spec.unmap(elem.value) ) });
k.addToOutput(\rew,\killMod, { |elem| if( elem.value == 1.0) { Ndef(\folter).set(\lfMix,0) } });
w = Window.new.front;
w.addFlowLayout;
~sl1 = Slider(w, 150@20 );
~sl2 = Slider(w, 150@20 );
~vel.addToOutput(\kn1_1,\blah,{Ê|elem| { ~sl1.value_(~spec.unmap(elem.value)) }.defer;   });
~vel.addToOutput(\kn2_1,\blah,{ |elem| { ~sl2.value_(~spec.unmap(elem.value)) }.defer;   })
)

//KILL KILL 
(
~zones.removeAllFromOutput;
~vel.removeAllFromOutput;
)

NdefMixer(s)

Ndef(\out).stop