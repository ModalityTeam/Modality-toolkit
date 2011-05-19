q = ();

q.lnch = MIDIMKtl(\lnch0)

q.lnhout = LaunchpadOut(q.lnch)

q.lnhout.reset

(
(0..7).do{|j|
[0, 2, 4, 6].do{|i|
	q.lnhout.setColor([j, i], \yellow);
	q.lnhout.setColor([j, i+1], \red)
}}
)
MIDIMKtl(\lnch0).verbose = true
s.boot;

MIDIMKtl(\lnch0)[\bu0].value.asArray.size

{WhiteNoise.ar * MIDIMKtl(\lnch0)[\bu0].kr / 127}.play


(
Ndef(\murder, {
	var freq;
	var ctrls = (0..63).collect{|idx| ("bu"++idx).asSymbol}.collect{|elem|
		MIDIMKtl(\lnch0)[elem].kr/127
	}.lag(10);
	
	(ctrls.size.collect{|i|
		freq = 64 + i;
		LPF.ar(SinOsc.ar([1, 0.5] * freq, 0, AmpComp.ir(freq)).sum + WhiteNoise.ar, i.linexp(0, 63, 50, 20000))	} * ctrls).clump(2).sum.tanh ;
})	 
)
Ndef(\murder).numChannels
.play

0.linexp(0, 7, 1000, 100000)