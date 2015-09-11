/*
NOT DONE YET:
* unpacking of multichan messages inAna, inDig, inComp
-> can be done with collectives now!

* figure out spec ranges for the 10 imu params

* serial input messages are raw data, how to handle?

* how to handle string only values?
  e.g. ping returns strings,
  and sending back to set stuff also
-> PassSpec for not touching raw values
*/

(
idInfo: ( srcPort: 8000, ipAddress: "169.254.1.1", recvPort: 9000 ), // ip for adhoc mode
protocol: \osc,
deviceType: \multiController,

deviceInfo: (
	vendorURI: "http://www.x-io.co.uk/products/x-osc/",
	manualURI: "http://www.x-io.co.uk/downloads/x-OSC-User-Manual-v0.4.pdf",
	description: "x-OSC is a wireless I/O board that provides just about any software with access to 32 high-performance analogue/digital channels and on-board sensors (gyroscope, accelerometer, magnetometer) via OSC messages over WiFi. There is no user programmable firmware and no software or drivers to install making x-OSC immediately compatible with any WiFi-enabled platform. All internal settings can be adjusted using any web browser.",
	features: [
		"16× analogue/digital inputs",
		"16× digital/PWM outputs (up to 50 mA per channel)",
		"13-bit ADC with 400 Hz update rate per channel",
		"Up to 16-bit PWM resolution for 5 Hz to 250 kHz",
		"Control up to 400 RGB LEDs (NeoPixel)",
		"4× serial communication channels"
	],
	notes: "",
	type: [\accelerometer, \sensor, \serial],
),
specs: (
	\switch: [0, 1, \lin, 1].asSpec,
	\pass: PassSpec,
	\imu: [-10, 10, \lin].asSpec
),
description: (
	// input elements:

// 16 integer arguments represent the state of the 16 digital inputs (0 or 1). Sent only when the state of any digital input pin changes
	inDig: (oscPath: '/inputs/digital', type: \switch, spec: \switch, numIns: 16, ioType: \in),

// 16 floating-point arguments indicate the analogue readings for all 16 inputs. Sent at the analogue input message rate
	inAna: (oscPath: '/inputs/analogue', type: \analogIn, spec: \unipolar, numIns: 16, ioType: \in),


// 16 integer arguments represent the current compare state of the 16 analogue inputs (0 if below or 1 if above the threshold). Sent only when a threshold on any channel is crossed
	inComp: (oscPath: '/inputs/analogue/comparator', type: \switch, spec: \switch, numIns: 16, ioType: \in),

	// // 1 blob argument containing the raw serial data received on input <channel> (1 – 4)
	// inS1: (oscPath: '/inputs/serial/1', inType: \blob, ioType: \in),
	// inS2: (oscPath: '/inputs/serial/2', inType: \blob, ioType: \in),
	// inS3: (oscPath: '/inputs/serial/3', inType: \blob, ioType: \in),
	// inS4: (oscPath: '/inputs/serial/4', inType: \blob, ioType: \in),

// 10 floating-point arguments indicating the current readings of the on board sensors. Arguments 1 – 3 gyroscope (°/s) x, y, z; arguments 4 – 6 accelerometer (g), x, y ,z; arguments 7 – 9 magnetometer (Ga) x, y ,z; argument 10 gyroscope temperature (°C)
	imu: (oscPath: \imu, numIns: 10, type: \imu, spec: [-10, 10].asSpec),

	// 1 float indicating the current battery voltage
	battery: (oscPath: \battery, numIns: 1, ioType: \in,
		type: \voltage, spec: [0, 3.7].asSpec),

	// // /ping: 3 string arguments are the x-OSC local IP address (1st string), MAC address (2nd string) and firmware version (3rd string)
	// ping: (oscPath: \ping, numArgs: 3, ioType: \in),


	// output elements going to XOsc:
// If x-OSC receives a message that does not match any message in the following table the LED will flash red.

	// // send new IP for XOsc as string, e.g. “169.254.1.2”
	// setIP: (oscPath: "/osc/remote/ip", ioType: \out),
	// // send new remote port number for XOsc as int16 (0 – 65535)
	// setRemotePort: (oscPath: "/osc/remote/port", ioType: \out),
	// // send new local port number for XOsc as int16 (0 – 65535)
	// setLocalPort: (oscPath: "/osc/local/port", ioType: \out),
	// // int 1 enables using bundles, 0 disables
	// useBundles: (oscPath: "/osc/bundles", ioType: \out),
	// // int 1 enables using prefix (e.g. “/xosc”), 0 disables
	// usePrefix: (oscPath: "/osc/prefix/enabled", ioType: \out),
	// // set osc address prefix string, e.g. (e.g. “/xosc”)
	// prefix: (oscPath: "/osc/prefix/address", ioType: \out)
);

// /inputs/mode/analogue/<channel>
// sets the input <channel> (1 – 16) to analogue mode
// /inputs/mode/digital/<channel>
// sets the input <channel> (1 – 16) to digital mode
// /inputs/mode/serial/<channel>
// sets the input <channel> (1 – 16) to serial mode
// /inputs/analogue/read
// prompts x-OSC to respond with an /inputs/analogue
//
// /inputs/analogue/rate
// floating-point argument sets the message rate for the analogue input readings (0.0 – 400.0)
// /inputs/analogue/comparator/read
// prompts x-OSC to respond with an /inputs/analogue/compare message
// /inputs/analogue/comparator /threshold/<channel>
// floating-point argument sets the comparator threshold (0.0 – 1.0) for the specified input <channel> (1 – 16)
// /inputs/digital/read
// prompts x-OSC to respond with an /inputs/digital message
// /inputs/digital/up/<channel>
// enables the pull up resistor for the specified digital input <channel> (1 – 16)
// /inputs/digital/down/<channel>
// enables the pull down resistor for the specified digital input <channel> (1 – 16)
// /outputs/mode/digital/<channel>
// the specified output <channel> (1 – 16) is set to digital mode
// /outputs/mode/pulse/<channel>
// the specified output <channel> (1 – 16) is set to pulse mode
// /outputs/mode/pwm/<channel>
// the specified output <channel> (1 – 16) is set to PWM mode
// /outputs/mode/serial/<channel>
// the specified output <channel> (1 – 16) is set to serial mode
// /outputs/digital/<channel>
// integer argument (0 or 1) sets the state of the specified output <channel>
// /outputs/digital/pattern
// the lower 16-bits of the integer argument sets the state of all 16 digital outputs
// /outputs/pulse/<channel>
// triggers a pulse on the specified output <channel> (1 – 16) is set to pulse mode. Uses the last width and invert values
// /outputs/pulse/width/<channel>
// integer argument sets the pulse duration in milliseconds (0 – 60000) for the specified <channel>. Also triggers a pulse
// /outputs/pulse/invert/<channel>
// integer argument (0 or 1) sets the inversion state of the pulse (1 is inverted). Also triggers a pulse
// /outputs/pwm/frequency/<channel>
// floating-point argument sets the PWM frequency (5 – 250 000) for the specified output <channel> (1 – 16). Also sets the pin to PWM mode if not already
// /outputs/pwm/duty/<channel>
// floating-point argument sets the PWM duty cycle (0 – 100 %) for the specified output <channel> (1 – 16). Also sets the pin to PWM mode if not already
// /outputs/rgb/<channel>
// blob argument will set the RGB values of LEDs connected to <channel> (1 – 16). The blob should contain bytes in the format: R1, G1, B1, R2, G2, B2 ... Rn, Gn, Bn.
// /outputs/serial/<channel>
// blob argument will be transmitted on the specified serial
// ￼
// <channel> (1 – 4)
// /led/rgb
// three integer arguments (range 0 – 255) set the RGB vales for the on board LED
// /led/default
// resets the LED to the network mode colour
// /ping
// causes x-OSC to broadcast its local IP address
// /serial/baud/<channel>
// integer argument (0 – 2000000) sets the baud rate for the specified serial <channel> (1 – 4)
// /serial/buffer/<channel>
// integer argument (1 – 2048) sets the input buffer size for the specified serial <channel> (1 – 4)
// /serial/timeout/<channel>
// the timeout of the input buffer for the specified serial <channel> (1 – 4) is set to the value of i (0 – 1000 ms)
// /serial/framing/<channel>
// integer argument (-1 – 255) sets the framing character for the specified serial <channel> (1 – 4)
)
