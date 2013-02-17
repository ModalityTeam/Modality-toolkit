
//MODALITY : FUNCTIONAL REACTIVE PROGRAMMING
//based on reactive-core scala library:
//http://www.reactive-web.co.cc/core/EventStream

/*
4 core functions: 

collect
select
fold
flatCollect

*/


//EventSource Version
/*
take a knob and post it's value
*/
(
k = MKtl.basicNew('fakeBCR2000','BCR2000');
~knob = k.elements[\knA1].eventSource;
~knob.do{ |x| ("A knob has spit out a value: "++x).postln }
)
(
k.setRawValueAt(\knA1, 127);
k.elements.at(\knA1).doAction
) 

//collect

//take a knob, multiply value by 100 and post the value

(
k = MKtl.basicNew('fakeBCR2000','BCR2000');
~knob = k.elements[\knA1].eventSource.collect(_*100);
~knob.do{ |x| ("A knob has spit out a value: "++x).postln }
)
(
k.setRawValueAt(\knA1, 127);
k.elements.at(\knA1).doAction
) 


//select
//output only values that match condition
(
k = MKtl.basicNew('fakeBCR2000','BCR2000');
~knob = k.elements[\knA1].eventSource.select(_<0.5);
~knob.do{ |x| ("A knob has spit out a value: "++x).postln }
)
(
k.setRawValueAt(\knA1, 127);
k.elements.at(\knA1).doAction;
k.setRawValueAt(\knA1, 0);
k.elements.at(\knA1).doAction;
) 

//takeWhile
//will only output while the condition is true, after that the eventStream is forever gone !
(
k = MKtl.basicNew('fakeBCR2000','BCR2000');
~knob = k.elements[\knA1].eventSource.takeWhile(_<0.5);
~knob.do{ |x| ("A knob has spit out a value: "++x).postln }
)
(
k.setRawValueAt(\knA1, 0);
k.elements.at(\knA1).doAction;
k.setRawValueAt(\knA1, 127);
k.elements.at(\knA1).doAction;
k.setRawValueAt(\knA1, 0);
k.elements.at(\knA1).doAction;
) 

//flatMap
//event routing
//if button is at 0 then outputs values from knob1
//if button is at 1 then outputs values from knob2
(
k = MKtl.basicNew('fakeBCR2000','BCR2000');
~knob1 = k.elements[\knA1].eventSource;
~knob2 = k.elements[\knA2].eventSource;
~button = k.elements[\btA1].eventSource; 
~result = ~button.flatCollect{ |x|
	if(x == 0) {
		~knob1
	} {
		~knob2
	}
};	
~result.do{ |x| ("A knob has spit out a value: "++x).postln }
)

(
"button at 0".postln;
k.setRawValueAt(\btA1, 0);
k.elements.at(\btA1).doAction;
"only the value from knob1 goes through:".postln;
k.setRawValueAt(\knA1, 127);
k.elements.at(\knA1).doAction;
k.setRawValueAt(\knA2, 0);
k.elements.at(\knA2).doAction;
"change button state to 1".postln;
k.setRawValueAt(\btA1, 1);
k.elements.at(\btA1).doAction;
"only the value from knob2 goes through".postln;
k.setRawValueAt(\knA1, 127);
k.elements.at(\knA1).doAction;
k.setRawValueAt(\knA2, 0);
k.elements.at(\knA2).doAction;
) 

/*
 this basically enables what Jeff wanted, here the result eventsource could be plugged to some
 synth, and this allows to change the action for instance from knob1 to knob2.  
 
 */


// How to deal with multiple eventSources
// take a row of knobs and assign them to an equal number of synths.

(
~spec = \freq.asSpec;
k = MKtl.basicNew('fakeBCR2000','BCR2000');
~knobs = 8.collect{ |i| k.elements[("knA"++(i+1)).asSymbol].eventSource };
~synths = ~knobs.collect{ { |freq = 400| SinOsc.ar(freq)*0.2 }.play };
[~knobs, ~synths].flop.do{ |x| x[0].do{ |value| 
	("A knob has spit out a value: "++value).postln;
	x[1].set(\freq, ~spec.map(value) )
	 
} };
)

(
k.setRawValueAt(\knA1, 22);
k.elements.at(\knA1).doAction
) 




//MDispatch version

//COLLECT
//take the input and multiply by 100
(
k = MKtl.basicNew('fakeBCR2000','BCR2000');
x = k.collect(  _ * 100 );
x.verbose = true;
)

