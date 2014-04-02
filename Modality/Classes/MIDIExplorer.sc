MIDIExplorer {

	classvar <allMsgTypes = #[ \noteOn, \noteOff, \cc, \touch, \polytouch, \bend, \program ];

	classvar <resps;
	classvar <results;
	classvar <observeDict;
	classvar <>verbose = true;
	classvar <observedSrcID;

	*shutUp { verbose = false }

	*init {

		resps = [

			MIDIFunc.cc({|val, num, chan, src|
				this.updateRange(\cc, val, num, chan, src);
			}),

			MIDIFunc.noteOn({|val, num, chan, src|
				this.updateRange(\noteOn, val, num, chan, src);
			}),

			MIDIFunc.noteOff({|val, num, chan, src|
				this.updateRange(\noteOff, val, num, chan, src);
			}),

			MIDIFunc.polytouch({|val, note, chan, src|
				this.updateRange(\polytouch, val, note, chan, src);
			}),

			MIDIFunc.bend({|val, chan, src|
				this.updateRange(\bend, val, 0, chan, src);
			}),

			MIDIFunc.touch({|val, chan, src|
				this.updateRange(\touch, val, 0, chan, src);
			}),

			MIDIFunc.program({|val, chan, src|
				this.updateRange(\program, val, 0, chan, src);
			})

		];
	}

	*start { |srcID|
		if (resps.isNil) { this.init };

		observedSrcID = srcID;
		this.prepareObserve;
		resps.do(_.add);
	}

	*stop {
		resps.do(_.clear);
	}

	*prepareObserve {
		observeDict = ();
		allMsgTypes.do(observeDict.put(_, Dictionary()));
	}

	*openDoc {
		Document("edit and save me", this.compile);
	}

	*compile { |includeSpecs = false|

		var num, chan;

		var str = "(";

		if (observeDict[\noteOn].notEmpty) {
			str = str + "\n// ------ noteOn -------------";
			observeDict[\noteOn].sortedKeysValuesDo { |key, val|
				#chan, num = key.split($_).collect(_.asInteger);
				str = str + "\n'_elName_%_': ('midiMsgType': 'noteOn', 'type': 'key', 'midiChan': %, 'midiNum':  %, 'spec': 'midiNote'),"
					.format(key, chan, num);
			};
		};



		if (observeDict[\noteOff].notEmpty) {
			str = str + "\n\n// ---------noteOff ----------";
			observeDict[\noteOff].sortedKeysValuesDo { |key, val|
				#chan, num = key.split($_).collect(_.asInteger);
				str = str + "\n'_elName_%_': ('midiMsgType': 'midiNoteOff', 'type': 'key', 'midiChan': %, 'midiNum':  %,'spec': 'midiNote'),"
				.format(key, chan, num);
			};
		};


		if (observeDict[\cc].notEmpty) {
			str = str + "\n\n// ------ cc -------------";
			observeDict[\cc].sortedKeysValuesDo { |key, val|
				#chan, num = key.split($_).collect(_.asInteger);
				str = str + "\n'_elName_%_': ('midiMsgType': 'cc', 'type': 'slider', 'midiChan': %, 'midiNum':  %,'spec': 'midiCC'),"
					.format(key, chan, num);
			};
		};

		if (observeDict[\polytouch].notEmpty) {
			str = str + "\n\n// ------ polytouch -------------";
			observeDict[\polytouch].sortedKeysValuesDo { |key, val|
				#chan, num = key.split($_).collect(_.asInteger);
				str = str + "\n'_elName_%_': ('midiMsgType': 'cc', 'type': 'keytouch', 'midiChan': %, 'midiNum':  %,'spec': 'midiCC'),"
					.format(key, chan, num);
			};
		};

		if (observeDict[\touch].notEmpty) {
			str = str + "\n\n// ------- touch ------------";
			observeDict[\touch].sortedKeysValuesDo { |key, val|
				#chan, num = key.split($_).collect(_.asInteger);
				str = str + "\n'_elName_%_': ('midiMsgType': 'touch', 'type': 'chantouch', 'midiChan': %, 'midiNum':  %,'spec': 'midiTouch'),".format(key, chan, num);
			};
		};

		if (observeDict[\bend].notEmpty) {
			str = str + "\n\n// ------- bend ------------";
			observeDict[\bend].sortedKeysValuesDo { |key, val|
				#chan, num = key.split($_).collect(_.asInteger);
				str = str + "\n'_elName_%_': ('midiMsgType': 'bend', 'type': 'bender', 'midiChan': %, 'midiNum':  %,'spec': 'midiBend'),".format(key, chan, num);
			};
		};

		str = str + "\n";

		str = str + ");";


		if (includeSpecs) {
			str = str + "\n\n// ----- noteOn Specs ----------";
			observeDict[\noteOn].sortedKeysValuesDo { |key, val|
				str = str + "\nMKtl.addSpec( _elName_%_, [%, %, \linear, 0, 0]);".format(key, val[0], val[1]);
			};
			str = str + "\n\n// ----- noteOff Specs ----------";
			observeDict[\noteOn].sortedKeysValuesDo { |key, val|
				str = str + "\nMKtl.addSpec( _elName_%_, [%, %, \linear, 0, 0]);".format(key, val[0], val[1]);
			};
			str = str + "\n\n// ----- CC Specs ----------";
			observeDict[\noteOn].sortedKeysValuesDo { |key, val|
				str = str + "\nMKtl.addSpec( _elName_%_, [%, %, \linear, 0, 0]);".format(key, val[0], val[1]);
			};
			str = str + "\n\n// ----- bend Specs ----------";
			observeDict[\noteOn].sortedKeysValuesDo { |key, val|
				str = str + "\nMKtl.addSpec( _elName_%_, [%, %, \linear, 0, 0]);".format(key, val[0], val[1]);
			};
		};

		^str;
	}

	*updateRange { |msgType, val, num, chan|
		var hash, range;
		var msgDict = observeDict[msgType];

		if (verbose) { [msgType, val, num, chan].postcs; } { ".".post; };
		if (0.1.coin) { observeDict.collect(_.size).sum.postln };

		hash = "%_%".format(chan, (num + 1000).asString.drop(1));
		range = msgDict[hash];
		range.isNil.if{
			// min max
			msgDict[hash] = range = [val, val];
		};

		msgDict[hash] = [min(range[0], val), max(range[1], val)];
	}
}
