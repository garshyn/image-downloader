require_relative 'lib/url_list'
require_relative 'lib/file_downloader'

DEFAULT_DOWNLOAD_FOLDER = './storage'

filename = ARGV[0]
destination = ARGV[1] || DEFAULT_DOWNLOAD_FOLDER
logger = Logger.new(STDOUT)

url_list = UrlList.build(filename, logger: logger)
exit if url_list.nil?

downloader = FileDownloader.new(destination, logger: logger)
downloader.download(url_list)
