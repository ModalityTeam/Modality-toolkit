s.boot;

MKtl.find;
a = MKtl.new( 'thrs0' );

// check whether it works
a.verbose_( true );
a.verbose_( false );

d = ();

d.trigger = MDispatch.make( \trigger, a, a.elements.select{ |it| it.type == \button }.collect( _.name ) );
d.trigger.verbose_( false )

d.trigger.envir
d.trigger.addToProc( \test, { |d,e| d.postln; ~changedIn.postln })

d.trigger.addFuncElem( \bt1r, \playSynth, { Ndef(\ting).set( \trig, 1, \freq, 600 ) } );
d.trigger.addFuncElem( \bt2r, \playSynth, { Ndef(\ting).set( \trig, 1, \freq, 800 ) } );
d.trigger.addFuncElem( \bt3r, \playSynth, { Ndef(\ting).set( \trig, 1, \freq, 1000 ) } );
d.trigger.addFuncElem( \bt4r, \playSynth, { Ndef(\ting).set( \trig, 1, \freq, 1200 ) } );

s.meter;
NdefMixer.new(s)

d.mycount = MDispatch.new(\mycount);
d.mycount.envir[ \mycount_rfTop6 ] = 0;
d.mycount.envir[ \mycount_lfTop5 ] = 0;
d.mycount.envir[ \maxcount ] = 3;

d.mycount.mapToElem( d.trigger, \rfTop6 );
d.mycount.mapToElem( d.trigger, \lfTop5 );

[\rc1,\rc2,\rc3,\lc1,\lc2,\lc3].do{ |it| d.mycount.addFuncElem( it ) };

