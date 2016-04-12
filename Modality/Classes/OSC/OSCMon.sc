/* ToDo:
- show list of addrs found on lines
- show list of message names found
auto-refresh every 0.5 sec?
*/

OSCMon {
	classvar <colors;
	var <>bufsize, <>timeWindow, <listenFunc, <>action, <addresses, <msgNames;
	var <list, <w, <u;
	var <>verbose = false, <>watchStatus = false;
	var <>trackAddrs = true, <>trackMsgs = true;
	var <enabled = false;
	var <anaDict;

	*prepColors {
		colors = colors ?? {
			[Color.black] ++ 8.collect { |i| Color.hsv(i / 8, 0.8, 0.8, 0.7) }
			.at([0, 4, 2, 6, 1, 5, 3, 7]);
		};
	}

	*new { |bufsize = 100, timeWindow = 60, action|
		^super.newCopyArgs(bufsize, timeWindow, action).init(action);
	}

	trace { |flag = true| verbose = flag }

	addAddr { |addr|
		if (addresses.includesEqual(addr).not) { addresses = addresses.add(addr) }
	}
	removeAddr { |addr| addresses.remove(addr) }
	clearAddrs { addresses.clear }

	addMsgName { |name|
		if (msgNames.includesEqual(name).not) { msgNames = msgNames.add(name) }
	}

	removeMsgName { |name| msgNames.remove(name) }
	clearMsgNames { msgNames.clear }

	refreshAddrsAndNames {
		this.clearMsgNames.clearAddrs;
		list.do { |entry|
			this.addAddr(entry[1]).addMsgName(entry[2][0]);
		};
	}

	enable { thisProcess.addOSCRecvFunc(listenFunc); enabled = true }
	disable { thisProcess.removeOSCRecvFunc(listenFunc); enabled = false }

	addNickname { |name, addr|
		anaDict[\nicknames].put(addr, name);
	}
	removeNickname { |name|
		var addr = anaDict[\nicknames].findKeyForValue(name);
		anaDict[\nicknames].removeAt( addr);
	}
	nameOrAddr { |addr| ^anaDict[\nicknames][addr] ? addr }

	addDefaultNicknames {
		this.addNickname(\homeserver, Server.default.addr);
		this.addNickname(\homeclient, NetAddr.localAddr);
	}

	init { |argAction|
		this.class.prepColors;

		action = argAction;
		list = [];
		addresses = List[];
		msgNames = List[];
		anaDict = (nicknames: Dictionary[],
			messagesByAddr: Dictionary[],
			msgNamesByAddr: Dictionary[]
		);

		this.addDefaultNicknames;

		listenFunc = { |msg, t, sender|
			var arr, nick;
			if (trackAddrs) { this.addAddr(sender) };
			if (trackMsgs) { this.addMsgName(msg[0]) };

			nick = anaDict[\nicknames][sender];

			if (addresses.isEmpty or: { addresses.any(_ == sender) }) {
				if (watchStatus or: { msg[0] != '/status.reply' }) {

					arr = [t, sender, nick, msg];
					if (verbose, { arr.postln });
					this.addToList(arr);
					this.analyse(arr);
					action.value(this);
					this.refresh;
				};
			};
		}
	}

	analyse { |arr|
		var addr = arr[1], nick = arr[2], msg = arr[3];
		var msgList = anaDict[\messagesByAddr][addr];
		var msgNameList = anaDict[\msgNamesByAddr][addr];
		var msgName = msg[0];

		if (msgList.isNil) { msgList = List[];
			anaDict[\messagesByAddr][addr] = msgList;
		};
		msgList = msgList.add(msg).keep(bufsize);

		if (msgNameList.isNil) { msgNameList = List[];
			anaDict[\msgNamesByAddr][addr] = msgNameList;
		};
		if (msgNameList.includes(msgName).not) {
			msgNameList.add(msgName);
		};
	}

	addToList { |arr|
		var endIndex;
		var now = arr[0];

		list = list.addFirst(arr);
		endIndex = list.size;
		// find last index within time limit:
		while {
			endIndex = endIndex - 1;
			(endIndex >= 0) and:
			{ (now - list[endIndex][0]) > timeWindow };
		};
		// then cut by bufsize or time
		list = list.keep(min(bufsize, endIndex + 1));
	}

	postInfo {
		"----\n%: % messages in last % seconds.\n".postf(
			this, list.size, thisThread.seconds - list.last[0]);
		"addresses: %\n".postf(list.collectAs(_[1], Set));
		"msgNames: %\n----\n".postf(list.collectAs({ |entry| entry[3][0] }, Set));
	}

	refresh {
		defer { if (w.notNil and: { w.isClosed.not }) { w.refresh } };
	}

	free {
		this.disable;
		w.close; w = u = nil;
	}

	show { |name, bounds|
		if (w.isNil or: { w.isClosed }) {
			bounds = bounds ?? { Rect(20, 20, 300, 100) };
			w = Window("osc msg mon", bounds).front;
			w.addFlowLayout;

			Button(w, Rect(0,0, 45, 20)).states_(
				[[\on, Color.black, Color.grey(0.7)],
				[\off, Color.black, Color.green(0.9)]])
			.action_({ |b|
				if (b.value > 0) { this.enable } {this.disable };
			})
			.value_(enabled.binaryValue);
			Button(w, Rect(0,0, 45, 20)).states_(
				[[\verbose, Color.black, Color.grey(0.7)],
				 [\verbose, Color.black, Color.green(0.9)]])
			.action_({ |b|
				this.verbose = b.value > 0;
			}).value_(verbose.binaryValue);
			Button(w, Rect(0,0, 45, 20)).states_(
				[[\status, Color.black, Color.grey(0.7)],
				 [\status, Color.black, Color.green(0.9)]])
			.action_({ |b|
				this.watchStatus = b.value > 0;
			}).value_(watchStatus.binaryValue);
			Button(w, Rect(0,0, 45, 20)).states_(
				[[\INFO, Color.black, Color.grey(0.7)]])
			.action_({ this.postInfo; });


			u = UserView(w, w.bounds.moveTo(0,0).insetBy(4, 4).height_(64));
			u.background_(Color.white);
			u.resize_(5);

			u.drawFunc = {
				var ubounds = u.bounds;
				var point, size;
				var rescale = [ubounds.width / 300, ubounds.height / 64];

				var firstDur, lastDur, totalDur, scaler;
				var numTracks, trackHeight, trackYCenters;

				if (list.notEmpty) {
					firstDur = thisThread.seconds;
					lastDur = list.last[0];
					totalDur = firstDur - lastDur;
					scaler = 180 / totalDur.max(1);

					numTracks = addresses.size;
					trackHeight =(64/numTracks);
					trackYCenters = addresses.collect { |addr, i|
						i + 0.5 * trackHeight;
					};

					Pen.scale(*rescale);

					// addr info:
					addresses.do { |addr, i|
						var trackYTop = i * trackHeight;
						var nickname = anaDict[\nicknames][addr] ? "";
						var addrString = "%\n%\n%".format(
							addr.ip, addr.port, nickname ? "");
						var addrRect = Rect(0, i * trackYTop, 100, trackHeight);

						Pen.color = colors[i];
						Pen.addRect(addrRect);

						Pen.stringCenteredIn(
							addrString,
							addrRect,
							Font("Helvetica", 10)
						);
						Pen.stroke;
					};

					list.do { |event, i|

						var addr = event[1];
						var nickname = event[2];
						var msg = event[3];
						var trackIndex = addresses.indexOfEqual(addr) % numTracks;
						var trackYCenter = trackYCenters[trackIndex];


						point = (firstDur - event[0] * scaler + 110)
							@ trackYCenter;
						Pen.color = colors[i];
						Pen.addOval(Rect.aboutPoint(point, 2, msg.size));
						Pen.stroke;
					};
				};
			};
			u.animate_(true).frameRate_(10);

			u.keyDownAction = { |u, char|
				"OSCMon keyDown: %\n".postf(char);
				if (char.isDecDigit) {
					this.postMessagesFrom(char.asString.interpret);
				};
				if (char == $ ) { this.enable; "enable".postln };
				if (char == $.) { this.disable; "disable".postln };
				if (char == $s) { this.watchStatus = true; "status".postln };
				if (char == $x) { this.watchStatus = false; "nostatus".postln };
				if (char == $?) { this.postInfo; };
				if (char == $h) { "/* this.postHelp; */".postln };
			};
		};
	}

	postMessagesFrom {|index|
		var addr = addresses[index];
		if (addr.isNil) { ^this };
		anaDict[\msgNamesByAddr][addr].postcs;
		anaDict[\messagesByAddr].[addr].printcsAll;
	}
}
