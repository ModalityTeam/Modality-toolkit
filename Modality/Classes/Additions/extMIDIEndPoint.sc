+ MIDIEndPoint {
	printOn { arg stream;
		stream << this.class.name << "(" <<<*
			[device, name, uid]  <<")"
	}

	== { |anEndPoint|
		^anEndPoint.isKindOf(MIDIEndPoint)
		and: { anEndPoint.uid == this.uid
			and: { anEndPoint.name == this.name
				and: { anEndPoint.device == this.device
		}}}
	}
}