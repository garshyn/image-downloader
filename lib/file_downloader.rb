require 'down'
require 'logger'

class FileDownloader
  def initialize(destination, logger: nil)
    @destination = destination
    @logger = logger || default_logger
  end

  def download(url_or_list)
    if url_or_list.is_a? String
      download_image(url_or_list)
    elsif url_or_list.is_a? UrlList
      url_or_list.items.each do |url|
        download_image(url)
      end
    end
  end

  def download_image(url)
    create_destination_folder

    download_file_to_tmp_folder(url)
    if image?
      move_file
    else
      remove_file
      log_message("#{url}: not an image")
    end
  rescue Down::InvalidUrl => e
    log_message("#{url}: #{e.message}")
  end

  private

  attr_reader :destination, :logger

  def create_destination_folder
    FileUtils.mkdir(destination) unless File.exist?(destination)
  end

  def download_file_to_tmp_folder(url)
    @tempfile = Down.download(url)
  end

  def image?
    @tempfile.content_type.start_with? 'image'
  end

  def move_file
    FileUtils.mv(@tempfile.path, filename)
  end

  def remove_file
    @tempfile.unlink
  end

  def filename
    if File.exist? default_filepath
      loop.with_index(1) do |_, index|
        filepath = generate_unique_filename(index)
        return filepath unless File.exist? filepath
      end
    else
      default_filepath
    end
  end

  def default_filepath
    "#{destination}/#{@tempfile.original_filename}"
  end

  def generate_unique_filename(index)
    parts = default_filepath.split('.')
    parts[-2] += " (#{index})"
    parts.join('.')
  end

  def log_message(message)
    logger.info message
  end

  def default_logger
    Logger.new('./log/test.log')
  end
end
