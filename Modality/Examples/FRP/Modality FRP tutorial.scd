/*


*********     Modality     *********
**       FRP tutorial             **
************************************





The Concept


    * Support different devices that work with different protocols (MIDI, HID, OSC, Serial, etc).


    * Provide a common interface to use these devices.


    * Provide a system to process the data from these devices.


    * Make real and virtual interfaces interchangeable (GUI for device, processed data for device, etc).





in short...






    **** Make using OSC, MIDI and HID devices absurdly easy !!! ****






In practice, HID is broken on OSX and OSC in not implementer yet...



Realisation

    * base class MKtl -> MIDIMktl, HIDMKtl, etc).

    * Event network via FRP: EventStream and FPSignal.

    * Templates for various devices.

















Device description:

- It's stored in a text file and loaded at runtime.
- Easy to write one.
- Once written everyone can use it.


*/

// NanoKontrol 1
// scene1:
\sl_1_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  2, \spec: \midiCC)




/*
Installing the library

get zip file from https://github.com/ModalityTeam/Modality-toolkit (or clone)

Copy "Modality" folder to "~/Library/Application Support/SuperCollider/Extensions"

or on windows and linux copy to the directory given by Platform.userExtensionDir.

get FP quark

http://quarks.sourceforge.net/

I have these files on a pen if needed

*/










/*
How to use the library:



Find the midi devices present:
*/
MIDIMKtl.find
/*

Each device is assigned a name automatically. If you know the name then you can directly use it.

*/



MIDIMKtl('bcr20000')




//the elements:
MIDIMKtl('bcr20000').elements




//create a non existing Controller according to template 'BCR2000'
x = MIDIMKtl.make('fakeBCR','BCR2000');
x.elements[\kn_1_2].inspect




//Do something with the output of the midi controller:
MIDIMKtl('bcr20000').esFor(\kn_7_1).do{ |x| postln(x) };

//remove all actions:
MIDIMKtl('bcr20000').reset;



//How to make your own device spec file
/*
save a file with nameOfMyDevice.spec.scd in MKtlSpecs

It should loook like
*/

[

	\sl_1_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  2, \spec: \midiCC),
	\sl_2_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  3, \spec: \midiCC)

]

//you don't need to type everything by hand...

// Behringer BCR2000 specs:

[
	\pr_1_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 105, \spec: \midiBut, \mode: \toggle, \ioType: \inout),
	\pr_1_2: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 106, \spec: \midiBut, \mode: \toggle, \ioType: \inout),
	\pr_2_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 107, \spec: \midiBut, \mode: \toggle, \ioType: \inout),
	\pr_2_2: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 108, \spec: \midiBut, \mode: \toggle, \ioType: \inout)
]
++
8.collect{ |i|

	//4 encoder groups
	4.collect{ |j|
		// top knob push mode
		[( "tr_" ++ (j+1) ++ "_" ++ (i+1) ).asSymbol,(\midiType: \cc, \type: \encoder, \chan: 0, \ccNum: 33+(8*j)+i, \spec: \midiCC, \ioType: \in),
		// knobs (top row)
		( "kn_" ++ (j+1) ++ "_" ++ (i+1) ).asSymbol,(\midiType: \cc, \type: \encoder, \chan: 0, \ccNum: 1+(8*j)+i, \spec: \midiCC, \ioType: \inout)]
	}
	++
	[
		("bt_1_"++(i+1)).asSymbol,(\midiType: \cc, \type: \midiBut, \chan: 0, \ccNum: 65+i, \spec: \midiCC, \ioType: \inout),
		("bt_2_"++(i+1)).asSymbol,(\midiType: \cc, \type: \midiBut, \chan: 0, \ccNum: 73+i, \spec: \midiCC, \ioType: \inout),
		("kn_5_"++(i+1)).asSymbol,(\midiType: \cc, \type: \encoder, \chan: 0, \ccNum: 81+i, \spec: \midiCC, \ioType: \inout),
		("kn_6_"++(i+1)).asSymbol,(\midiType: \cc, \type: \encoder, \chan: 0, \ccNum: 89+i, \spec: \midiCC, \ioType: \inout),
		("kn_7_"++(i+1)).asSymbol,(\midiType: \cc, \type: \encoder, \chan: 0, \ccNum: 97+i, \spec: \midiCC, \ioType: \inout)
	]
}.flat




