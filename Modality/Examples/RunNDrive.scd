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


MKtl('thrs0').addFuncElem( \wheel, \postme, { |i| [i, i.name, i.value].postln; });
MID
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

//~buffer = Buffer.alloc(s, s.sampleRate * 3, 2 );
~buffer2 = Buffer.alloc(s, s.sampleRate * 0.1, 2 );

//~buffer.free;

Ndef( \writeWaveForm ).set( \buffer, ~buffer2.bufnum);

Ndef( \writeWaveForm, { |speed1=0.5,speed2=0.5,buffer=0,input1=0,input2=0,onoff1=0,onoff2=0| 
	BufWr.kr( In.kr( [input1,input2], 1 ) - 0.5, buffer, 
		LFSaw.ar(BufDur.ir(buffer).reciprocal * [speed1,speed2]/20 ).range(0, BufFrames.ir(buffer) * [ onoff1,onoff2] )
		, 0 ); } );


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

~joysRight.do{ |it,i| it.doDef( \setSpeed, { |v| Ndef('playWaveForm').set( 'speed'++(i+1), v ); } ) };
~joysRight.do{ |it,i| it.doDef( \setSpeedWrite, { |v| Ndef('writeWaveForm').set( 'speed'++(i+1), v ); } ) };
//~joysRight.reset;

~joysX.do{ |it,i| it.doDef( \setSpeed, { |v| Ndef('playWaveForm').set( 'speed'++(i+1), v ); [\setSpeed, i, v ].postln; } ) };
~joysX.do{ |it,i| it.doDef( \setSpeedWrite, { |v| Ndef('writeWaveForm').set( 'speed'++(i+1), v ); [\setSpeedWrite, i, v ].postln; } ) };

Ndef( \playWaveForm ).play;
Ndef( \playWaveForm ).set( \buffer, ~buffer2.bufnum; );


~throttles = MKtl( 'thrs0' ).esFor( ([\R,\L].collect{ |i| [\throt,i ] } ) );
~throttles[0].doDef( \amp, { |val| Ndef( \playWaveForm).set( \amp2, val ); val.postln; })
~throttles[1].doDef( \amp, { |val| Ndef( \playWaveForm).set( \amp1, val ); val.postln; })


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

