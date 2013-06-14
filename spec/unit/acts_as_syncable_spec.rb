require 'spec_helper'

module Sync
  class MockConnection
    attr_accessor :triggered

    def initialize
    end

    def trigger(event)
      @triggered = true
    end
  end

  describe ActsAsSyncable do
    before :each do
      @b = Book.new
      @b.title = 'Harry Potter'
      @b.save

      @b.chapters << [Chapter.create, Chapter.create]
      @b.reviews << [Review.create, Review.create]

      @conn = MockConnection.new
      WebsocketRails["/books/#{@b.id}"].subscribe @conn
    end

    it 'connection should not be triggered by default' do
      @conn.triggered.should be_false
    end

    it 'should trigger a channel when model is saved' do
      @b.author = 'JW Rowling'
      @b.save
      @conn.triggered.should be_true
    end

    it 'should trigger when sync_out is called' do
      @b.sync_out
      @conn.triggered.should be_true
    end

    it 'should trigger assocations specified in acts_as_syncable' do
      conn2 = MockConnection.new
      conn3 = MockConnection.new
      WebsocketRails["/chapters/#{@b.chapters[0].id}"].subscribe conn2
      WebsocketRails["/chapters/#{@b.chapters[1].id}"].subscribe conn3
      conn2.triggered.should be_false
      conn3.triggered.should be_false

      @b.sync_out
      conn2.triggered.should be_true
      conn3.triggered.should be_true
    end

    it 'should not trigger assocations not specified in acts_as_syncable' do
      conn2 = MockConnection.new
      conn3 = MockConnection.new
      WebsocketRails["/reviews/#{@b.reviews[0].id}"].subscribe conn2
      WebsocketRails["/reviews/#{@b.reviews[1].id}"].subscribe conn3
      conn2.triggered.should be_false
      conn3.triggered.should be_false

      @b.sync_out
      conn2.triggered.should be_false
      conn3.triggered.should be_false
    end
  end
end