//back to the action

//you can also give a name to the action:

MIDIMKtl('bcr20000').reset

MIDIMKtl('bcr20000').esFor(\kn_7_1).doDef(\action1, { |v| "action1 got %".format(v).postln });

MIDIMKtl('bcr20000').esFor(\kn_7_1).doDef(\action2, { |v| "action2 got %".format(v).postln });

//remove actions
MIDIMKtl('bcr20000').esFor(\kn_7_1).doDef(\action1, nil)
MIDIMKtl('bcr20000').esFor(\kn_7_1).doDef(\action2, nil)


//If you don't want to use names, then you need to save the function in a variable:

f = { |v| "action1 got %".format(v).postln };

MIDIMKtl('bcr20000').esFor(\kn_7_1).do( f );

MIDIMKtl('bcr20000').esFor(\kn_7_1).stopDoing( f )



//get multiple elements

x = (1..8).collect([\kn,7,_]);
MIDIMKtl('bcr20000').esFor( x )

//add multiple actions in one go:
(
MIDIMKtl('bcr20000').reset;
MIDIMKtl('bcr20000')
    .esFor((1..8).collect([\kn,7,_])) // an array of event streams
    .do{ |es,i|
        es.do{ |x| "Got something from slider %: %".format(i+1,x).postln }
    };
)




//these are the basics.

(
SynthDef(\moog,{
    //Band limited pulse wave
    var out = Pulse.ar( \freq.kr(40)* [1,3.01], \width.kr([0.3,0.7]) );

        //Moog filter emulator
    out = MoogFF.ar(
        //input
        in:out,

        //filter frequency
        freq: \ffreq.kr(400, 0.1),

        //the filter resonance gain
        gain: \gain.kr(2, 0.1)
    );

    Out.ar(0, out)

}).add
)




(
MIDIMKtl('bcr20000').reset;

MIDIMKtl('bcr20000').esFor(\kn_7_1).do{ |v|
    x.set(\ffreq, v.linlin(0.0, 1.0, 200,2000) )
};

MIDIMKtl('bcr20000').esFor(\kn_7_2).do{ |v|
    x.set(\gain, v.linlin(0.0, 1.0, 0.1,4) )
};

x = Synth(\moog);
)












/*
Functional Reactive Programming

    * FRP deals with with 'Event Processing'.

    * Events come in while the program is running, most often, at unpredictable times.

    * The Event Network controls how the inputs are routed and processed to outputs

    * EventSources - Time-ordered sequences of discrete events.
    * Signals - Step functions.



It's a bit like Max/MSP programming but with higher order abstractions.







              +--------------+   event
              | EventSource  |+-------->
              +--------------+
*/
(

x = EventSource();

//function is evaluated every time x is fired with a value
x.do( { |x| postln("Hello world: "++x) } );

x.fire(5)
)


//So what ??

// well you can combine EventSources into more complicated things











//**** Combinators: ****

/*
    Select: filter values

        x     +--------------+     x
    +-------->|     x > 3 ?  |+-------->
              +--------------+

*/

(
x = EventSource();

//creates a new EventStream that only let's through value bigger then 3
y = x.select(_>3);

//perform action every time y fires a value
y.do{ |v| postln("I got a "++v) };

x.fire(1);//will not let through.
x.fire(4);//will let through.
)





//With EventSource
(
k = MIDIMKtl('bcr20000');
k.reset; //reset controller to a clean state


~knob = k.esFor(\kn_7_1);

//start synth
~synth = Synth(\moog);



~result = ~knob.select( _ > 0.5);

//associate each result EventSource with a synth
~result.do{ |v| ~synth.set(\ffreq, v.linlin(0.0,1.0,100.0,4000.0) ) };













//gui for visualization
~guiKnob = Knob();
~guiResult = Knob();
~guiButton = Button().states_([
	["0", Color.white, Color.black],
	["1", Color.black, Color.red],
]);
w = Window(bounds:Rect(200,200,300,200)).layout_(
	 VLayout(
        HLayout(
            VLayout( StaticText().string_("actual knob"), ~guiKnob),
            VLayout( StaticText().string_("after processing"), ~guiResult)
        ),
		HLayout( ~guiButton ),
	)
).front;
~knob.connect(~guiKnob);
~result.connect(~guiResult);
~button.connect(~guiButton);
)


