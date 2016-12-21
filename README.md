# macIconForFile [![npm version](https://badge.fury.io/js/mac-file-icon.svg)](https://npmjs.org/package/mac-file-icon)

Get the native macOS icon for a specific file extension as a PNG image buffer.

Inspired and based on:
  * https://github.com/kevinsawicki/mac-extension-icon
  * https://github.com/incbee/NSImage-QuickLook
  
Retrieves icon, exactly the same way as Finder does it, including QuickLook preview generation in case if it's possible, just check out the example at the end of this page. My motivation to write this module was impossiblity to obtain file system's entry icon in Electron, there is simply no method to do that.
  
### Installation

```bash
npm install mac-file-icon
```

### Usage

```javascript
var getIconForFile = require('mac-file-icon');
getIconForFile('/Users/', function(buffer) {
  console.info(buffer);
});
```
You can always convert Buffer into it's base64 representation:

```javascript
var getIconForFile = require('mac-file-icon');
getIconForFile('/Users/', function(buffer) {
  console.info(buffer.toString('base64'));
});
```

In case if callback is ommited, Buffer will be returned in synchronous way:

```javascript
var getIconForFile = require('mac-file-icon');
console.info(getIconForFile('/Users/'));
```

By default, icon size is set to 32x32, you can adjust it by passing additional argument:

```javascript
var getIconForFile = require('mac-file-icon');
// icon size 64x64
getIconForFile('/Users/', function(buffer) {
  console.info(buffer);
}, 64);
```

Works same way in synchronous calls:

```javascript
var getIconForFile = require('mac-file-icon');
// icon size 64x64
console.info(getIconForFile('/Users/', 64));
```

### Build it yourself

```bash
cd macIconForFile
npm install
node-gyp configure
node-gyp build
```

However I'm not sure if last two statements are required...

### Example

You can try out an example included into the package, that uses [Express](https://github.com/expressjs/express), [Histone](https://github.com/MegafonWebLab/histone-javascript) and **macIconForFile** to generate file listing in the browser.

```bash
npm install mac-file-icon
cd node_modules/mac-file-icon/example
npm install
node index.js
```

Then open your web browser and navigate to http://localhost:8080/ (in case if this port number is taken, edit index.js and set another one), you will see something like this:

![Show case of how it looks like](/example/screenshot.png?raw=true)
