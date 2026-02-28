module Print
  module Model::MqttAcl
    extend ActiveSupport::Concern

    included do
      attribute :username, :string
      attribute :permission, :string
      attribute :action, :string
      attribute :topic, :string
      attribute :ip, :string

      enum :permission, {
        allow: 'allow',
        deny: 'deny'
      }, prefix: true, default: 'allow'

      enum :action, {
        publish: 'publish',
        subscribe: 'subscribe',
        all: 'all'
      }, prefix: true, default: 'subscribe'
    end

  end
end
