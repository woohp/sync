
module Sync
  module ActsAsSyncable
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def acts_as_syncable(options = {})
        include Rails.application.routes.url_helpers
        after_save do |obj|
          path = polymorphic_path obj
          WebsocketRails[path].trigger 'update', obj
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Sync::ActsAsSyncable