/*

    Collect: apply a function to the input


       x      +--------------+   x * 100
    +-------->|        f     |+-------->
              +--------------+

*/

(
x = EventSource();

y = x.collect({ |v| v * 100 });

y.do{ |v| postln("I got a "++v) };

x.fire(1);
x.fire(4);
)
//this is just like collections





//With EventSource
(
k = MIDIMKtl('bcr20000');
k.reset; //reset controller to a clean state


~knob = k.esFor(\kn_7_1);

//start synth
~synth = Synth(\moog);



~result = ~knob.collect({ |v|  (sin( (v * 8 * pi) % (2*pi) ) + 1)/2 });

//associate each result EventSource with a synth
~result.do{ |v| ~synth.set(\ffreq, v.linlin(0.0,1.0,100.0,4000.0) ) };













//gui for visualization
~guiKnob = Knob();
~guiResult = Knob();
~guiButton = Button().states_([
	["0", Color.white, Color.black],
	["1", Color.black, Color.red],
]);
w = Window(bounds:Rect(200,200,300,200)).layout_(
	 VLayout(
        HLayout(
            VLayout( StaticText().string_("actual knob"), ~guiKnob),
            VLayout( StaticText().string_("after processing"), ~guiResult)
        ),
		HLayout( ~guiButton ),
	)
).front;
~knob.connect(~guiKnob);
~result.connect(~guiResult);
~button.connect(~guiButton);
)








/*
    Inject:

    * Keep state.
    * Provide a rule to change state on a new input value.


       x      +-----------------+   state
    +-------->| s0 -> s1=s0+x   |+-------->
              +-----------------+

*/
// sum values:
(
x = EventSource();

//sum incoming value to state
y = x.inject(
    0.0, //inital state
    { |state,v| state + v } //state change function
);

y.do{ |v| postln("I got a "++v) };

x.fire(1);

x.fire(4);

x.fire(7);

x.fire(12);
)
//this is just like collections




//keep last two values:
/*

       x      +------------------------+  (x1,x)
    +-------->|s0=(x2,x1) --> s1=(x1,x)|+-------->
              +------------------------+

*/

(

x = EventSource();

y = x.inject(
    [0.0,0.0], //inital state
    { |state,v| [state[1],v] } //state change function
);

y.do{ |v| postln("I got a "++v) };

x.fire(1);

x.fire(4);

x.fire(7);

x.fire(12);
)





//*********    Accumulate values    *********

//as you move the knob the modulation frequency rises until it gets to a maximum and it returns to the minimum value
(
k = MIDIMKtl('bcr20000'); //change to your own controller
k.reset; //reset controller to a clean state
~knob = k.esFor(\kn_7_1); //change to your own controller

//start synth
~synth = { |freq=5| SinOsc.ar( LFNoise0.ar(freq).range(50,[200,210]) ) }.play;

//an event source that emits nothing (because we will never fire it)
~emitsNothing = EventSource();




~result = ~knob.inject(0.0, { |state,x| //ignore x and add 0.001 to state
	(state+0.001).mod(1.0)
});




~result.do{ |v| postln("Current mod frequency : "++v.linlin(0.0,1.0,1,10.0) ) };
//associate each result EventSource with a synth
~result.do{ |v| ~synth.set(\freq, v.linlin(0.0,1.0,1,10.0) ) };

//gui for visualization
~guiKnob = Knob();
~guiResult = Knob();
w = Window(bounds:Rect(200,200,200,100)).layout_(
	 HLayout( ~guiKnob, ~guiResult )
).front;
~knob.connect(~guiKnob);
~result.connect(~guiResult);
)





//combining multiple event streams with a function of n - arguments



// Applying functions:

(

x = EventSource();

y = EventSource();

z = EventSource();

//I want to sum the values from 3 event sources:
f = { |x,y,z| x + y + z };

w = f <%> x <*> y <*> z;

w.do( postln(_) );
)

x.fire(9.0);
y.fire(3.0);
z.fire(1.0);

//similar to
f = { |x,y,z| x + y + z };
f.(9.0,3.0,1.0)
//or
{ |x,y,z| x + y + z }.( 9.0, 3.0, 1.0 )






