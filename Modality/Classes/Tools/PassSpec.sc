/*
- for elements that have non-numeric values,
just pass values thru map and unmap
maybe useful for string values like ip addresses etc
PassSpec.map(1235);
PassSpec.unmap(1235);
PassSpec.unmap(["hi", "lily", "hi", "lily", "hilo"]);
PassSpec.asSpec
*/

PassSpec {
	*new { ^this }
	*asSpec { ^this }
	*map { |inval| ^inval }
	*unmap { |inval| ^inval }
}