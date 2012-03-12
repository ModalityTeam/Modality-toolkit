(
//one controller
k = MKtl.basicNew('fakeBCR2000','BCR2000');
//some controls that control some synthesis process
~knob1 = k.elements[\knA1].eventSource;
~knob2 = k.elements[\knA2].eventSource;
~knob3 = k.elements[\knA3].eventSource;
~knob4 = k.elements[\knA4].eventSource;
~knobs = [~knob1, ~knob2, ~knob3, ~knob4];

//the button that enters selection mode
~but = k.elements[\btA1].eventSource; 

//selection mode is entered when ~but is set to 1
//it is exited when two different knobs are moved

~exchange = ~but.flatCollect{ |y|
	var selection;
	//enter selection mode
	if( y == 1) {
		//two different knobs are moved
		selection = ~knobs.collect{ |x,i| x.collect{i} }.reduce('|')
		.fold([],{ |state,x|
			("knob "++x++" selected for exchange").postln;
			state++[x]				
		}).select{ |x| x.size == 2};
		selection.flatCollect{ |x|
			if(x.size > 2) {
				~nothing
			} {
				selection
			}
		}
	} {
		"exchange going silent".postln;	
		~nothing	
	}
};
~exchange.do{ |x| ("Exchanging knob connected to action "++x[0]++" with knob connected to action "++x[1]).postln };

//index i of this array is the knob that will go into action i;
~startState = [0,1,2,3]; //which knobs go to which action

//~exchange = EventSource();
~sel = ~exchange.fold(~startState, { |state, exchangePair|
		var indexA = state.indexOf(exchangePair[0]);
		var indexB = state.indexOf(exchangePair[1]);	
		("Exchange pair: "++exchangePair).postln;	
		state.swap(indexA, indexB);	
});

//~sel = EventSource();

f = { |i| { |state|
	switch(state[i])
		{0}{~knob1}
		{1}{~knob2}
		{2}{~knob3}
		{3}{~knob4}	
	
} };

//connect the synthesis processes to the actions
g = { |i| (~but | ~exchange).flatCollect({ |x|
	if(x == 1) {
		~nothing
	} {
		~sel.flatCollect(f.(i),~knobs[~selSignal.now[i]]);
	} });
};
~selSignal = ~sel.hold([0,1,2,3]);
~action1 = g.(0);
~action2 = g.(1);
~action3 = g.(2);
~action4 = g.(3);
/*
~action1 = ~sel.flatCollect(f.(0),~knob1);
~action2 = ~sel.flatCollect(f.(1),~knob2);
~action3 = ~sel.flatCollect(f.(2),~knob3);
~action4 = ~sel.flatCollect(f.(3),~knob4);
*/
//between receiving 1 on ~but and ~receiving a zero, or receiving something from ~exchange do nothing.
/*
last = 1 do nothing
last = 0 or last.size == 2 fire

*/

~action1.do{ |x| ("action 1 got a "++x).postln };
~action2.do{ |x| ("action 2 got a "++x).postln };
~action3.do{ |x| ("action 3 got a "++x).postln };
~action4.do{ |x| ("action 4 got a "++x).postln };
)

//test it
// fire the number corresponding to the knob number, just so we can see which knob is controlling which action.
~knob1.fire(1);
~knob2.fire(2);
~knob3.fire(3);
~knob4.fire(4);

//start exchange mode
~but.fire(1)

//stop exchange mode
~but.fire(0)

/*instructions

enter exchange mode '~but.fire(1)', fire two of the knobs,  this will exchange their actions.
To existe exchange mode without changing actions do '~but.fire(0)'.
*/




