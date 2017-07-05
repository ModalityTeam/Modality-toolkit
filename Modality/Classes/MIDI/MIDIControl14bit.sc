MIDIControl14BitHelperLobyte{
	var <cc14helper;

	*new{ |cc14|
		^super.new.init( cc14 );
	}

	init{ |cc14|
		cc14helper = cc14;
	}

	value{ |val|
		^cc14helper.value( val, \lobyte );
	}

}

MIDIControl14BitHelper {
	var loCCnum, hiCCnum;
	var loByte, hiByte;
	var waitingForLoByte = false;

	*new{arg hiCCnum;
		^super.new.init(hiCCnum);
	}

	init{ |hiCC|
		hiCCnum = hiCC;
		loCCnum = hiCC + 32;
	}

	calculate{ arg lo, hi;
		var result;
		result = lo + (hi << 7);
		^result;
	}

	value{ arg val, byte=\hibyte;
		var outval;
		if ( byte == \hibyte ){
			hiByte = val;
			waitingForLoByte = true;
		};
		if ( byte == \lobyte ){
			loByte = val;
			if( waitingForLoByte, {
				outval = this.calculate( loByte, hiByte );
				waitingForLoByte = false;
			});
		};
		^outval;
	}

}

// sending out 14 bit midi control
+ MIDIOut{
	control14 { arg chan, ctlNum=7, val=64;
		this.control( chan, ctlNum, val >> 7 );
		this.control( chan, ctlNum+32, val % 128 );
	}
}
