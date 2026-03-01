module Print
  module Model::Task
    extend ActiveSupport::Concern

    included do
      attribute :type, :string
      attribute :aim, :string
      attribute :uid, :string
      attribute :print_at, :datetime
      attribute :completed_at, :datetime
      attribute :raw, :string, comment: '经过Base64压缩的字节码'
      attribute :imei, :string, index: true
    end

    def body
      Base64.decode64(raw)
    end

    def raw_arr
      Base64.decode64(raw).unpack('C*')
    end

    def set_raw(text)
      pr = BaseEsc.new
      pr.text text

      self.raw = Base64.encode64(pr.render.pack('C*'))
    end

    def set_raw!(text)
      set_raw(text)
      save
    end

  end
end