d.mycount.addToProc( \counting, {

d.mycount.addToProc( \counting, { |d,e| var mykey = (\mycount_ ++ d.changedIn.key).asSymbol; e[mykey] = (e[mykey] + 1).wrap(0,e[\maxcount] ); } );

d.mycount.addToProc( \countR1, { |d,e| if ( ~changedIn.key == \rfTop6 ) { if ( e[\mycount_rfTop6] == 1 ){ d.setOutput( \rc1, 1 ) }{ d.setOutput( \rc1, 0 ) } } } );
d.mycount.addToProc( \countR2, { |d,e| if ( ~changedIn.key == \rfTop6 ) { if ( e[\mycount_rfTop6] == 2 ){ d.setOutput( \rc2, 1 ) }{ d.setOutput( \rc2, 0 ) } } } );
d.mycount.addToProc( \countR3, { |d,e| if ( ~changedIn.key == \rfTop6 ) { if ( e[\mycount_rfTop6] == 3 ){ d.setOutput( \rc3, 1 ) }{ d.setOutput( \rc3, 0 ) } } } );
d.mycount.addToProc( \countL1, { |d,e| if ( ~changedIn.key == \lfTop5 ) { if ( e[\mycount_lfTop5] == 1 ){ d.setOutput( \lc1, 1 ) }{ d.setOutput( \lc1, 0 ) } } } );
d.mycount.addToProc( \countL2, { |d,e| if ( ~changedIn.key == \lfTop5 ) { if ( e[\mycount_lfTop5] == 2 ){ d.setOutput( \lc2, 1 ) }{ d.setOutput( \lc2, 0 ) } } } );
d.mycount.addToProc( \countL3, { |d,e| if ( ~changedIn.key == \lfTop5 ) { if ( e[\mycount_lfTop5] == 3 ){ d.setOutput( \lc3, 1 ) }{ d.setOutput( \lc3, 0 ) } } } );

d.countTrigger = MDispatch.make( \trigger, d.mycount, d.mycount.elements.collect( _.name ) );

a.verbose = false;
d.mycount.verbose = false;

d.mycount.addFuncElem( \rc1, \sine, { |c| if ( c.value == 1 ) { Ndef( \ting, { Pan2.ar( Mix.new( SinOsc.ar( \freq.kr(600) * LFNoise1.kr( 30, 0.05, 1) * ( 1 + [ 0,\detune.kr(0),\detune2.kr(0)] ) ) * EnvGen.kr( Env.perc, \trig.tr(1), timeScale: \dur.kr(1), doneAction: 0 ) ) / 12 , \pos.kr(0) ) } ); \sine.postln; }; }  );
d.mycount.addFuncElem( \rc2, \noise, { |c| if (c.value == 1){ Ndef( \ting, { Pan2.ar( Mix.new( BPF.ar( WhiteNoise.ar(1), \freq.kr(600) * ( 1 + [ 0,\detune.kr(0),\detune2.kr(0)] ), 0.1 ) * 2 * EnvGen.kr( Env.perc, \trig.tr(1), timeScale: \dur.kr(1), doneAction: 0 ) ) / 3 , \pos.kr(0) ) } ); \noise.postln; } } );
d.mycount.addFuncElem( \rc3, \resonz, { |c| if (c.value == 1){ 
	Ndef( \ting, { Pan2.ar( Mix.new( Resonz.ar( Dust.ar(\dust.kr(5) ), \freq.kr(600) * 10 * ( 1 + [ 0,\detune.kr(0),\detune2.kr(0)] ), 0.1 ) * \mul.kr(100) * EnvGen.kr( Env.perc, \trig.tr(1), timeScale: \dur.kr(1), doneAction: 0 ) ) / 3 , \pos.kr(0) ); } ); \resonz.postln;
} } );


d.mycount.addToOutput( \lc1, \sine, { |c| if ( c.value == 1 ) { Ndef( \ting, { Pan2.ar( Mix.new( PMOsc.ar( \freq.kr(600) * ( 1 + (2*[ 0,\detune.kr(0),\detune2.kr(0)]) ) /2 , \modfreq.kr(20), \pmindex.kr(2) ) * EnvGen.kr( Env.perc, \trig.tr(1), timeScale: \dur.kr(1), doneAction: 0 ) ) / 20 , \pos.kr(0) ) } ); \fmsine.postln; }; }  );
d.mycount.addToOutput( \lc2, \noise, { |c| if (c.value == 1){ Ndef( \ting, { Pan2.ar( Mix.new( BPF.ar( WhiteNoise.ar(1), \freq.kr(200) * ( 1 + [ 0,\detune.kr(0),\detune2.kr(0)] ), 0.05 ) * \mul.kr(2) * EnvGen.kr( Env.sine, \trig.tr(1), timeScale: \dur.kr(1) * 2, doneAction: 0 ) ) / 3 , \pos.kr(0) ) } ); \noiseL.postln; } } );
d.mycount.addToOutput( \lc3, \resonz, { |c| if (c.value == 1){ 
	Ndef( \ting, { Pan2.ar( Mix.new( Resonz.ar( Dust.ar(\dust.kr(30) ), \freq.kr(600) * 5 * ( 1 + [ 0,\detune.kr(0),\detune2.kr(0)] ), 0.1 ) * \mul.kr(50) * EnvGen.kr( Env.perc, \trig.tr(1), timeScale: \dur.kr(1), doneAction: 0 ) ) / 3 , \pos.kr(0) ); } ); \resonz2.postln;
} } );


a.verbose = true;

a.addToOutput( \joyLX, \pan, { |c| Ndef( \ting ).set( \pos, [-1,1].asSpec.map( c.value ) ) } );
a.addToOutput( \joyLY, \dur, { |c| Ndef( \ting ).set( \dur, [0.5,3].asSpec.map( c.value ) ) } );

s.meter;


d.midcount = Dispatch.new(\midcount);
d.midcount.envir[ \midcount ] = 0;
d.midcount.envir[ \maxcount ] = 1;
d.midcount.envir[ \midcount2 ] = 0;
d.midcount.envir[ \maxcount2 ] = 1;

//d.midcount.envir

d.midcount.mapToElem( d.trigger, \midR10 );
d.midcount.mapToElem( d.trigger, \midL9 );

//a.verbose = true

d.midcount.createOutput( \midR10 );
d.midcount.createOutput( \midL9 );

d.midcount.addToProc( \counting, { |d,e| if (d.changedIn.key == \midR10 ){ e[\midcount] = (e[\midcount] + 1).wrap(0,e[\maxcount] ); } } );
d.midcount.addToProc( \counting2, { |d,e| if (d.changedIn.key == \midL9 ){ e[\midcount2] = (e[\midcount2] + 1).wrap(0,e[\maxcount2] ); } } );

d.midcount.addToProc( \countMID, { |d,e| if ( d.changedIn.key == \midR10 ) { if ( e[\midcount] == 1 ){ d.setOutput( \midR10, 1 ) }{ d.setOutput( \midR10, 0 ) } } } );
d.midcount.addToProc( \countMID2, { |d,e| if ( d.changedIn.key == \midL9 ) { if ( e[\midcount2] == 1 ){ d.setOutput( \midL9, 1 ) }{ d.setOutput( \midL9, 0 ) } } } );

//d.midcount.verbose = false;

//d.midcount.funcChain

d.midcount.addToOutput( \midR10, \runRecord, { |c,v| Ndef( \record ).set( \run, c.value ); Ndef( \record2 ).set( \run, c.value ); ("recording"+c.value).postln; }; );
d.midcount.addToOutput( \midL9, \runPlay, { |c,v| if( c.value == 1 ) { Ndef( \play ).play; Ndef( \play2).play; }{ Ndef( \play ).stop; Ndef(\play2).stop }; ("playing"+c.value).postln; }; );

//d.midcount.elements['midR10'].dump

//d.trigger.addToOutput( \midR10, \freeAll, { s.freeAll; } );

a.addToOutput( \compassY, \detune, { |c,v| Ndef(\ting).set( \detune, [-0.5,0.5].asSpec.map( c.value ) )} );
a.addToOutput( \compassX, \detune, { |c,v| Ndef(\ting).set( \detune2, [-0.25,0.25].asSpec.map( c.value ) )} );

a.addToOutput( \throtL, \playSpeed, { |c,v| Ndef(\play).set( \rate, [0.25,2].asSpec.map( c.value ) )} );
a.addToOutput( \throtR, \playSpeed, { |c,v| Ndef(\play2).set( \rate, [0.25,2].asSpec.map( c.value ) )} );

a.addToOutput( \wheel, \playSpeed, { |c,v| Ndef(\play2).set( \rate2, [-2,2.0].asSpec.map( c.value ) ); Ndef(\play).set( \rate2, [-2,2.0].asSpec.map( c.value ) ); } );



Ndef( \ting, { Pan2.ar( Mix.new( SinOsc.ar( \freq.kr(600) * ( 1 + [ 0,\detune.kr(0),\detune2.kr(0)] ) ) * EnvGen.kr( Env.perc, \trig.tr(1), timeScale: \dur.kr(1), doneAction: 0 ) ) / 3 , \pos.kr(0) ) } );
Ndef( \ting ).play;

s.meter;

b = Buffer.alloc( s, s.sampleRate * 5, 2 );
c = Buffer.alloc( s, s.sampleRate * 3, 2 );



Ndef( \record, { RecordBuf.ar( In.ar( 0, 2), b, 0, \recLevel.kr(0.5), \preLevel.kr(0.5), \run.kr(1) ) } );
Ndef( \record2, { RecordBuf.ar( In.ar( 0, 2), c, 0, \recLevel.kr(0.5), \preLevel.kr(0.5), \run.kr(1) ) } );


Ndef( \play, { PlayBuf.ar( 2, b, \rate.kr(1) * \rate2.kr(1), loop: 1 )} );
Ndef( \play).play;

Ndef( \play2, { PlayBuf.ar( 2, c, \rate.kr(1) * \rate2.kr(1), loop: 1 )} );
Ndef( \play2).play;

Spec.add( \rate2, [-2,2].asSpec );

d.trigger.addToOutput( \lfBot7, \changeBuf, { Ndef(\record).set( \run, 1 ); "start record 1".postln; });
d.trigger.addToOutput( \rfBot8, \changeBuf, { Ndef(\record2 ).set(\run, 1 ); "start record 2".postln;  });

NdefMixer.new(s)