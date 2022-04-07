/**** Faderfox PC4 desc file.

// General Info:

PC4 is a 24-knob pot controller.


****/

(
  deviceName: "PC4",
  protocol: \midi,
  deviceType: \faderbox,
  elementTypes: [\knob],
  status: (
    linux: "unknown",
    osx: "tested and working",
    win: "unknown"
  ),

  idInfo: "Faderfox PC4",

  deviceInfo: (
    vendorURI: "http://faderfox.de/pc12.html",
    manualURI: "http://www.faderfox.de/PDF/PC4%20Manual%20V03.PDF",
    hardwarePages: (1..16),
    longName: "Faderfox PC4",
  ),

  elementsDesc: (
    elements: 15.collect { |chan|
      (
        key: ("B" ++ chan).asSymbol,
        shared: ('midiChan': chan, \page: chan),
        elements: [
          (
            key: \kn,
            shared: (
              'midiMsgType': \cc,
              'midiChan': chan,
              'elementType': \knob,
              'spec': \midiCC

            ),
            elements: (1..24).collect { |knob_num|
              (
                key: knob_num.asSymbol,
                midiNum: knob_num,
              )
            }
          ),
        ]
      )
    };
  )
)
