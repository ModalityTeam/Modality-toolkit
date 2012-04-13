s.boot;
s.makeGui;

MKtl.find;

a = MKtl.new( 'ngms0' );
// when not attached
a = MKtl.make( 'ngms0', \PuzzleSphere );

Ndef( \sine, { Pan2.ar( Mix.new( SinOsc.ar( 
  [
	  \freq1.kr(400).lag(0.3,0.5), 
	  \freq2.kr(400).lag(0.3,0.5), 
	  \freq3.kr(400).lag(0.3,0.5)]  
	* [3/4,1,4/3] ) ) / 10, 0 ) } );
Ndef( \sine ).fadeTime = 0.1;

~buttons = a.elementsOfType( \button ).collect( _.eventSource );
~allTriggers = ~buttons.collect{ |b| b.trigger() };

~allTriggers[ \bt_green ].doDef( \playSynth, { Ndef(\sine).play( fadeTime: 1 ); } );
~allTriggers[ \bt_red ].doDef( \stopSynth, { Ndef(\sine).stop(1); } );

~accs = MKtl( 'ngsm0' ).esFor( ([\X,\Y,\Z].collect{ |i| [\acc,i] } ) );
~accs[0].doDef( \changeFreq, { |c| Ndef( \sine ).set( \freq1, 
	[400,2000,\exponential].asSpec.map( c.value ) ) })
~accs[1].doDef( \changeFreq, { |c| Ndef( \sine ).set( \freq2, 
	[400,2000,\exponential].asSpec.map( c.value ) ) })
~accs[2].doDef( \changeFreq, { |c| Ndef( \sine ).set( \freq3, 
	[400,2000,\exponential].asSpec.map( c.value ) ) })


/*
d = MDispatch.new( \trigger, a, a.elementsOfType( \button ).collect( _.name ) );

d.addFuncElem( \bt_green, \playSynth, { Ndef(\sine).play( fadeTime: 1 ); } );
d.addFuncElem( \bt_red, \stopSynth, { Ndef(\sine).stop(1); } );

a.addFuncElem( \acc_X, \changeFreq, { |c| Ndef( \sine ).set( \freq1, 
      [400,2000,\exponential].asSpec.map( c.value ) ) } );
a.addFuncElem( \acc_Y, \changeFreq, { |c| Ndef( \sine ).set( \freq2, 
      [400,2000,\exponential].asSpec.map( c.value ) ) } );
a.addFuncElem( \acc_Z, \changeFreq, { |c| Ndef( \sine ).set( \freq3, 
      [400,2000,\exponential].asSpec.map( c.value ) ) } );
*/