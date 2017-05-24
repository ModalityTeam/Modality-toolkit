MButtonView : Button {
	var <mode;
	// var <>action;
	var <>upAction;
	// var <>moveAction;

	mode_ { |modeName|
		mode = modeName;
	}
	upValue_ { |newValue = 0|
	}
}

MSliderView : Slider {
	var <mode;
	// var <>action;
	var <>upAction;
	// var <>moveAction;
	mode_ { |modeName|
		mode = modeName;
	}
	upValue_ { |newValue = 0|
	}
}

MKnobView : Knob {
	var <mode;
	// var <>action;
	var <>upAction;
	// var <>moveAction;
	mode_ { |modeName|
		mode = modeName;
	}
	upValue_ { |newValue = 0|
	}
}
