+ HIDElement {
	printOn { | stream |
		super.printOn(stream);
		stream << "(id: " << id << ", type: " << type
		<< ", usage: " << usage << ", usagePage: " << usagePage
		<< ")";
	}
}