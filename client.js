var customFetch = function(elem, url)
{
	fetch(url).
	then(function(response) {
		let event = new CustomEvent("customEvent", { "detail": { response } });
		// no need to add event listeners here, that is done by IXSL
		document.dispatchEvent(event);
	});