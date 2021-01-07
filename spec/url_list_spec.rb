require 'spec_helper'
require_relative '../lib/url_list'

RSpec.describe UrlList do
  let(:url_items) { %w[http://fake-app.com/star.png] }
  let(:logger) { Logger.new('./log/test.log') }

  before { allow(logger).to receive(:info) }

  describe '.build' do
    subject { described_class.build(filename, logger: logger) }

    let(:filename) { 'spec/fixtures/files.txt' }

    it 'builds a list from a file' do
      expect(subject).to be_a(described_class)
      expect(subject.items).to eq url_items
    end

    context 'when file is not existing' do
      let(:filename) { 'spec/fixtures/missing.txt' }

      it 'logs a message' do
        subject
        expect(logger).to have_received(:info).with("File \"#{filename}\" doesn't exist. Please, provide a name of existing file")
      end
    end

    context 'when no file name provided' do
      let(:filename) { nil }

      it 'logs a message' do
        subject
        expect(logger).to have_received(:info).with('Please, provide a file name')
      end
    end
  end
end
