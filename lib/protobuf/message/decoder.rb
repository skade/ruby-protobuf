require 'protobuf/common/wire_type'

module Protobuf
  class InvalidWireType < StandardError; end

  class Decoder
    class <<self
      def decode(stream, message)
        self.new(stream, message).decode
      end
    end

    def initialize(stream=nil, message=nil)
      @stream, @message = stream, message
    end

    def decode(stream=@stream, message=@message)
      until stream.eof?
        tag, wire_type = read_key stream
        bytes =
          case wire_type
          when WireType::VARINT
            read_varint stream
          when WireType::FIXED64
            read_fixed64 stream
          when WireType::LENGTH_DELIMITED
            read_length_delimited stream
          when WireType::START_GROUP
            read_start_group stream
          when WireType::END_GROUP
            read_end_group stream
          when WireType::FIXED32
            read_fixed32 stream
          else
            raise InvalidWireType.new(wire_type)
          end
        message.set_field tag, bytes
      end
      message
    end

    protected

    def read_key(stream)
      bytes = read_varint stream
      bits = Protobuf::Field::VarintField.decode bytes
      wire_type = bits & 0x07
      tag = bits >> 3
      [tag, wire_type]
    end

    def read_varint(stream)
      read_method = stream.respond_to?(:readbyte) ? :readbyte : :readchar
      bytes = []
      begin
        byte = stream.send(read_method)
        bytes << (byte & 0x7f)
      end while (byte & 0x80).nonzero?
      bytes
    end

    def read_fixed32(stream)
      stream.read(4)
    end

    def read_fixed64(stream)
      stream.read(8)
    end

    def read_length_delimited(stream)
      bytes = read_varint stream
      value_length = Protobuf::Field::VarintField.decode bytes
      value = stream.read value_length
      value.unpack('C*')
    end

    def read_start_group(stream)
      raise NotImplementedError.new('Group is duplecated.')
    end

    def read_end_group(stream)
      raise NotImplementedError.new('Group is duplecated.')
    end
  end
end