//With EventSource
(
k = MIDIMKtl('bcr20000');
k.reset; //reset controller to a clean state


~knob1 = k.signalFor(\kn_7_1);
~knob2 = k.signalFor(\kn_7_2);

//start synth
~synth = Synth(\moog);

~result = { |a,b| min(a,b) } <%> ~knob1 <*> ~knob2;

//associate each result EventSource with a synth
~result.do{ |v| ~synth.set(\ffreq, v.linlin(0.0,1.0,100.0,4000.0) ) };













//gui for visualization
~guiKnob1 = Knob();
~guiKnob2 = Knob();
~guiResult = Knob();
~guiButton = Button().states_([
	["0", Color.white, Color.black],
	["1", Color.black, Color.red],
]);
w = Window(bounds:Rect(200,200,300,200)).layout_(
	 VLayout(
        HLayout(
            VLayout( StaticText().string_("actual knobs"), HLayout(~guiKnob1, ~guiKnob2)),
            VLayout( StaticText().string_("after processing"), ~guiResult)
        ),
		HLayout( ~guiButton ),
	)
).front;
~knob1.connect(~guiKnob1);
~knob2.connect(~guiKnob2);
~result.connect(~guiResult);
~button.connect(~guiButton);
)















//Now for the complicated stuff



/*

 Dynamic Event Switching:


+---------+     x
|selector |+----------------------+
+---------+                       |
                                  |
                                  |
                                  |
                                  |
+---------+                       |
|   A     |+------>+----+         |
+---------+             |         v f(x) = A
+---------+             |     +--------------+  output
|   B     |+------>     +---->|              |+----------->
+---------+                   +--------------+
+---------+
|   C     |+------>
+---------+

*/




(
~selector = EventSource();

//two sources
a = EventSource();
b = EventSource();

//switch switches between event streams.
//every time a new event comes in a new event stream is selected to be outputted.
//a function is evaluated and the result of the function (an event stream) will be
//outputted from then on
w = ~selector.switch{ |v|

    if(v==0){a}{b}

};

//the action:
w.do(_.postln);
)

(
//will get value from y
~selector.fire(1);
a.fire(1);
b.fire(4);
)

(
//will get value from z
~selector.fire(1);
a.fire(1);
b.fire(4);
)

//with modality
(
MIDIMKtl('bcr20000').reset;

a = MIDIMKtl('bcr20000').esFor(\kn_7_1);
b = MIDIMKtl('bcr20000').esFor(\kn_7_2);

~selector = MIDIMKtl('bcr20000').esFor(\pr_1_1);

//either use slider a or slider b depending on button
w = ~selector.switch{ |v|

    if(v==0){a}{b}

};

w.do{ |v|
    x.set(\ffreq, v.linlin(0.0, 1.0, 200,2000) )
};

x = Synth(\moog);
)



/*Templates

Templates bundled with the library:

storeWithT
storePrevious
storePreviousWithT
changes
changedDirection
decreasing
increasing
withinRange
matchVal
threshold
thresholdUp
thresholdDown
neventsWithinT
speed
slowdown

Example:
*/

(
x = EventSource();
x.decreasing.do( postln(_) );
x.fire(2);
x.fire(3);
x.fire(4);
x.fire(2);
)









//*********   Mute a knob with a button:   *********


/*


+---------+
|  Button |+----------------------+
+---------+                       |
                                  |
                                  |
                                  |
+---------+                       |
|   Knob  |+------>+----+         |
+---------+             |         v f(x) = if x ==1 knob else Nothing
+---------+             |     +--------------+  output
| Nothing |+------>     +---->|              |+----------->
+---------+                   +--------------+



*/


￼

