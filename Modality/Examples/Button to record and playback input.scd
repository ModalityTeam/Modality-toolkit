(
//one controller
k = MKtl.basicNew('fakeBCR2000','BCR2000');

//some control
~knob = k.elements[\knA1].eventSource;
//the button that enters rec/playback mode
~but = k.elements[\btA1].eventSource;

//an event stream that never fires anything
~nothing = EventSource(); 

//record mode is entered when ~but is set to 1
//it is exited when it is set to zero
~array = ~but.flatCollect{ |x| 
	if(x == 1){ 
		"entering record mode".postln;
		//start recording the incoming data.
		//output the latest state of the data array.
		~knob.fold([Process.elapsedTime,List.new], { |state,x|
			[state[0], state[1].add([Process.elapsedTime-state[0],x])]
		}).collect{ |array| array[1] };
	} {
		"entering playback mode".postln;
		~nothing;
	} 
};

// the action is either silence or playback of the recorded run.
~action = ~array.flatCollect{ |array|	
	~but.flatCollect{ |x|
		if( x == 1 ) {
			~nothing
		} {
			EventPlayerES(array);
		}
	}
};
~action.do{ |x| ("Output: "++x).postln };
)

//Testing time !
//start rec mode
~but.fire(1)

// fire some values of knob
~knob.fire(1)
//one at a time
~knob.fire(35)
~knob.fire(28)

//stop rec and start playback
~but.fire(0)