require 'spec_helper'

module Sync
  class MockConnection
    attr_accessor :triggered

    def initialize
    end

    def trigger(event)
      triggered = true
    end
  end


  describe ActsAsSyncable do
    it 'should trigger a channel when model is saved' do
      b = Book.new
      b.title = 'Harry Potter'
      b.save

      conn = MockConnection.new
      WebsocketRails["/books/#{b.id}"].subscribe conn
      conn.triggered.should be_false

      b.author = 'JW Rowling'
      b.save
      conn.triggered.should be_false
    end
  end
end
