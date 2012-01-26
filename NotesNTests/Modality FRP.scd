
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
g = { |x|
	if(x == 0){ knob1 }{ knob2 };
};	
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


// I will also implement a merge MDispatch that fires when either of them fires.





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