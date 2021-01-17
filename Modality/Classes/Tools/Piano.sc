/*

measurements from real keyboard in cm:
octave distance = 16.4
white key length = 15.2
white key width = 2.2
white key spacing = (16.4 / 7) = 2.35

black key length = 9.8
black key width = 1.4
black key spacing = 2.65

ratio of lengths = 9.8 / 15.2 = 1 : 0.65
ratio of spacings = 2.65 / 2.2 = 1.2 : 1

*/

Piano {
	classvar <blackNotes =#[1, 3, 6, 8, 10];
	classvar <whiteXs = #[0, 1, 2, 3, 4, 5, 6];
	classvar <blackXs = #[0.4, 1.6, 3.3, 4.5, 5.7];
	classvar <allXs, <all12;

	*initClass {
		allXs = [whiteXs, blackXs].flat.sort;
		all12 = allXs.collect { |xpos, i|
			if (blackNotes.includes(i)) {
				(color: \black, x: xpos, y: 0, h: 1.2, w: 0.6, chroma: i);
			} {
				(color: \white, x: xpos, y: 1, h: 2, w: 0.96, chroma: i);
			};
		};
	}

	*pos { |note = 48, start = 48|
		var noteIndex = note % 12;
		var model = all12.wrapAt(noteIndex);
		var startXpos = (start div: 12 * 7) + all12.wrapAt(start).x;
		var noteXpos = (note div: 12 * 7) + all12.wrapAt(note).x;
		^model.copy.put(\note, note).put(\x, noteXpos - startXpos);
	}

	*layout { |from = 48, to = 72|
		^(from..to).collect ( Piano.pos(_, from));
	}
}

