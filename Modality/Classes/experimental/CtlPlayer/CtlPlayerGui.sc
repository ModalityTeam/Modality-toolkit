CtlPlayerGui : JITGui {

    var <isSmall = false;

    var <nameBut;
    var <loopRecBut, <loopPlayBut;

    var <monitor;

    var <proxyGui, <loopGui;
    // *small version:
    // name - volume/playing/channel - loop play/rec

    // *big version
    //

    * small { |obj, numItems = 4, parent, bounds, makeSkip = true|
        ^this.new(obj, numItems, parent, bounds, makeSkip, [\small]).proxyObject_( obj );
	}

    proxyObject_{ |obj|
        if ( obj.isKindOf( CtlPlayer) ){
            monitor.proxy_( obj.synthproxy );
        }
    }

    accepts { |obj| ^(obj.isNil) or: { obj.isKindOf(CtlPlayer) }; }


    setDefaults { |options|
		defPos = 10@100;

		if (parent.notNil) { skin = skin.copy.put(\margin, 0@0) };

        if ( options.notNil and: { options.includes(\small) } ){
            minSize = 400 @ skin.buttonHeight;
        }{
            minSize = 400 @ 400;
        }

	//	"% - minSize: %\n".postf(this.class, minSize);
	}

    makeViews{ |options|
        isSmall = options.notNil and: { options.includes(\small) };

        this.makeViewsSmall( options );
        if ( isSmall.not ){
            this.makeViewsBig( options );
        }
    }

    makeViewsBig{ |options|
        // var height = skin.buttonHeight;
        // var lineWidth = zone.bounds.width - (skin.margin.y * 2);
        // var width = 25; // lineWidth * 0.62 / 4;
        // var nameWidth = 100; // lineWidth * 0.38 - 1;
        // var zoneMargin = if ( (numItems > 0) or: { parent.isKindOf(Window.implClass) }) { skin.margin } { 0@0 };

        var proxyZone;
        var loopZone;

        // zone.decorator = FlowLayout(zone.bounds, zoneMargin, skin.gap);

        StaticText.new( zone, zone.bounds.width@5 ).background_( Color.black );

        loopZone = CompositeView.new( zone, (zone.bounds.width)@( 160 ) );
        loopZone.background_( Color.white );
        loopGui = CtLoopGui.new( nil, parent: loopZone, bounds: (zone.bounds.width - skin.margin)@( 160 ), makeSkip: false );

        StaticText.new( zone, zone.bounds.width@5 ).background_( Color.black );

        proxyZone = CompositeView.new( zone, (zone.bounds.width)@(zone.bounds.height - 175 ) );
        proxyGui = NodeProxyEditor.new( nil, parent: proxyZone, monitor: false );



    }

    object_{ |object|
        super.object_( object );
        if ( object.isKindOf( CtlPlayer ) ){
            if ( isSmall ){
                monitor.proxy_( object.synthproxy );
            }{
                monitor.proxy_( object.synthproxy );
                proxyGui.proxy_( object.synthproxy );
                proxyGui.name_( object.key );
                loopGui.object_( object.ctLoop );
            }
        }
    }

    makeViewsSmall { |options|
		var height = skin.buttonHeight;
		var lineWidth = zone.bounds.width - (skin.margin.y * 2);
		var width = 25; // lineWidth * 0.62 / 4;
		var nameWidth = 100; // lineWidth * 0.38 - 1;
		var zoneMargin = if ( (numItems > 0) or: { parent.isKindOf(Window.implClass) }) { skin.margin } { 0@0 };

		zone.decorator = FlowLayout(zone.bounds, zoneMargin, skin.gap);

        if ( isSmall.not ){
            StaticText.new( zone, zone.bounds.width@5 ).background_( Color.black );
        };

		nameBut = Button(zone, Rect(0,0, nameWidth, height))
			.font_(font)
			.resize_(2)
			.states_([
				[" ", skin.fontColor, skin.onColor]
			]);

        monitor = ProxyMonitorGui( nil, zone,
            zone.bounds.width - 4 - nameWidth - (width + skin.margin.x * 2) @ (skin.buttonHeight),
			showName: false, makeWatcher: false);

        loopPlayBut = Button(zone, Rect(0,0, width, height))
			.font_(font)
			.resize_(3)
			.states_([
				[" >", skin.fontColor, skin.offColor],
				[" _", skin.fontColor, skin.onColor ],
				[" |", skin.fontColor, skin.offColor ]
			])
			.action_({ |but|
				[ { object.ctLoop.play }, { object.ctLoop.play }, { object.ctLoop.stop } ][but.value].value;
				this.checkUpdate;
			});

        loopRecBut = Button(zone, Rect(0,0, width, height))
			.font_(font)
			.resize_(3)
			.states_([
				["rec", skin.fontColor, skin.offColor],
				["stop", Color.white, Color.red]
			])
			.action_({ |but|
				[ { object.ctLoop.stopRec }, { object.ctLoop.startRec } ][but.value].value;
			});

	}

    getState {
		if (object.isNil) {
			^(object: nil, name: " ", isPlaying: false, isRecording: false,
			reverse: false, inverse: false, rescaled: false);
		};

		^(
			object: object,
			name: object.key,

			loopIsPlaying: object.ctLoop.isPlaying.binaryValue,
			loopIsRecording: object.ctLoop.isRecording.binaryValue,
			loopIsActive: object.ctLoop.task.isActive.binaryValue,
			loopCanPause: object.ctLoop.task.canPause.binaryValue,
			loopIsPaused: object.ctLoop.task.isPaused.binaryValue,

			loopIsReversed: object.ctLoop.isReversed.binaryValue,
			loopIsInverse: object.ctLoop.isInverse.binaryValue,
			loopRescaled: (object.ctLoop.scaler == 1).binaryValue,

			loopTempo: object.ctLoop.tempo,
			loopStart: object.ctLoop.start,
			loopLength: object.ctLoop.length,
			loopJitter: object.ctLoop.jitter,
			loopScaler: object.ctLoop.scaler,
			loopShift: object.ctLoop.shift
		);
	}

    checkUpdate {
		var newState = this.getState;
		var loopPlayState;

		if (newState == prevState) {
		//	"no change.".postln;
			^this
		};

		if (newState[\object].isNil) {
		//	"no object.".postln;
			prevState = newState;
			zone.visible_(false);
			^this;
		};

//        if ( isSmall ){
            if (newState[\name] != prevState[\name]) {  // name
                zone.visible_(true);
                nameBut.states_(nameBut.states.collect(_.put(0, object.key.asString))).refresh;
            };

            loopPlayState = newState[\loopIsPlaying] * 2 - newState[\loopIsActive];
            newState.put(\loopPlayState, loopPlayState);

            if (loopPlayState != prevState[\loopPlayState]) {
                // stopped/playing/ended
                // 0 is stopped, 1 is active, 2 is playing but waiting:
                loopPlayBut.value_(loopPlayState).refresh;
            };

            if (newState[\loopIsRecording] != prevState[\loopIsRecording]) {
                loopRecBut.value_(newState[\loopIsRecording]).refresh;
            };

            // if ( object.isKindOf( CtlPlayer ) ){
            //     monitor.proxy_( object.synthproxy );
            // };
            monitor.updateAll;
    //    }
        if ( isSmall.not ){
            proxyGui.checkUpdate;
            loopGui.checkUpdate;
        };

		prevState = newState.copy;
	}

}

