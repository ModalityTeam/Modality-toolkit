MIDIMKtl.find

MIDIMKtl('lnch2', 593081660, 326092818);  // Launchpad

MIDIMKtl('lnch2')
MIDIMKtl.destinationDeviceDict
MIDIMKtl.sourceDeviceDict

MIDIMKtl.sourceDeviceDict

b = MIDIMKtl('nnkn0');

b = MIDIMKtl('lnch0');

b.midiRawAction = {|...args|
	args.postln;
};
b.verbose_(true)

b.verbose = true
a = MIDIMKtl('lnch0');



a.elements.select{|elem|
	elem.deviceDescription[\type] == \button
}

MIDIMKtl.find

a.verbose = true
b.verbose = true

e = b.elements[\rew]

a.dump

e.deviceDescription
e.deviceDescription[\midiType]


// note
q.midiOut.noteOn(e.deviceDescription[\chan], e.deviceDescription[\midiNote], 12)

// cc
q.midiOut.control(e.deviceDescription[\chan], e.deviceDescription[\ccNum], 127)


q = ();

q.midiOut = MIDIOut(MIDIClient.destinations.indexOf(b.destination), b.dstID);

b.destination





e.deviceDescription[\ccNum]


pairsDo
.dump

 { arg chan, ctlNum=7, val=64;


LaunchpadOut