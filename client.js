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

	var options = {
        "stylesheetLocation": stylesheetLocation,
        "initialTemplate": initialTemplate
    };

	if (stylesheetParams) options.stylesheetParams = stylesheetParams;
	if (templateParams) options.templateParams = templateParams;

	console.log("SaxonJS options: ", JSON.stringify(options));

    SaxonJS.transform(options, 'async').then(res => console.log('Second transformation run:', res.principalResult)).catch(err => console.log('Second transformation failed.', err));;
};

var createTestObject = function()
{
	// Create a test object with an array property
	var testObj = {
		name: "TestObject",
		items: [
			{ id: 1, value: "first" },
			{ id: 2, value: "second" }
		],
		metadata: {
			created: new Date(),
			version: "1.0"
		}
	};

	// Store it on the window for access from XSLT
	window.testObject = testObj;
	console.log("Created test object with array:", testObj);
	return testObj;
};