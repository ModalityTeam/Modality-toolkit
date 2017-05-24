MButtonView : Button {
	var <mode;
	// var <>action;
	var <>upAction;
	// var <>moveAction;

	mode_ { |modeName|
		mode = modeName;
	}
	upValue_ { |newValue = 0|
		this.value_( newValue );
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
		this.value_( newValue );
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
		this.value_( newValue );
	}
}
