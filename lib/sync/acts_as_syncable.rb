require 'set'

module Sync
  module ActsAsSyncable
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def acts_as_syncable(options = {})
        include Rails.application.routes.url_helpers

        cattr_accessor :acts_as_syncable_options
        self.acts_as_syncable_options = options

        after_save do |obj|
          obj.sync_out
        end
      end
    end

    def sync_out(options = {})
      to_sync_out = [self]
      synced_objs = Set.new [self]


      until to_sync_out.empty?
        obj = to_sync_out.pop
        path = polymorphic_path obj
        WebsocketRails[path].trigger 'update', obj

        dependents = obj.class.acts_as_syncable_options[:dependent]
        next if dependents.nil?
        dependents = [dependents] if dependents.class == Symbol

        dependents.each do |dependent|
          assocs = obj.send dependent
          assocs = [assocs] unless assocs.respond_to? :each

          assocs.each do |assoc|
            next if synced_objs.include? assoc
            to_sync_out << assoc
            synced_objs << to_sync_out
          end

        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Sync::ActsAsSyncable
