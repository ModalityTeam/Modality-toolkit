/*

MIDIClient.init;

MIDIClient.externalSources;
MIDIClient.externalDestinations;

MIDIIn.connectAll;
*/

+ MIDIClient {

	*externalSources {
		^MIDIClient.sources.select({ |src,i|
			src.device != "SuperCollider"
		})
	}

	*externalDestinations {
		^MIDIClient.destinations.select({ |src,i|
			src.device != "SuperCollider"
		})
	}

}

+ MIDIIn{

	*connectAll {
		if(MIDIClient.initialized.not, { MIDIClient.init });
		MIDIClient.externalSources.do({ |src,i|
			MIDIIn.connect(i,src);
		});
	}
}