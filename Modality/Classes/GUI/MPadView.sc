MPadView : SCViewHolder {

	classvar <modes;

	var <value = 0, <upValue = 0, <moveValue = 0;
	var <pressed = false;
	var <useValue = true, <useUpValue = false, <useMoveValue = false;
	var <>autoUpTime = inf;
	var <baseColor, <hiliteColor;
	var <label;
	var <font;
	var <vShiftLabel = 0;
	var <>action, <>upAction, <>moveAction;
	var <mode = \noteOnOff;

	var upTimeTask, upTask, upValueScaled = 0;

	*initClass {
		modes = (
			noteOnOff: [true, false, false, inf],

			noteOnOffBut: [false, false, false, inf],
			noteOnTrig: [false, true, false, 0.1],
			noteOnVel: [true, true, false, 0.1],
			noteOnOffTouch: [true, false, true, inf],

			noteOnOffVel: [true, true, false, inf],
			noteOnOffVelTouch: [true, true, true, inf],
			noteOnOffButCtl: [true, true, true, inf],
			noteOnOffCtl: [true, true, true, inf]
		);
	}

	*modeKeys { ^modes.keys(Array).sort }

	*new { |parent, bounds|
		^super.new.init( parent, bounds );
	}

	mode_ { |modeName|
		var modeValues = modes[modeName];
		if (modeValues.isNil) {
			"%: mode % not found. modes: %\n"
			.postf(thisMethod, modeName, modes.keys(Array).sort);
			^this;
		};
		this.useValue = modeValues[0];
		this.useUpValue = modeValues[1] ? useUpValue;
		this.useMoveValue = modeValues[2] ? moveValue;
		this.autoUpTime = modeValues[3] ? autoUpTime;

		mode = modeName;
	}

	baseDrawFunc {
		^{ |vw|
			var rect, fillRect, fillRect2, fillColor;
			var halfColor = hiliteColor.copy.alpha_( hiliteColor.alpha * 0.5 );
			var name;

			rect = vw.bounds.moveTo(0, 0).insetBy(1,1);
			if( pressed ) {
				Pen.width = 2;
				fillColor = hiliteColor;
				fillRect = rect.insetAll(0, (1 - value) * rect.height,0,0 );
				if (useMoveValue) {
					fillRect2 = rect.insetAll(0, (1 - moveValue) * rect.height, 0, 0 );
				};
			} {
				if( useUpValue && { upValueScaled > 0 }) {
					fillColor = halfColor;
					fillRect = rect.insetAll(0, (1 - upValueScaled) * rect.height,0,0 );
				};
			};

			Pen.fillColor = baseColor;
			Pen.fillRect( rect );

			if( fillRect.notNil ) {
				Pen.fillColor = fillColor;
				Pen.fillRect( fillRect );
			};
			if( fillRect2.notNil ) {
				Pen.fillColor = halfColor;
				Pen.fillRect( fillRect2 );
			};

			Pen.strokeColor = Color.black;
			Pen.strokeRect( rect );
			if( label.notNil ) {
				Pen.use({
					Pen.font = font;
					Pen.color = baseColor.complementary;
					Pen.stringCenteredIn(
						MKtlGUI.splitLabel(label),
						rect.insetAll( 0, vShiftLabel * 2, 0, 0 )
					);
				});
			};
		};
	}

	setColors {
		baseColor = Color.white;
		hiliteColor = Color.red(0.75,0.5);
	}

	init { |parent, bounds, argMode = \noteOnOff|
		this.setColors;

		this.view = UserView( parent, bounds );
		this.view.drawFunc = this.baseDrawFunc;

		this.view.mouseDownAction = { |vw, x, y|
			this.valueAction = y.linlin( 0, vw.bounds.height, 1, 0 );
		};
		this.view.mouseMoveAction = { |vw, x, y|
			if (useMoveValue) {
				this.moveValueAction = y.linlin( 0, vw.bounds.height, 1, 0 );
			};
		};

		this.view.mouseUpAction = { |vw, x, y|
			if( autoUpTime == inf ) {
				this.upValueAction = y.linlin( 0, vw.bounds.height, 1, 0 );
			};
		};

		this.mode_(argMode);

		this.refresh;
	}

	doUpAction { upAction.value( this ) }

	doAction { action.value( this ) }

	stopTasks {
		upTimeTask.stop;
		upTask.stop;
		upValueScaled = 0;
	}


	value_ { |newValue = 0|
		this.stopTasks;
		if (useValue.not) { newValue = newValue.sign.max(0); };
		value = newValue;
		pressed = true;
		this.refresh;
		if( autoUpTime < inf ) {
			upTimeTask = Task({
				autoUpTime.wait;
				this.upValue = value;
			}, AppClock).start;
		};
	}

	valueAction_ { |newValue = 0|
		this.value = newValue;
		this.doAction;
	}

	upValue_ { |newValue = 0|
		this.stopTasks;
		moveValue = 0;
		if( useUpValue ) {
			upValue = newValue;

			pressed = false;
			upValueScaled = upValue;
			upTask = Task({
				while { upValueScaled > 0 } {
					0.05.wait;
					upValueScaled = upValueScaled - 0.05;
					this.refresh;
				};
				upValueScaled = 0;
			}, AppClock).start;
		} {
			if( pressed != false ) {
				pressed = false;
			};
		};
		this.refresh;
	}

	upValueAction_ { |newValue = 0|
		this.upValue = newValue;
		this.doUpAction;
	}

	moveValue_ {|newValue = 0|
		moveValue = newValue;
		this.refresh;
	}

	moveValueAction_ {|newValue = 0|
		this.moveValue_(newValue);
		this.doMoveAction;
		this.refresh;
	}

	doMoveAction {|newValue = 0|
		moveAction.value(this);
	}

	label_ { |string|
		label = string;
		this.refresh;
	}

	vShiftLabel_ { |number = 0|
		vShiftLabel = number;
		this.refresh;
	}

	font_ { |aFont|
		font = aFont;
		this.refresh;
	}

	pressed_ { |bool = false|
		pressed = bool;
		this.refresh;
	}

	useValue_ { |bool = true|
		useValue = bool;
		if (bool.not) { value = 0 };
		this.refresh;
	}

	useUpValue_ { |bool = true|
		useUpValue = bool;
		if (bool.not) { upValue = 0 };
		this.refresh;
	}

	useMoveValue_ { |bool = true|
		useMoveValue = bool;
		if (bool.not) { moveValue = 0 };
		this.refresh;
	}

	baseColor_ { |color|
		baseColor = color;
		this.refresh;
	}

	hiliteColor_ { |color|
		hiliteColor = color;
		this.refresh;
	}
}

MPadUpViewRedirect {

	// creates a spoof View object which redirects upValue and upAction to value and action
	var <view, <action;

	*new { |view| // must be an MPadView
		^super.newCopyArgs( view );
	}

	value { ^view.upValue }
	value_ { |val| view.upValue_( val ) }
	valueAction_ { |val| view.upValueAction_( val ) }

	action_ { |func|
		action = func;
		view.upAction = { action.value( this ) };
	}

	addAction { |act| this.action = action.addFunc( act ) }

	removeAction { |act| this.action = action.removeFunc( act ) }

	doesNotUnderstand { |selector ...args|
		var res;
		res = view.perform( selector, *args );
		if( res != view ) {
			^res;
		};
	}
}

MPadMoveViewRedirect : MPadUpViewRedirect {

	*new { |view| // must be an MPadView
		^super.newCopyArgs( view );
	}

	value { ^view.moveValue }
	value_ { |val| view.moveValue_( val ) }
	valueAction_ { |val| view.moveValueAction_( val ) }

	action_ { |func|
		action = func;
		view.moveAction = { action.value( this ) };
	}
}
