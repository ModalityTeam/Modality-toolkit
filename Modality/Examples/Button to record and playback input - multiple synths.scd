//record and playback 
//press the button to alternate between record and play mode
//move knob while in rec mode
(
//one controller
//k = MKtl.basicNew('fakeBCR2000','BCR2000');
k.reset;
k = MIDIMKtl('bcr20000');
//some control
~knobs = k.esFor( (1..3).collect{ |i| [\kn,1,i] });
//the button that enters rec/playback mode
~buts = k.esFor( (1..3).collect{ |i| [\bt,1,i] });

//an event stream that never fires anything
~nothing = NothingES(); 

//record mode is entered when ~but is set to 1
//it is exited when it is set to zero
~arrays = [~buts, ~knobs].flopWith{ |but,knob|
	but.flatCollect{ |x| 
		if(x == 1){ 
			"entering record mode".postln;
			//start recording the incoming data.
			//output the latest state of the data array.
			knob.inject([Process.elapsedTime,List.new], { |state,x|
				var recStartTime, listOfTimeDeltasValues, delta;
				//calculate time of this event counting since recording started.
				#recStartTime, listOfTimeDeltasValues = state;
				delta = Process.elapsedTime - recStartTime;
				[recStartTime, listOfTimeDeltasValues.add([delta,x])]
				//discard recor start time
			}).collect{ |array| array[1] };
		} {
			"entering playback mode".postln;
			~nothing;
		} 
	}
};

// the action is either silence or playback of the recorded run.
~results = [~arrays,~buts, ~knobs].flopWith{ |array,but,knob|
	 array.flatCollect{ |array|	
		but.flatCollect{ |x|
			if( x == 1 ) {
				~nothing
			} {
				EventPlayerES(array);
			}
		}
	} | but.flatCollect{ |x|
		if( x == 1 ) {
			knob
		} {
			~nothing;
		}
	}
};

[~results,~synths].flopWith{ |result,synth|
	result.do{ |v| synth.set(\freq, v.linexp(0.0,1.0,200,4000.0) ) };
};
	
~synths = [{
Ê Ê MoogFF.ar(
Ê Ê Ê Ê Pulse.ar([40,121], [0.3,0.7]),
Ê Ê Ê Ê \freq.kr(400,1),
Ê Ê Ê Ê	0.83 * 4)
}.play, 
{ MoogFF.ar(
Ê Ê Ê Ê WhiteNoise.ar,
Ê Ê Ê Ê \freq.kr(400,1),
Ê Ê Ê Ê	0.83 * 4)
}.play,
{ MoogFF.ar(
Ê Ê Ê Ê Saw.ar([60,140]),
Ê Ê Ê Ê \freq.kr(400,1),
Ê Ê Ê Ê	0.83 * 4)
}.play];

)
