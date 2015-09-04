+ MIDIEndPoint {
	storeArgs { ^[device, name, uid] }
	printOn { arg stream; this.storeOn(stream) }

	== { |anEndPoint|
		^anEndPoint.isKindOf(MIDIEndPoint)
		and: { anEndPoint.uid == this.uid
			and: { anEndPoint.name == this.name
				and: { anEndPoint.device == this.device
		}}}
	}
}
