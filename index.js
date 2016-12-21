var extension = (
	process.platform === 'darwin' &&
	require('./build/Release/macIconForFile.node')
);

module.exports = function(path, ret, size) {

	var syncResult;

	if (typeof ret !== 'function') {
		size = ret;
		syncResult = true;
	}

	if (extension) {

		if (typeof path !== 'string') path = String(path);
		if (typeof size !== 'number' || isNaN(size) || size % 1 || size <= 0) size = 32;

		if (syncResult)
			extension.getIconForFileSync(path, (result) => syncResult = result, size);
		else extension.getIconForFile(path, ret, size);

		return syncResult;

	}

	else if (!syncResult) ret();

};