LaunchpadOut {
	var <ktl, <midiOut;

	// output (e.g. used to set LEDs)
	var <colors;
	var <modeFlags;
	var matrixIdx, playIdx;
	var flashOff = 1;
	var colorValArray;	
	var <pagePadColors;


	*new {|ktl|
		^super.new.init(ktl)
	}
	
	init {|argKtl|
		
		ktl = argKtl;
		
		// out
		midiOut = MIDIOut(MIDIClient.destinations.indexOf(ktl.destination), ktl.dstID);
		
		
		// remove latency
		midiOut.latency = 0;
		
		colors = (
			off: 12,
			lRed: 13,
			red: 15,
			lAmber: 29,
			amber: 63,
			yellow: 62,
			lGreen: 28,
			green: 60,
			fRed: 11,
			fAmber: 59,
			fYellow: 58,
			fGreen: 56
		);
		modeFlags = (
			normal: 0x0C,
			flash: 8,
			doubleBuffer: 0
		);
		
		// matrix indices
		matrixIdx = {|i| (0..7) + (i * 16)}!8;
		
		// Play column indices
		playIdx = {|i| 0x8 + (0x10*i)}!8;	
	}
	
	setColor{|which, color(\red), flash(false)|
		midiOut.noteOn(0, matrixIdx[which[0]][which[1]], colors[color])
	}

	setArrowColor{|which, color(\red), flash(false)|
		midiOut.noteOn(0, playIdx[which], colors[color])
	}

//	setColorInArray {|which, color(\red), flash(false)|
//		matrixIdx[which[0]][which[1]]
//	}
//	
//	showAreas{|recalc = false|
//
//		recalc.if({
//		// recalculate the colorValArray
//			colorValArray = this.pr_colorValArray;
//		});
//
//		colorValArray.do{|val, i|
//			midiOut.noteOn(3, 146, val, 11);
//		};	
//		// send something strange to reset the mode;
//		midiOut.noteOn(0, -1, 28);
//	}
//
//	pr_colorValArray {
//		var out = Array.fill2D(8, 8, 12); // all off
//		var left, top, width, height, indices, colr;
//		
//		pagePadColors.keysValuesDo{|where, color|
//			# left, top, width, height = where.asArray;
//			colr = colors[color];
//			// get all indices
//			indices = (Array.iota(width) + left).collect{|i|
//				(Array.iota(height) + top).collect{|j|
//					[j, i]
//				}
//			}.flatten;
//			indices.postln;
//			indices.do{|idx|
//				out[idx[0]][idx[1]] = colr;
//			}
//		};
//		^out.flat;
//	}

	reset {
		midiOut.control(0, 0, 0)
	}

//	removeActionArea {|where|
//		pagePadActions.removeAt(where);
//		pagePadColors.removeAt(where);
//	}
	
	// flash sync
	tick{|sync = false|
		sync.if({
			flashOff = 0;
		});
		
		midiOut.control(0, 0, 32+flashOff);	
		flashOff = (flashOff + 1)%2;
	}

}