CtlPlayerAllGui : JITGui {

    var <editZone;
    var <edits;
    var <names, <keysRotation=0;

    // list of small versions

    *new { |obj, numItems = 16, parent, bounds, makeSkip = true, options|
		^super.new(obj, numItems, parent, bounds, makeSkip, options);
	}

    setDefaults {
		var width = 400;
		var height = numItems * skin.buttonHeight + skin.headHeight + 20;

		skin = GUI.skins.jit;
		font = Font(*skin.fontSpecs);

        minSize = width@height;

		defPos = 10@260;
	}

    makeViews {
        // parent.bounds_(parent.bounds.extent_(sizes[\mid] + (8@8)));

        // if (parent.isKindOf(Window.implClass)) {
        //     parent.name = this.class.observedClass.name ++ ".all";
        // };

        // zone.decorator.gap_(6@6);
		zone.resize_(1).background_(Color.grey(0.7));

        editZone = CompositeView(zone, Rect(0, 0, 400 ,minSize.y ))
			.background_(skin.foreground);
		editZone.addFlowLayout(skin.margin, skin.gap);

        edits = Array.fill(numItems, {
            CtlPlayerGui.small(
                numItems: 0,
                parent: editZone,
                bounds: Rect(0,0, editZone.bounds.width - 16, skin.buttonHeight; ),
                makeSkip: false
            )
		});

        scroller = EZScroller(parent,
			Rect(0, 0, 12, numItems * skin.buttonHeight),
			numItems, numItems,
			{ |sc| keysRotation = sc.value.asInteger.max(0) }
		).visible_(false);

		scroller.slider.resize_(3);

	}

    checkUpdate{
        var overflow, tooMany;
        names = CtlPlayer.all.keys.as(Array);
        try { names.sort };

        overflow = (names.size - numItems).max(0);
			if (overflow > 0) {
				scroller.visible_(true);
				scroller.numItems_(names.size);
				scroller.value_(keysRotation ? overflow);
				names = names.drop(keysRotation).keep(numItems);
			} {
				scroller.visible_(false);
			};
        edits.do { |edit, i|
            edit.object_( CtlPlayer.all[ names[i] ] ).checkUpdate;
        };
        //if (tpGui.notNil) { tpGui.checkUpdate };
    }

}