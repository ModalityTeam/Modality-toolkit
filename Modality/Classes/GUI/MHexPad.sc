
MHexPad : MPadView {
	var <>hexColor, <>ledColors, <ledVal = 0, <angle = 0.5pi;
	var <upDoesAction = true;

	*initClass {
		Class.initClassTree(MPadView);
		modes.put(\noteOnLed, [true, false, true, inf]);
	}

	setColors {
		baseColor = Color.clear;
		hexColor = Color.grey(0.5, 0.5);
		hiliteColor = Color.white.alpha_(0.5);
		ledColors =  [baseColor, Color(1.0, 0.75, 0, 0.7), Color(1.0, 0.25, 0, 0.7)];
		ledVal = 0;
	}

	ledVal_ { |val| ledVal = val; this.refresh }
	angle_ { |val| angle = val; this.refresh }

	upDoesAction_ { |bool = true|
		upDoesAction = bool;
		if (bool.not) {
			this.view.mouseUpAction = { |vw, x, y|
				if( autoUpTime == inf ) {
					this.upValueAction = y.linlin( 0, vw.bounds.height, 1, 0 );
				};
			};
		} {
			this.view.mouseUpAction = { |vw, x, y|
				this.upValue_(0);
				this.valueAction = 0;
				this.pressed = false;
			};
		}
	}

	baseDrawFunc {
		^{ |vw|
			var bounds = vw.bounds, center = (bounds.extent * 0.5);
			var halfColor = hiliteColor.copy.alpha_( hiliteColor.alpha * 0.5 );
			var rect, fillRect, fillRect2, fillColor;

			var hexPoints = 7.collect { |i| Polar(center.y, 2pi * (i/6) + angle).asPoint + center };
			Pen.fillColor = hexColor;
			Pen.moveTo(hexPoints.last); hexPoints.do(Pen.lineTo(_));
			Pen.fill;

			if( pressed ) {
				Pen.width = 4;
				Pen.strokeColor_(hiliteColor);
				Pen.addArc(center, value * center.y, 0, 2pi);
				Pen.stroke;
				if (useMoveValue) {
					Pen.fillColor_(halfColor);
					Pen.addArc(center, moveValue * center.y, 0, 2pi);
					Pen.fill;
				};
			};
			if (ledVal > 0) {
				Pen.addArc(center, center.y * 0.25, 0, 2pi);
				Pen.fillColor_(ledColors[ledVal]);
				Pen.fill;
			};
			if( label.notNil ) {
				Pen.use({
					Pen.font = font;
					Pen.color = baseColor.complementary.alpha_(1.0);
					Pen.stringCenteredIn(
						MKtlGUI.splitLabel(label),
						bounds.moveTo(0,vShiftLabel);
					);
				});
			};
		};
	}
}

MRoundPad : MHexPad {
	baseDrawFunc {
		^{ |vw|
			var bounds = vw.bounds, center = (bounds.extent * 0.5);
			var halfColor = hiliteColor.copy.alpha_( hiliteColor.alpha * 0.5 );
			var rect, fillRect, fillRect2, fillColor;

			// only background shape is different
			Pen.fillColor = hexColor;
			Pen.addArc(center, center.y, 0, 2pi);
			Pen.fill;

			if( pressed ) {
				Pen.width = 4;
				Pen.strokeColor_(hiliteColor);
				Pen.addArc(center, value * center.y, 0, 2pi);
				Pen.stroke;
				if (useMoveValue) {
					Pen.fillColor_(halfColor);
					Pen.addArc(center, moveValue * center.y, 0, 2pi);
					Pen.fill;
				};
			};
			if (ledVal > 0) {
				Pen.addArc(center, center.y * 0.25, 0, 2pi);
				Pen.fillColor_(ledColors[ledVal]);
				Pen.fill;
			};
			if( label.notNil ) {
				Pen.use({
					Pen.font = font;
					Pen.color = baseColor.complementary.alpha_(1.0);
					Pen.stringCenteredIn(
						MKtlGUI.splitLabel(label),
						bounds.moveTo(0,vShiftLabel);
					);
				});
			};
		};
	}
}