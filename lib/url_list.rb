class UrlList
  def initialize(items, logger: nil)
    @items = items.map(&:strip)
    @logger = logger || default_logger
  end

  def self.build(filename, logger: nil)
    if filename.nil?
      logger.info('Please, provide a file name')
      return nil
    end

    if File.exist?(filename)
      new File.readlines(filename), logger: logger
    else
      logger.info("File \"#{filename}\" doesn't exist. Please, provide a name of existing file")
      nil
    end
  end

  attr_reader :items, :logger

  private

  def default_logger
    Logger.new('./log/test.log')
  end
end
