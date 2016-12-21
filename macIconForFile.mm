#import <AppKit/AppKit.h>
#import <nan.h>
#import <string>
#import <Cocoa/Cocoa.h>
#import <QuickLook/QuickLook.h>

class MacIconForFile: public Nan::AsyncWorker {

	private:
		std::string path;
		int64_t size;
		NSData* pngData;

	public:

		MacIconForFile(Nan::Callback *callback, std::string path, int64_t size): AsyncWorker(callback), path(path), size(size), pngData(nullptr) {
		}

		~MacIconForFile() {
			if (pngData != nullptr) {
				[pngData release];
				pngData = nullptr;
			}
		}

		void Execute() {
			NSString* filePath = [NSString stringWithCString:path.c_str() encoding:[NSString defaultCStringEncoding]];

			NSURL *fileURL = [NSURL fileURLWithPath:filePath];
			NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:true] forKey:(NSString *)kQLThumbnailOptionIconModeKey];
			CGImageRef ref = QLThumbnailImageCreate(kCFAllocatorDefault, (CFURLRef)fileURL, CGSizeMake(size, size), (CFDictionaryRef)dict);

			NSImage* sourceImage = nil;

			if (ref != NULL) {
				NSBitmapImageRep *bitmapImageRep = [[NSBitmapImageRep alloc] initWithCGImage:ref];
				if (bitmapImageRep) {
					sourceImage = [[NSImage alloc] initWithSize:[bitmapImageRep size]];
					[sourceImage addRepresentation:bitmapImageRep];
					[bitmapImageRep release];
				}
				CFRelease(ref);
			}

			if (!sourceImage) sourceImage = [[NSWorkspace sharedWorkspace] iconForFile:filePath];

			NSSize newSize = NSMakeSize(size, size);
			NSImage* targetImage = [[NSImage alloc] initWithSize: newSize];
			[sourceImage setScalesWhenResized:YES];
			[targetImage lockFocus];
			[sourceImage setSize: newSize];
			[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
			[sourceImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, newSize.width, newSize.height) operation:NSCompositeCopy fraction:1.0];
			[targetImage unlockFocus];
			NSData* tiffData = [targetImage TIFFRepresentation];
			NSBitmapImageRep* bitmapRep = [NSBitmapImageRep imageRepWithData:tiffData];
			pngData = [bitmapRep representationUsingType:NSPNGFileType properties:[NSDictionary dictionary]];
			[pngData retain];
		}

		void HandleOKCallback() {
			Nan::HandleScope scope;
			const char* rawBytes = reinterpret_cast<const char*>([pngData bytes]);
			v8::Local<v8::Value> argv[] = {
				Nan::CopyBuffer(rawBytes, [pngData length]).ToLocalChecked()
			};
			callback->Call(1, argv);
		}

};

NAN_METHOD(GetIconForFile) {
	v8::String::Utf8Value utf8Path(Nan::To<v8::String>(info[0]).ToLocalChecked());
	std::string path(*utf8Path, utf8Path.length());
	Nan::Callback *callback = new Nan::Callback(info[1].As<v8::Function>());
	int64_t size = Nan::To<int64_t>(info[2]).FromJust();
	Nan::AsyncQueueWorker(new MacIconForFile(callback, path, size));
}

NAN_METHOD(GetIconForFileSync) {
	v8::String::Utf8Value utf8Path(Nan::To<v8::String>(info[0]).ToLocalChecked());
	std::string path(*utf8Path, utf8Path.length());
	Nan::Callback *callback = new Nan::Callback(info[1].As<v8::Function>());
	int64_t size = Nan::To<int64_t>(info[2]).FromJust();
	MacIconForFile* macIconForFile = new MacIconForFile(callback, path, size);
	macIconForFile->Execute();
	macIconForFile->HandleOKCallback();
	delete macIconForFile;
}

void Init(v8::Local<v8::Object> exports) {

	exports->Set(
		Nan::New("getIconForFile").ToLocalChecked(),
		Nan::New<v8::FunctionTemplate>(GetIconForFile)->GetFunction()
	);

	exports->Set(
		Nan::New("getIconForFileSync").ToLocalChecked(),
		Nan::New<v8::FunctionTemplate>(GetIconForFileSync)->GetFunction()
	);

}

NODE_MODULE(macIconForFile, Init)