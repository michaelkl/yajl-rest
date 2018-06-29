# frozen_string_literal: true

require 'yajl/ffi'
require 'zlib'

module YajlRest
  # Enumerates elements of JSON array acquired from given HTTP URL
  # with given headers or from local file.
  #
  # Local file should be plain JSON. HTTP endpoint may return plain or gzipped
  # content.
  #
  # @example
  #   e = YajlRest::RestEnumerator.new 'http://example.com/objects',
  #                                      accept: :json,
  #                                      authorization: 'Bearer token="asdf"'
  #   e.each { |o| puts o['id'] }
  #
  # @example
  #   e = YajlRest::RestEnumerator.new '/tmp/rest-client.20180629-25287-1fgmf91'
  #   e.each { |o| puts o['id'] }
  class JsonEnumerator < Enumerator
    class UnhandledHttpStatus < StandardError; end

    def initialize(url_or_path, headers = {})
      if url_or_path.start_with?('https://') || url_or_path.start_with?('http://')
        @raw = RestClient::Request.execute method: :get,
                                           url: url_or_path,
                                           headers: headers,
                                           raw_response: true
      else
        @path = url_or_path
      end
      super(&method(:enumerate))
    end

    private

    BUF_SIZE = 4096

    def enumerate(yielder)
      @parser = Yajl::FFI::Parser.new
      YajlRest::ArrayYielder.new @parser, yielder

      File.open(@path || @raw.file.path) do |f|
        stream = if @raw.try(:headers).try(:[], :content_encoding) == 'gzip'
                   Zlib::GzipReader.new(f)
                 else
                   f
                 end
        while (buffer = stream.read(BUF_SIZE)) != nil
          @parser << buffer
        end
        stream.try(:close)
      end
      @parser.finish
      @raw = nil
    end
  end
end