//With EventSource
(
k = MIDIMKtl('bcr20000');
k.reset; //reset controller to a clean state



~button = k.esFor(\pr_2_1);
~knob = k.esFor(\kn_7_1);

//start synth
~synth = Synth(\moog);



//an event source that emits nothing
~emitsNothing = NothingES();


~result = ~button.switch{ |v|
		if( v == 1.0 ) {
		~knob
	} {
		~emitsNothing
	}
};

//associate each result EventSource with a synth
~result.do{ |v| ~synth.set(\ffreq, v.linlin(0.0,1.0,100.0,4000.0) ) };













//gui for visualization
~guiKnob = Knob();
~guiResult = Knob();
~guiButton = Button().states_([
	["0", Color.white, Color.black],
	["1", Color.black, Color.red],
]);
w = Window(bounds:Rect(200,200,300,200)).layout_(
	 VLayout(
        HLayout(
            VLayout( StaticText().string_("actual knob"), ~guiKnob),
            VLayout( StaticText().string_("after processing"), ~guiResult)
        ),
		HLayout( ~guiButton ),
	)
).front;
~knob.connect(~guiKnob);
~result.connect(~guiResult);
~button.connect(~guiButton);
)









//********* Modality - Exchange actions between controllers.   *********


(
var withGui = true;
//one controller
MIDIMKtl.find;
//with nanokontrol
k = MKtl('bcr20000');
k.reset;
//~synths !? { |x| x.do(_.free) };
/*
change to this if you don't have a nanokontrol
k =  MKtl.make('nnkn0', 'nanoKONTROL');
*/

//some controls that control some synthesis process
~knobs = k.esFor((1..4).collect{ |i| [\kn,7,i] });

//the button that enters selection mode
~but = k.esFor(\pr_2_1);
~nothing = EventSource();

//selection mode is entered when ~but is set to 1
//it is exited when two different knobs are moved
~but.do{ |x| if(x == 1){ "entering remap mode".postln } };
~exchange = ~but.switch{ |y|
    var selection;
    //enter remap mode
    if( y == 1) {
        //two different knobs are moved
        selection = ~knobs.collect{ |x,i| x.collect{i} }.reduce('|')
        .inject([false],{ |state,x|
            //("knob "++x++" selected for exchange").postln;
            (switch(state.size)
                {1} { [false,x] }
                {2} { if(x != state.last) { [true,state.last,x] } { state } }
                {3} { [false,0,0] });
        }).select{ |x| x[0] == true}.collect{ |array| [array[1],array[2]] };
    } {
        //exit remap mode
        //debug: "exiting remap mode 1".postln;
        ~nothing
    }
};
~exchange.do{ |x| ("Exchanging actions of knobs "++x).postln };
//if actions are changed then reset the button
~exchange.do{ k.at(\pr_2_1).send(0) };
//index i of this array is the knob that will go into action i;
~startState = [0,1,2,3]; //which knobs go to which action

//~exchange = EventSource();
~sel = ~exchange.inject(~startState, { |state, exchangePair|
    var indexA = state.indexOf(exchangePair[0]);
    var indexB = state.indexOf(exchangePair[1]);
    //("Exchange pair: "++exchangePair).postln;
    //postln("state :" ++state);
    state.swap(indexA, indexB);
});

f = { |i| { |state|
    ~knobs[state[i]]
}};

//between receiving 1 on ~but and ~receiving a zero, or receiving something from ~exchange do nothing.
g = { |i| (~but | ~exchange).switch({ |x|
    if(x == 1) {
        ~nothing
    } {
        ~sel.switch(f.(i),~knobs[~selSignal.now[i]]);
    } },~knobs[i]);
};

~selSignal = ~sel.hold([0,1,2,3]);

~outputs = 4.collect{ |i| g.(i) };

~synths = [
    { |freq=400| Pan2.ar( SinOsc.ar(freq)*0.2, -1.0) }.play,
    { |freq=400| Pan2.ar( Saw.ar(freq)*0.2, -0.2) }.play,
    { |freq=400| Pan2.ar( LFNoise0.ar(freq)*0.2, 0.6) }.play,
    { |freq=400| Pan2.ar( LPF.ar( WhiteNoise.ar, freq)*0.6, 1.0) }.play
];
[~outputs, ~synths].flopWith{ |es, synth|
    es.do{ |v|
        synth.set(\freq, v.linlin(0.0,1.0,200.0,2000.0))
    }
};

//GUI
if( withGui ) {
    w !? _.close;
    ~guiKnobs = 4.collect{ Knob() };
    ~outputKnobs = 4.collect{ Knob() };
    ~labels = ["SinOsc","Saw","LFNoise","WhiteNoise"];
    ~texts = ~labels.collect{ |t|
        StaticText().string_(t)
    };

    ~guiTV = ~labels.collect{ |st| TextView().string_(st) };
    w = Window(bounds:Rect(200,200,200,100)).layout_(
        VLayout(
            HLayout( *~guiKnobs ),
            HLayout( *~texts ),
            HLayout( *~outputKnobs )
        )

    ).front;
    [~knobs, ~guiKnobs].flopWith{ |knob,gui|
        knob.do{ |v| defer{ gui.value_(v) } }
    };
    [~outputs, ~outputKnobs].flopWith{ |knob,gui|
        knob.do{ |v| defer{ gui.value_(v) } }
    };
} {
    ~outputs.do{ |es,i| es.do{ |x| ("action "++i++" got a "++x).postln } };
}
)

















