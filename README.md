# Image downloader

CLI-tool to download images from a list of urls located in a file.

## Usage

```
ruby download.rb files.txt
```

It will download all images specified in `files.txt` to a `./storage` destination folder.

Destination folder can be configured as following:

```
ruby download.rb files.txt ./other-destination
```

## Sample of files.txt

Each line in the file is supposed to be a url to an image

```
https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png
```

The script detects the following situations:

* filename is missing
* provided file does not exist
* a line in a file is not a url or blank
* a url is not pointing to an image
* a file with the same name already exists in the destination folder (in this case a unique name is generated)

## Test coverage

The code is covered with tests by 90+%.

## Logging

The script outputs errors to STDOUT. It's possible to modify it to redirect output to custom log file.

## Resources

* https://www.twilio.com/blog/download-image-files-ruby
* https://github.com/janko/down/
