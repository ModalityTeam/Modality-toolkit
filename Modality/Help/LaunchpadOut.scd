MIDIMKtl.find

a = MIDIMKtl(\lnch0)
b = LaunchpadOut(a)

20.do{b.setColor({8.rand}!2, \lAmber)}

{|i| b.setPlayColor(i, \red) }!8

b.reset



MIDIMKtl.destinationDeviceDict
MIDIMKtl.sourceDeviceDict

a.verbose = true


b.midiOut.inspect


a.elements



MIDIClient.destinations.indexOf(MIDIMKtl(\lnch0).source)
MIDIEndPoint

MIDIMKtl(\lnch0)

.source.inspect
MIDIClient.destinations.first.inspect