//*********    routing one knob to one of multiple actions    *********

(
k = MIDIMKtl('bcr20000');
k.reset;

~synths = [
	{ |freq=400| SinOsc.ar(freq)*0.2 }.play,
	{ |freq=400| Saw.ar(freq)*0.2 }.play,
	{ |freq=400| LFNoise0.ar(freq)*0.2 }.play,
	{ |freq=400| Blip.ar(freq)*0.2 }.play
];

//iterate though all 4 actions by pressing one button
~selector = k.esFor(\pr_2_1).toggle(~synths.size);
~selector.do{ |i| postln("Selector : "++[\sine, \saw, \noise, \blip][i]) };

~knob = k.esFor(\kn_7_1);
~actions = k.esFor(\kn_7_1).route( ~synths.size, ~selector );

//associate each result EventSource with a synth
[~actions, ~synths].flopWith{ |es,synth|
	es.do{ |v| synth.set(\freq, v.linlin(0.0,1.0,100.0,4000.0) ) }
};

~selector.fire(0);








//gui for visualization
~guiSynths = ~synths.collect{ Knob() };
~guiKnob = Knob();
w = Window(bounds:Rect(200,200,200,100)).layout_(
	 VLayout(
    	HLayout( ~guiKnob ),
		HLayout( *~guiSynths ),
	)
).front;
~knob.connect(~guiKnob);
[~guiSynths,~actions].flopWith{ |a,b|
	b.connect(a)
};
)













//*********  With Timers *********

(
SynthDef(\singrain, { |freq = 440, amp = 0.2, sustain = 1|
        var sig;
        sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.perc(0.01, sustain), doneAction: 2);
        Out.ar(0, sig ! 2);     // sig ! 2 is the same as [sig, sig]
}).add;
)


//plays synth half-second after you stop movingstop moving knob:

(
k = MIDIMKtl('bcr20000'); //change to your own controller
k.reset; //reset controller to a clean state
~knob = k.esFor(\kn_7_1); //change to your own controller
~timer = WaitES(0.1,0.0);

~timer.do{ "".postln; "timer Bang".postln };

~result = ~knob.switch{ WaitES(1.0, 0.0) };

~result.do{
		var newFreq = exprand(200.0,600.0);
		postln("freq: "++newFreq );
		Synth(\singrain, [
			freq: newFreq,
			amp: rrand(0.1, 0.5),
			sustain: rrand(1, 3) * 0.1
		]);
};

//gui for visualization
~guiKnob = Knob();
w = Window(bounds:Rect(200,200,200,100)).layout_(
	 HLayout( ~guiKnob )
).front;
~knob.connect(~guiKnob);
)














//*********    Decay    *********
(
var withGui = true;

//one controller
MIDIMKtl.find;
//with nanokontrol
k = MKtl('bcr20000');
k.reset;
//~synths !? { |x| x.do(_.free) };
/*
change to this if you don't have a nanokontrol
k =  MKtl.make('nnkn0', 'nanoKONTROL');
*/

//some controls that control some synthesis process
~knobs = k.esFor((1..8).collect{ |i| [\kn,7,i] });

~leak = ~knobs.collect{ |es|
	es | es.switch{ |v|
			TimerES(0.01,10000).inject(v,{|state,x| (state - 0.004).max(0) })
	}
};

~synths = ~leak.collect{ |x,i|
	var s = { Pan2.ar( SinOsc.ar(\freq.kr(200,1))*0.1, \pan.kr(i.linlin(0,~accum.size-1,-1.0,1.0) ) ) }.play;
	x.do{ |v| s.set(\freq, v.linlin(0.0, 1.0, 100,1000.0)) };
	s
};

if( withGui ) {
w !? _.close;
~guiKnobs = ~knobs.collect{ Knob() };

w = Window(bounds:Rect(200,200,200,100)).layout_( HLayout( *~guiKnobs ) ).front;
[~leak, ~guiKnobs].flopWith{ |es,gui|
	es.do{ |v| defer{ gui.value_( v.linlin(0.0,1.0,0.0,1.0) )  }}
};
}

)



