### Generated by rprotoc. DO NOT EDIT!
### <proto file: test/proto/optional_field.proto>
# package test.optional_field;
# 
# message Message {
#   enum Enum {
#     A = 1;
#     B = 2;
#   }
#   optional uint32 number = 1 [default = 20];
#   optional string text   = 2 [default = "default string"];
#   optional Enum   enum   = 3 [default = B];
# }

require 'protobuf/message/message'
require 'protobuf/message/enum'
require 'protobuf/message/service'
require 'protobuf/message/extend'

module Test
  module Optional_field
    class Message < ::Protobuf::Message
      defined_in __FILE__
      class Enum < ::Protobuf::Enum
        defined_in __FILE__
        A = 1
        B = 2
      end
      optional :uint32, :number, 1, :default => 20
      optional :string, :text, 2, :default => "default string"
      optional :Enum, :enum, 3, :default => :B
    end
  end
end