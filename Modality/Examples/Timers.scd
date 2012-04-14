//using timers:

(
// args delta (s), maxTime(s)
// will output every delta seconds until maxTime is reached.
x = TimerES(1,10);
x.do({ |x| ("received: "++x).postln});
)






//Output the last value every second:
(
MIDIMKtl.find;
k = MKtl('bcr20000');
k.reset;
x = k.esFor(\kn_7_1);
y = 	x.collect{ |v| ("from knob: "++v) } | 
		x.flatCollect{ |v| TimerES(1).collect{ "from timer	: "++v }Ê}; 
y.do( postln(_) )
)

This works because Timer will only output 1 second in the future, so if you the knob values arrive sooner then 1 second the timer is destroyed without outputing anything and a new timer is created.








(
SynthDef(\singrain, { |freq = 440, amp = 0.2, sustain = 1|
Ê Ê Ê Ê var sig;
Ê Ê Ê Ê sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.perc(0.01, sustain), doneAction: 2);
Ê Ê Ê Ê Out.ar(0, sig ! 2); Ê Ê // sig ! 2 is the same as [sig, sig]
}).add;
)



//plays synth half-second after you stop movingstop moving knob:

(
k = MIDIMKtl('bcr20000'); //change to your own controller
k.reset; //reset controller to a clean state
~knob = k.esFor(\kn_7_1); //change to your own controller
~timer = WaitES(0.1,0.0);

~timer.do{ "".postln; "timer Bang".postln };

~result = ~knob.flatCollect{ WaitES(1.0, 0.0) };

~result.do{
		var newFreq = exprand(200.0,600.0);
		postln("freq: "++newFreq );
		Synth(\singrain, [
			freq: newFreq,
			amp: rrand(0.1, 0.5),
			sustain: rrand(1, 3) * 0.1
		]);
};

//gui for visualization
~guiKnob = Knob();
w = Window(bounds:Rect(200,200,200,100)).layout_(
	 HLayout( ~guiKnob )
).front;
~knob.connect(~guiKnob);
)










//Decay
(
var withGui = true;

//one controller
MIDIMKtl.find;
//with nanokontrol
k = MKtl('bcr20000');
k.reset;
~synths !? { |x| x.do(_.free) };
/*
change to this if you don't have a nanokontrol
k =  MKtl.make('nnkn0', 'nanoKONTROL'); 
*/

//some controls that control some synthesis process
~knobs = k.esFor((1..8).collect{ |i| [\kn,7,i] });

~leak = ~knobs.collect{ |es|
	es | es.flatCollect{ |v|
			TimerES(0.01,10000).inject(v,{|state,x| (state - 0.004).max(0) })
	}
};

~synths = ~leak.collect{ |x,i|
	var s = { Pan2.ar( SinOsc.ar(\freq.kr(200,1))*0.1, \pan.kr(i.linlin(0,~accum.size-1,-1.0,1.0) ) ) }.play;
	x.do{ |v| s.set(\freq, v.linlin(0.0, 1.0, 100,1000.0)) };
	s
};

if( withGui ) {
w !? _.close;
~guiKnobs = ~knobs.collect{ Knob() };

w = Window(bounds:Rect(200,200,200,100)).layout_( HLayout( *~guiKnobs ) ).front;
[~leak, ~guiKnobs].flopWith{ |es,gui|
	es.do{ |v| defer{ gui.value_( v.linlin(0.0,1.0,0.0,1.0) )  }}
};
}

)





//knob 1 and knob 2 will control the range of the frequency of synth
//the synth is triggered every second
(
k = MIDIMKtl('bcr20000'); //change to your own controller
k.reset; //reset controller to a clean state
~knob1 = k.signalFor(\kn_7_1); //change to your own controller
~knob2 = k.signalFor(\kn_7_2); //change to your own controller
~timer = TimerES(0.1,10000);

~timer.do{ "".postln; "timer Bang".postln };

~pair = [_,_] <%> ~knob1 <*> ~knob2;

~result = ~pair.changes.flatCollect{ |array|
	~timer.collect{ array }
};

~result.do{Ê|array|
		var x  = array[0].linexp(0.0,1.0,200.0,800.0);
		var y = array[1].linexp(0.0,1.0,200.0,800.0);
		var newFreq = exprand(x,y);
		postln("min: "++min(x,y) );
		postln("max: "++max(x,y) );
		postln("freq: "++newFreq );
		Synth(\singrain, [
			freq: newFreq,
			amp: rrand(0.1, 0.5),
			sustain: rrand(1, 3) * 0.1
		]);
};

//gui for visualization
~guiKnob1 = Knob();
~guiKnob2 = Knob();
w = Window(bounds:Rect(200,200,200,100)).layout_(
	 HLayout( ~guiKnob1, ~guiKnob2 )
).front;
~knob1.connect(~guiKnob1);
~knob2.connect(~guiKnob2);
)
