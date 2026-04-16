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
      attribute :note, :string

      scope :todo, -> { where(completed_at: nil) }

      belongs_to :printer, polymorphic: true
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

    def set_esc
      if printer.dev_type_cpcl?
        pr = BaseCpcl.new
        yield pr
        bytes = pr.render.bytes
      else
        pr = BaseEsc.new
        yield pr
        pr.line_x10
        bytes = pr.render
      end

      if printer.dev_cut_type_full?
        arr = bytes + [0x1b, 0x69]
      else
        arr = bytes + [0x1b, 0x6d]
      end

      self.set_raw_array(arr)
    end

    def set_esc!(&block)
      set_esc(&block)
      self.save
      self
    end

    def print
      printer.print_cmd(raw_arr, id)
    end

  end
end
