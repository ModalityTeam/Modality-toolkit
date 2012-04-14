s.boot;

MKtl.find;
a = MKtl.new( 'ngms0' );
a.verbose = true;
a.verbose = false;

Ndef( \sine, { Pan2.ar( Mix.new( SinOsc.ar( [\freq1.kr(400).lag(0.3,0.5), \freq2.kr(400).lag(0.3,0.5), \freq3.kr(400).lag(0.3,0.5)] * [3/4,1,4/3] ) )/ 10, \pos.kr(0) ) } );
Ndef( \sine ).fadeTime = 0.1;

d = ();

d.trigger = MDispatch.new( \trigger, a, a.elements.select{ |it| it.type == \button }.collect( _.name ) );

d.trigger.verbose_( true )
d.trigger.verbose_( false )

d.trigger.addToOutput( \btgreen, \playSynth, { Ndef(\sine).play( fadeTime: 1 ); } );
d.trigger.addToOutput( \btred, \stopSynth, { Ndef(\sine).stop(1); } );

a.addToOutput( \accX, \changeFreq, { |c| Ndef( \sine ).set( \freq1, [400,2000,\exponential].asSpec.map( c.value ) ) } );
a.addToOutput( \accY, \changeFreq, { |c| Ndef( \sine ).set( \freq2, [400,2000,\exponential].asSpec.map( c.value ) ) } );
a.addToOutput( \accZ, \changeFreq, { |c| Ndef( \sine ).set( \freq3, [400,2000,\exponential].asSpec.map( c.value ) ) } );

