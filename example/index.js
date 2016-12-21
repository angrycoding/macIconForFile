var FS = require('fs');
var Path = require('path');
var getIconForFile = require('mac-file-icon');
var Histone = require('histone');
var server = require('express')();


Histone.setCache(false)

Histone.setResourceLoader(function(requestURI, ret) {
	FS.readFile(requestURI, 'UTF-8', function(error, template) {
		ret(template);
	});
});


Histone.register(Histone.Global.prototype, 'getFiles', function(self, args, scope, ret) {
	var path = args[0];
	FS.readdir(path, function(error, files) {

		ret(
			files.map(function(name) {

				var fullPath = Path.resolve(path, name);

				return {
					icon: '/getIcon?path=' + fullPath,
					path: fullPath,
					name: name,
				};


			})
		);

	});
});

server.all('/getIcon', function(request, response) {
	getIconForFile(request.query.path, function(buffer) {
		response.contentType('image/png');
		response.setHeader("Cache-Control", "public, max-age=345600"); // ex. 4 days in seconds.
		response.setHeader("Expires", new Date(Date.now() + 345600000).toUTCString());
		response.end(buffer)
	}, 128);
});

server.all('/', function(request, response) {

	if (!request.query.path) {
		response.redirect('/?path=' + process.env.HOME)
	}

	else Histone.require('template.tpl', function(result) {
		response.end(result);
	}, request.query);


});

server.listen(8080);