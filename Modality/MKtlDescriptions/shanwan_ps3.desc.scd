(
    idInfo: "PS3/PC Wired GamePad_ShanWan",
    protocol: 'hid',
    deviceName: "PS3/PC Wired GamePad_ShanWan",
    deviceType: 'gamepad',
    elementTypes: ['joyAxis', 'button', 'compass', 'rumble'],
    status: (
        linux: "tested working 27-02-2020, not sure about the rumble",
        osx: "not sure",
        win: "unknown"
    ),
    deviceInfo: (
        vendorURI: 'https://www.kjell.com/no/produkter/lyd-og-bilde/dataspill-og-gaming/playstation-3/arrogant-frostbite-gamepad-p61887',
        manualURI: '',
        description: "Cheap ps3 controller knockoff bought from Kjell in Norway. It seems to be based on a common chinese PS3 controller clone named ShanWan",
        features: [],
        notes: "To get it to work: 1. Set the slider on the back of the controller to D (direct input), 2. Press the home button once, so that two led's are lit up on the front of the controller.",
        hasScribble: false
    ),
    elementsDesc: (
        elements: [
			// Buttons
            (key: 'bt',
                shared: ('hidUsagePage': 9, 'elementType': 'button', 'ioType': 'in', 'spec': 'hidBut', mode: 'push'),
                elements: [
                    ( key: 'y', 'hidUsage': 1), 
                    ( key: 'b', 'hidUsage': 2), 
                    ( key: 'a', 'hidUsage': 3), 
                    ( key: 'x', 'hidUsage': 4), 
                    ( key: 'l1', 'hidUsage': 5), 
                    ( key: 'r1', 'hidUsage': 6), 
                    ( key: 'l2', 'hidUsage': 7), 
                    ( key: 'r2', 'hidUsage': 8), 
                    ( key: 'sel', 'hidUsage': 9), 
                    ( key: 'start', 'hidUsage': 10), 
                    ( key: 'hat_l', 'hidUsage': 11), 
                    ( key: 'hat_r', 'hidUsage': 12), 
                ]
            ),
			// Joy sticks
            (key: 'joy',
                shared: ('hidUsagePage': 1, 'elementType': 'joyAxis', 'ioType': 'in', 'spec': 'cent1'),
                elements:[
                    (key: 'l', elements: [
                        ( key: 'x', 'hidUsage': 4), 
                        ( key: 'y', 'hidUsage': 48), 
                    ]),
                    (key: 'r', elements: [
                        ( key: 'x', 'hidUsage': 49), 
                        ( key: 'y', 'hidUsage': 50), 
                    ]),
                ]
            ),
			// Compass
            ( key: 'compass', 'hidUsage': 57, 'hidUsagePage': 1, 'elementType': 'compass', 'ioType': 'in', mode: 'center', spec: 'unipolar' ),  
        /***************** output elements *****************/
        (
			key: 'rumble1', 'hidElementID': 20, 'elementType': 'rumble', 'ioType': 'out',
			spec: \lin255, mode: \minimum ),
		(
			key: 'rumble2', 'hidElementID': 21, 'elementType': 'rumble', 'ioType': 'out',
			spec: \lin255, mode: \minimum ),
        ]
    )
);
