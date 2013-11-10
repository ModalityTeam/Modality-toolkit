// AKAI professional LPD8 Laptop Pad controller specs

/*

(
SynthDef(\test,{
	var x = (SinOsc.ar( \freq.kr(400) ) * \amp.kr(1) ).clip * 0.5 * EnvGen.ar(Env.adsr,\gate.kr(1));
	Out.ar(0,x)
}).add
)

(
x = ();
MIDIMKtl('lpd80').elements.padOn.do{ |el,i|
	el.action_({ |v| x.at(i) ?? _.free; x[i] = Synth(\test,[\amp, v.value*30, \freq, 400+(100*i)]) })
};
MIDIMKtl('lpd80').elements.padOff.do{ |el,i|
	el.action_({ |v| x.at(i).set(\gate,0); x[i] = nil })
};
)
*/

(
kn: (1..8).collect{ |midiNum|
	(\midiMsgType: \cc, \type: \knob, \midiChan: 0, \midiNum: midiNum, \spec: \midiCC)
},
\padOn: (36..43).collect{ |note|
	(\midiMsgType: \noteOn, \type: \pad, \midiChan: 0, \midiNum:  note, \spec: \midiVel)
},
\padOff: (36..43).collect{ |note|
	(\midiMsgType: \noteOff, \type: \pad, \midiChan: 0, \midiNum:  note, \spec: \midiVel)
},
/*
//no pad cc because it uses the same cc numbers as knobs... dugh...
\padCC: ((1..6)++[8,9]).collect{ |cc|
	(\midiMsgType: \cc, \type: \pad, \midiChan: 0, \midiNum:  cc, \spec: \midiCC)
}*/
)
