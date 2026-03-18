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
      attribute :note, :string

      scope :todo, -> { where(completed_at: nil) }

      belongs_to :mqtt_printer, foreign_key: :imei, primary_key: :dev_imei, optional: true
    end

    def body
      raw_arr.map(&:to_16_str).join
    end

    def raw_arr
      Base64.decode64(raw).unpack('C*')
    end

    def set_raw_array(raw)
      self.raw = Base64.encode64(raw.pack('C*'))
    end

    def set_raw_array!(arr)
      set_raw_array(arr)
      save
    end

    def set_esc!
      if mqtt_printer.dev_type_esc?
        pr = BaseEsc.new
        yield pr
        self.set_raw_array(pr.render)
      else
        pr = BaseCpcl.new
        yield pr
        arr = pr.render.bytes + [0x1d, 0x56, 0x00]
        self.set_raw_array(arr)
      end

      self.save
    end

  end
end