k.setRawValueAt(\knA1, 32)
k.elements.at(\knA1).doAction

//SELECT
// only let values smaller then 0.5 through
(
k = MKtl.basicNew('fakeBCR2000','BCR2000');
x = k.select( _<0.5)
x.verbose = true;
)

k.setRawValueAt(\knA1, 0)
k.elements.at(\knA1).doAction


k.setRawValueAt(\knA1, 127)
k.elements.at(\knA1).doAction

//FOLD
//it's like reduce but with an initial state
// MAbstractKtl:fold(initialState, function of type BxA -> B)

//accumulate all incoming values
(
k = MKtl.basicNew('fakeBCR2000','BCR2000');
x = k.fold(0,{ |x,y| x + y });
x.verbose = true;
)
//run this several times and you will see the state increasing
k.setRawValueAt(\knA1, 127)
k.elements.at(\knA1).doAction



//FLATCOLLECT
// depending on the value of of button either let through the values of knob1 or the values of knob 2.
(
var knob1, knob2, result, button;
k = MKtl.basicNew('bcrFake','BCR2000');
knob1 = k.filterKeys(\knA1);
r = knob1;
knob1.verbose = false;
knob2 = k.filterKeys(\knA2);
d = knob2;
knob2.verbose = false;
button = k.filterKeys(\btA1);
b = button;
g = { |x|
	if(x == 0){ knob1 }{ knob2 };
};	
y = result = button.flatCollect(g);	
result.verbose = true;
)

// this changes which input is received, either from knob1 or knob2
(
k.setRawValueAt(\btA1, 0);
k.elements.at(\btA1).doAction;
)

//trigger something from knob1
(
r.setRawValueAt(\knA1, 0.33);
r.elements.at(\knA1).doAction
)

//trigger something from knob2
(
d.setRawValueAt(\knA2, 0.66);
d.elements.at(\knA2).doAction
)

//stuff from knob1 goes through, stuff from knob2 does not


// this changes which input is received, either from knob1 or knob2
(
k.setRawValueAt(\btA1, 1);
k.elements.at(\btA1).doAction;
)

//know only output from knob2 goes through

//trigger something from knob1
(
r.setRawValueAt(\knA1, 0.33);
r.elements.at(\knA1).doAction
)

//trigger something from knob2
(
d.setRawValueAt(\knA2, 0.66);
d.elements.at(\knA2).doAction
)


// get the values of knob1 and knob2 into an array. It fires when knob2 fires.
(
var knob1, knob2, result;
k = MKtl.basicNew('bcrFake','BCR2000');
knob1 = k.filterKeys(\knA1);
r = knob1;
knob1.verbose = false;
knob2 = k.filterKeys(\knA2);
d = knob2;
knob2.verbose = false;
y = result = knob1.flatCollect{ |x|
	knob2.collect{ |y| [x,y] }
};		
result.verbose = true;
)


//trigger something from knob1
(
r.setRawValueAt(\knA1, 0.33);
r.elements.at(\knA1).doAction
)

//trigger something from knob2
(
d.setRawValueAt(\knA2, 0.66);
d.elements.at(\knA2).doAction
)


// | merge
(
k = MKtl.basicNew('bcrFake','BCR2000');
a = k.filterKeys(\knA1);
b = k.filterKeys(\knA2);
c = k.filterKeys(\knA3);
r = a | b;
r.verbose = true;
)


//trigger something from knob1
(
a.setRawValueAt(\knA1, 0.33);
a.elements.at(\knA1).doAction
)

//trigger something from knob2
(
b.setRawValueAt(\knA2, 0.66);
b.elements.at(\knA2).doAction
)

//trigger something from knob3
(
c.setRawValueAt(\knA3, 0.66);
c.elements.at(\knA3).doAction
)





////////////
//TEST UNMAP
y.elements

(
k = MKtl.basicNew('bcrFake','BCR2000');
r =k.filterKeys(\knA2);
r.sources.postln;
r.sourceKeyToSource.postln;
r.mappedElems.postln;
r.verbose = true;
)

k.setRawValueAt(\knA2, 0)
k.elements.at(\knA2).doAction
r.unmap(k)
r.mappedElems[r.lookupSources(k)[0]]

k.elements[\knA2].removeFunc('bcrFake_filterKeys')
k.elements[\knA2].funcChain
////////////