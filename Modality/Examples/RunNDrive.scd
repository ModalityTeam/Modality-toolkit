// boot the server:
s.boot;
s.makeGui;
s.meter;


// find all devices that are attached:
MKtl.find;

/// INTROSPECTION:

// all open devices:
MKtl.all;

// all available devices:
MKtl.allAvailable

// all available descriptions:
MKtl.postAllDescriptions;

//MKtl.loadDeviceIndex;
MKtl.allDevDescs;

/// --- end INTROSPECTION

a = MKtl.new( 'thrs0' );
// or shorter:
MKtl( 'thrs0' )

// check whether it works
MKtl('thrs0').verbose_( true );

MKtl('thrs0').verbose_( false );

// the elements the device has:
MKtl('thrs0').elements;

// nicely readable version:
MKtl('thrs0').postDeviceDescription;


// selecting all buttons:
~buttons = MKtl( 'thrs0' ).elementsOfType( \button ).collect( _.eventSource );
~allTriggers = ~buttons.collect{ |b| b.trigger() };

~allTriggers[ \lfTop_5 ].doDef( \test, {} );

//~triggerBut.reset
~allTriggers[\lfTop_5].doDef( \triggerSynth, { |v| Ndef( \ting ).set( \trig, 1, \detune, 0.0 ); v.postln; } );

~allTriggers[\rfTop_6].doDef( \triggerSynth, { |v| Ndef( \ting ).set( \trig, 1, \detune, 0.2 ); v.postln; } );


Ndef( \ting).play;
Ndef( \ting, { Pan2.ar( Mix.new( SinOsc.ar( \freq.kr(600) * LFNoise1.kr( 30, 0.05, 1) * ( 1 + [ 0,\detune.kr(0),\detune2.kr(0)] ) ) * EnvGen.kr( Env.perc, \trig.tr(1), timeScale: \dur.kr(1), doneAction: 0 ) ) / 12 , \pos.kr(0) ) } )

NdefMixer.new(s);


//// writing joystick control to buffer:

~buffer = Buffer.alloc(s, s.sampleRate * 3, 2 );
~buffer2 = Buffer.alloc(s, s.sampleRate * 0.1, 2 );

//~buffer.free;

Ndef( \writeWaveForm, { |speed1=0.5,speed2=0.5,buffer=0,input1=0,input2=0,onoff1=0,onoff2=0| 
	BufWr.kr( In.kr( [input1,input2], 1 ) - 0.5, buffer, 
		LFSaw.ar(BufDur.ir(buffer).reciprocal * [speed1,speed2]/20 ).range(0, BufFrames.ir(buffer) * [ onoff1,onoff2] )
		, 0 ); } );
Ndef( \writeWaveForm ).set( \buffer, ~buffer2.bufnum);


// select joyAxes
//~joys = MKtl( 'thrs0').elementsOfType( \joyAxis );
// only the left:
~joysLeft = MKtl( 'thrs0').esFor( [\X,\Y].collect{ |i| [\joy,\L,i] });
// only the right:
~joysRight = MKtl( 'thrs0').esFor( [\X,\Y].collect{ |i| [\joy,\R,i] })
~joysY = MKtl( \thrs0 ).esFor( [\L,\R].collect{ |i| [\joy,i,\Y ] });
~joysX = MKtl( \thrs0 ).esFor( [\L,\R].collect{ |i| [\joy,i,\X ] });

~joyLeftBuses = ~joysLeft.collect{ |it,i| it.bus.do{ |z| z.postln; Ndef('writeWaveForm').set( 'input'++(i+1), z.at1.index ) } };
~joyLeftBuses.do{ |it| it.free; it.reset };

~joyYBuses = ~joysY.collect{ |it,i| it.bus.do{ |z| z.postln; Ndef('writeWaveForm').set( 'input'++(i+1), z.at1.index ) } };

// playing back the buffer
Ndef( \playWaveForm, { |buffer=0, speed1=0.5, speed2=0.5,amp1=0, amp2=0| [amp1,amp2] * BufRd.ar( 2, buffer, LFSaw.ar(BufDur.ir(buffer).reciprocal * [speed1,speed2] * 2).range(0, BufFrames.ir(buffer)) ); });

~joysRight.do{ |it,i| it.doDef( \setSpeed, { |v| Ndef('playWaveForm').set( 'speed'++(i+1), v ); [\setSpeed, i, v ].postln; } ) };
~joysRight.do{ |it,i| it.doDef( \setSpeedWrite, { |v| Ndef('writeWaveForm').set( 'speed'++(i+1), v ); [\setSpeedWrite, i, v ].postln; } ) };
//~joysRight.reset;

