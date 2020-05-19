/* behringer-motor_61.desc.scd
The Behringer motor 61 has the exact same midi implementation
as the motor 49, so rather than a hard-tomaintain copied file,
we load its desc file here, and make the few  changes needed
in the loaded dict.
*/

var descDict = "behringer-motor_49.desc.scd".loadRelative[0];
descDict.idInfo.deviceName = "MOTÖR61 Keyboard";
descDict.deviceInfo.longName = "Behringer MOTÖR61 Keyboard";
descDict.deviceInfo.features.do(_.replace("49", "61"));

descDict;