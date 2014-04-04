(
protocol: \hid,
device: "Jess Tech_Dual Analog Pad",
description: (
// --------- input elements ----------
'b1': ('hidUsage': 5, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
'b2': ('hidUsage': 6, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
'b3': ('hidUsage': 7, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
'b4': ('hidUsage': 8, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
'b5': ('hidUsage': 9, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
'b6': ('hidUsage': 10, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
'b7': ('hidUsage': 11, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
'b8': ('hidUsage': 12, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
'b9': ('hidUsage': 16, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),

'hat': ('hidUsage': 57, 'hidUsagePage': 1, 'type': 'hatSwitch', 'ioType': 'in', spec: \cent1, mode: \center),

'joyLX': ('hidUsage': 48, 'hidUsagePage': 1, 'type': 'joyAxis', 'ioType': 'in', spec: \cent1, mode: \center ),
'joyLY': ('hidUsage': 49, 'hidUsagePage': 1, 'type': 'joyAxis', 'ioType': 'in', spec: \cent1, mode: \center ),
'joyRX': ('hidUsage': 50, 'hidUsagePage': 1, 'type': 'joyAxis', 'ioType': 'in', spec: \cent1, mode: \center ),
'joyRY': ('hidUsage': 53, 'hidUsagePage': 1, 'type': 'joyAxis', 'ioType': 'in', spec: \cent1, mode: 'center' ),

// --------- output elements ----------
)
)