//knob 1 and knob 2 will control the range of the frequency of synth
//the synth is triggered every second
(
k = MIDIMKtl('bcr20000'); //change to your own controller
k.reset; //reset controller to a clean state

~knob1 = k.signalFor(\kn_7_1); //change to your own controller


~knob2 = k.signalFor(\kn_7_2); //change to your own controller


//fires every 0.1 seconds.
~timer = TimerES(0.1,10000);
~timer.do{ "".postln; "timer Bang".postln };


//put the values of both knobs into an array
~pair = { |a,b| [a,b] } <%> ~knob1 <*> ~knob2;





~result = ~pair.changes.switch{ |array|
    //every time the timer fires it sends the value
    //of the two knobs
	~timer.collect{ array }
};










//create synth
~result.do{ |array|
		var x  = array[0].linexp(0.0,1.0,200.0,800.0);
		var y = array[1].linexp(0.0,1.0,200.0,800.0);
		var newFreq = exprand(x,y);
		postln("min: "++min(x,y) );
		postln("max: "++max(x,y) );
		postln("freq: "++newFreq );
		Synth(\singrain, [
			freq: newFreq,
			amp: rrand(0.1, 0.5),
			sustain: rrand(1, 3) * 0.1
		]);
};










//gui for visualization
~guiKnob1 = Knob();
~guiKnob2 = Knob();
w = Window(bounds:Rect(200,200,200,100)).layout_(
	 HLayout( ~guiKnob1, ~guiKnob2 )
).front;
~knob1.connect(~guiKnob1);
~knob2.connect(~guiKnob2);
)














//*********    record and playback    *********


//press the button to alternate between record and play mode
//move knob while in rec mode
(
//one controller
//k = MKtl.basicNew('fakeBCR2000','BCR2000');
k.reset;
k = MIDIMKtl('bcr20000');
//some control
~knob = k.elements[\kn_7_1].eventSource;
//the button that enters rec/playback mode
~but = k.elements[\pr_2_1].eventSource;

//an event stream that never fires anything
~nothing = EventSource();

//record mode is entered when ~but is set to 1
//it is exited when it is set to zero
~array = ~but.switch{ |x|
	if(x == 1){
		"entering record mode".postln;
		//start recording the incoming data.
		//output the latest state of the data array.
		~knob.inject([Process.elapsedTime,List.new], { |state,x|
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
};

// the action is either silence or playback of the recorded run.
~result = ~array.switch{ |array|
	~but.switch{ |x|
		if( x == 1 ) {
			~nothing
		} {
			EventPlayerES(array);
		}
	}
} | ~but.switch{ |x|
	if( x == 1 ) {
		~knob
	} {
		~nothing;
	}
};

~result.do{ |v| ~synth.set(\freq, v.linexp(0.0,1.0,200,4000.0) ) };

~synth = {
    MoogFF.ar(
        Pulse.ar([40,121], [0.3,0.7]),
        \freq.kr(400,1),
       	0.83 * 4)
}.play;



//gui for visualization
~guiKnob = Knob();
~guiResult = Knob();
~guiButton = Button().states_([
	["play", Color.white, Color.black],
	["rec", Color.black, Color.red],
]);
w = Window(bounds:Rect(200,200,300,200)).layout_(
	 VLayout(
        HLayout(
            VLayout( StaticText().string_("actual knob"), ~guiKnob),
            VLayout( StaticText().string_("after processing"), ~guiResult)
        ),
		HLayout( ~guiButton ),
	)
).front;
~knob.connect(~guiKnob);
~result.connect(~guiResult);
~but.connect(~guiButton);
)












/*

Modality

Info: http://modality.bek.no/
Code: https://github.com/ModalityTeam/Modality-toolkit

*/



