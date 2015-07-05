/*
Rewrite of MIDIMonitor as model for all monitors.

// Example:
MKtl.find(\midi);
MIDIMonitor.start;

// now wiggle all elements, then see hierarchy of messages:
MIDIMonitor.postTree;

MIDIMonitor.shutUp; // no verbose
MIDIMonitor.talk; // verbose


To Do:

1. abstract out consecutive note numbers and controller numbers
   in order to generate more compact code

2. generate concise and correct desc files

3. add msg collection for sysex etc

*/

MIDIMonitor {
	classvar <allMsgTypes, <>verbose = true;
	classvar <chanNumMsgTypes = #[\noteOn, \noteOff, \control, \polytouch],
		<chanMsgTypes = #[\touch, \bend, \program],
		<sysIndices;

	classvar <monitorFuncs, <msgTree, <monitoring = false;

	*talk { verbose = true }
	*shutUp { verbose = false }
	*postTree {
		"\n\n// -----------// MIDIMonitor.msgTree: ".postln;
		msgTree.deepPost;
		"// -----------//\n".postln;
	}


	*init {
		msgTree = ();
		monitorFuncs = ();

		sysIndices = (\mtcQF: 1, \songPosition: 2, \songSelect: 3, \tuneRequest: 6,
		\midiClock: 8, \tick: 9, \start: 10, \continue: 11, \stop: 12,
		\activeSense: 14, \reset: 15);

		chanNumMsgTypes.do { |type|
			monitorFuncs[type] = { |srcID, chan, num, val|
				var srcEntry, typeEntry, chanEntry, numEntry, valRange;
				srcEntry = msgTree[srcID];
				if (srcEntry.isNil) { msgTree[srcID] = srcEntry = (); };
				typeEntry = srcEntry[type];
				if (typeEntry.isNil) { srcEntry[type] = typeEntry = () };
				chanEntry = typeEntry[chan];
				if (chanEntry.isNil) { typeEntry[chan] = chanEntry = () };

				valRange = chanEntry[num];
				if (valRange.isNil) { chanEntry[num] = valRange = [127, 0] };

				// keep range of incoming values:
				valRange.put(0, min(valRange[0] ? 127, val));
				valRange.put(1, max(valRange[1] ? 0, val));
				if (verbose) {
					"midi: srcID: %, type: %, chan: %, num: %, range: %, val: %\n"
					.postf(srcID, type, chan, num, valRange, val);
				};
			};
		};

		chanMsgTypes.do({ |type|
			monitorFuncs[type] = {|srcID, chan, val|
				var srcEntry, typeEntry, chanEntry, valRange;
				srcEntry = msgTree[srcID];
				if (srcEntry.isNil) { msgTree[srcID] = srcEntry = (); };
				typeEntry = srcEntry[type];
				if (typeEntry.isNil) { srcEntry[type] = typeEntry = () };
				valRange = typeEntry[chan];
				if (valRange.isNil) { typeEntry[chan] = valRange = [127, 0] };

				// keep range of incoming values:
				valRange.put(0, min(valRange[0] ? 127, val));
				valRange.put(1, max(valRange[1] ? 0, val));
				if (verbose) {
					"midi: srcID: %, type: %, chan: %, range: %, val: %\n"
					.postf(srcID, type, chan, valRange, val);
				};
			};
		});

		// do these when the rest works:
		// [\sysex].do({|type|
		// 	monitorFuncs[type] = {|src, data|
		//
		// 	};
		// });
		// [\mtcQF].do({|type|
		// 	monitorFuncs[type] = {|src, ind, data|
		// 		"MIDI Message Received:\n\ttype: %\n\tindex: %\n\tsrc: %\n\tdata: %\n\n".postf(type, ind, src, data);
		// 	};
		// });
		// [\smpte].do({|type| });
		// [\songPosition, \songSelect].do({|type|
		// 	monitorFuncs[type] = {|src, ind, data|
		// 		if(ind == sysIndices[type], {
		// 			"MIDI Message Received:\n\ttype: %\n\tsrc: %\n\tdata: %\n\n".postf(type, src, data);
		// 		});
		// 	};
		// });
		// [\sysrt].do({|type|
		// 	monitorFuncs[type] = {|src, ind, data|
		// 		"MIDI Message Received:\n\ttype: %\n\tindex: %\n\tsrc: %\n\tdata: %\n\n".postf(type, ind, src, data);
		// 	};
		// });
		// [\tuneRequest, \midiClock, \tick, \start, \continue, \stop, \activeSense, \reset].do({|type|
		// 	monitorFuncs[type] = {|src, ind|
		// 		if(ind == sysIndices[type], {
		// 			"MIDI Message Received:\n\ttype: %\n\tsrc: %\n\n".postf(type, src);
		// 		});
		// 	};
		// });
	}

	*start {
		if (monitoring) { ^this };
		if (monitorFuncs.isNil) { this.init };
		(chanMsgTypes ++ chanNumMsgTypes).do { |type|
			MIDIIn.addFuncTo(*[type.postln, monitorFuncs[type]]);
		};
		monitoring = true;
		CmdPeriod.add(this);
	}
	*stop {
		if (monitoring.not) { ^this };
		(chanMsgTypes ++ chanNumMsgTypes).do { |type|
			MIDIIn.removeFuncFrom(type, monitorFuncs[type]);
		};
		monitoring = false;
		CmdPeriod.remove(this);
	}
}

