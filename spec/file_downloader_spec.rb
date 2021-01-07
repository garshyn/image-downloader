require 'spec_helper'
require_relative '../lib/url_list'
require_relative '../lib/file_downloader'

RSpec.describe FileDownloader do
  describe '#download' do
    subject { described_class.new(destination, logger: logger).download(url) }

    let(:url) { 'http://fake-app.com/star.png' }
    let(:destination) { './spec/storage' }
    let(:logger) { Logger.new('./log/test.log') }

    before do
      FileUtils.rm_rf(destination)
      allow(logger).to receive(:info)
    end

    it 'downloads a file' do
      expect do
        subject
      end.to change { downloaded_files_count }.from(0).to(1)
    end

    context 'when file already exists' do
      before do
        FileUtils.mkdir(destination)
        FileUtils.cp('./spec/fixtures/star.png', destination)
      end

      it 'downloads a file with modifed name and logs a message' do
        expect do
          subject
        end.to change { downloaded_files_count }.from(1).to(2)
      end
    end

    context 'when url has no file' do
      let(:url) { 'http://fake-app.com/' }

      it 'logs a message' do
        expect do
          subject
          expect(logger).to have_received(:info).with("#{url}: not an image")
        end.not_to change { downloaded_files_count }
      end
    end

    context 'when url is other than image' do
      let(:url) { 'http://fake-app.com/files.txt' }

      it 'logs a message' do
        expect do
          subject
          expect(logger).to have_received(:info).with("#{url}: not an image")
        end.not_to change { downloaded_files_count }
      end
    end

    context 'when url is blank' do
      let(:url) { '' }

      it 'logs a message' do
        expect do
          subject
          expect(logger).to have_received(:info).with("#{url}: URL scheme needs to be http or https: ")
        end.not_to change { downloaded_files_count }
      end
    end

    context 'with a list of urls' do
      subject { described_class.new(destination, logger: logger).download(url_list) }

      let(:url_list) { UrlList.new([url, url_2]) }
      let(:url_2) { 'http://fake-app.com/files.txt' }

      it 'downloads files from the list' do
        expect do
          subject
          expect(logger).to have_received(:info).with("#{url_2}: not an image")
        end.to change { downloaded_files_count }.from(0).to(1)
      end
    end
  end

  def downloaded_files_count
    Dir.glob(File.join(File.expand_path(destination), '*.png')).length
  end
end
