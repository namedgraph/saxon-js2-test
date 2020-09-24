var customFetch = function(elem)
{
	fetch("text.xml").
	then(function(response) {
		let event = new CustomEvent("customEvent", { "detail": { response } });
		// no need to add event listeners here, that is done by IXSL
		document.dispatchEvent(event);
	});