~joysX.do{ |it,i| it.doDef( \setSpeed, { |v| Ndef('playWaveForm').set( 'speed'++(i+1), v ); [\setSpeed, i, v ].postln; } ) };
~joysX.do{ |it,i| it.doDef( \setSpeedWrite, { |v| Ndef('writeWaveForm').set( 'speed'++(i+1), v ); [\setSpeedWrite, i, v ].postln; } ) };

Ndef( \playWaveForm ).play;
Ndef( \playWaveForm ).set( \buffer, ~buffer2.bufnum; );


~throttles = MKtl( 'thrs0' ).esFor( ([\R,\L].collect{ |i| [\throt,i ] } ) );
~throttles[0].doDef( \amp, { |val| Ndef( \playWaveForm).set( \amp2, val ); val.postln; })
~throttles[1].doDef( \amp, { |val| Ndef( \playWaveForm).set( \amp1, val ); val.postln; })


~plotter = Plotter.new( "WaveWorm" );
~buffer2.loadToFloatArray( action: { |vals| {~plotter.value = vals.clump(2).flop; }.defer; } )

(
Tdef( \updateplot, {
	loop {
		~buffer2.loadToFloatArray( action: { |vals| { ~plotter.value = vals.clump(2).flop; }.defer } );
		2.0.wait;
	}
}).play;
)

Tdef( \updatePlot).play;




// selecting the four buttons:
//~buttonsR4.do{ |it| it.reset; };
~buttonsR4 = MKtl( 'thrs0' ).esFor( (1..4).collect{ |i| [\bt,\R,i ] } );
~triggersR4 = ~buttonsR4.collect{ |b| b.trigger() };
~togglesR4 = ~triggersR4.collect{ |b| b.toggle(2) };

~togglesR4[0].doDef( \onoff, { |val| Ndef( \writeWaveForm).set( \onoff1, val ); val.postln; });
~togglesR4[1].doDef( \onoff, { |val| Ndef( \writeWaveForm).set( \onoff2, val ); val.postln; });

~togglesR4[2].doDef( \amp, { });
~togglesR4[3].doDef( \amp, { });

~buttonsTop.do{ |it| it.reset; };
~buttonsTop = [ MKtl( 'thrs0' ).esFor( \lfTop_5 ),  MKtl( 'thrs0' ).esFor( \rfTop_6 ) ];
~triggersTop = ~buttonsTop.collect{ |b| b.trigger() };
~togglesTop = ~triggersTop.collect{ |b| b.toggle(2) };

~togglesTop[0].doDef( \onoff, { |val| Ndef( \writeWaveForm).set( \onoff2, val ); val.postln; });
~togglesTop[1].doDef( \onoff, { |val| Ndef( \writeWaveForm).set( \onoff1, val ); val.postln; });


~buffer2.plot;

~plotter = Plotter.new( "WaveWorm" );
~buffer2.loadToFloatArray( action: { |vals| {~plotter.value = vals.clump(2).flop; }.defer; } )

(
Tdef( \updateplot, {
	loop {
		~buffer2.loadToFloatArray( action: { |vals| { ~plotter.value = vals.clump(2).flop; }.defer } );
		2.0.wait;
	}
}).play;
)

Tdef( \updatePlot).play;



(
y = EventSource();
b = y.bus(s, 900);
//b might be None if the server is not running.
b.do{ |z| x.map(\freq, z.at1) };
)

x.free;

//change freq to 200
y.fire( 100 );

~buttons[ \lfTop_5 ].doDef( \trigChain, { |v| x.fire( v ) } );
~buttons[ \rfTop_6 ].doDef( \trigChain, { |v| x.fire( v ) } );

x.fire( 1 )

x = EventSource();
y = x.toggle(4);
y.doDef( \startSynth2, { |v| Ndef(\ting).play; ("trigger"+v).postln; } );


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

d.mycount.addFuncElem( \rc1, \sine, { |c| if ( c.value == 1 ) { 
Ndef( \ting, { Pan2.ar( Mix.new( SinOsc.ar( \freq.kr(600) * LFNoise1.kr( 30, 0.05, 1) * ( 1 + [ 0,\detune.kr(0),\detune2.kr(0)] ) ) * EnvGen.kr( Env.perc, \trig.tr(1), timeScale: \dur.kr(1), doneAction: 0 ) ) / 12 , \pos.kr(0) ) } ); 
\sine.postln; 
}; }  );
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