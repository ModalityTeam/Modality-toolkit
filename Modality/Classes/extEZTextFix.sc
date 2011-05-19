+ EZText {
	value_ { |inval|
		var string; 
		value = inval; 
		if (inval.isKindOf(String).not) { 
			string = value.asCompileString 
		} { 
			string = value
		};
		textField.string = string;
	}
}