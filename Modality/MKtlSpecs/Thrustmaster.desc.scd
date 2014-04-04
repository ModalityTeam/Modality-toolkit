(osx: (
	device: "MegaWorldectronics_USB Joystick"
),
linux: (
	device: ""
),
protocol: \hid,
description: (

// --------- input elements ----------
'b1': ('hidUsage': 1, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
'b2': ('hidUsage': 2, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
'b3': ('hidUsage': 3, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
'b4': ('hidUsage': 4, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
'Hat': ('hidUsage': 57, 'hidUsagePage': 1, 'type': 'slider', 'ioType': 'in', spec: \cent1, mode: \center ),
'X': ('hidUsage': 48, 'hidUsagePage': 1, 'type': 'slider', 'ioType': 'in',  spec: \cent1, mode: \center ),
'Y': ('hidUsage': 49, 'hidUsagePage': 1, 'type': 'slider', 'ioType': 'in',  spec: \cent1, mode: \center ),
'Slider': ('hidUsage': 187, 'hidUsagePage': 2, 'type': 'slider', 'ioType': 'in', spec: \cent1, mode: \center ),
)
)