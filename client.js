var customFetch = function(elem, url)
{
	fetch(url).
	then(function(response) {
		let event = new CustomEvent("customEvent", { "detail": response });
		// no need to add event listeners here, that is done by IXSL
		document.dispatchEvent(event);
	});
}

var ixslTemplateListener = function(stylesheetLocation, initialTemplate, stylesheetParams, templateParams, event)
{
	console.log("ixslTemplateListener event", event);

    templateParams.event = event;

    SaxonJS.transform({
        "stylesheetLocation": stylesheetLocation,
        "initialTemplate": initialTemplate,
        "stylesheetParams": stylesheetParams,
        "templateParams": templateParams,
        "destination": 'appendToBody'
    }, 'async').then(res => console.log('Second transformation run:', res.principalResult)).catch(err => console.log('Second transformation failed.', err));;
};