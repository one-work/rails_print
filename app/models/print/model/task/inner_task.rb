module Print
  module Model::Task::InnerTask
    extend ActiveSupport::Concern

    included do
      attribute :gid, :string

      before_create :generate_raw, if: -> { model.present? }
      before_save :print_img, if: -> { attachment_changes['file'].present? && file.attached? }
      after_save_commit :sync_to_locator, if: :saved_change_to_completed_at?
      after_create_commit :print, if: -> { printer.is_a? MqttPrinter }
    end

    def sync_to_locator
      return unless model
      _model = model
      _model.print_info ||= {}
      _model.print_info.merge! aim => completed_at.to_fs(:iso8601)
      _model.save
    end

    def model
      return @model if defined? @model
      @model = GlobalID::Locator.locate gid
    end

    def generate_raw
      pr = print_base
      model.to_esc(pr, aim: aim)
      bytes = pr.render
      self.set_raw_array(bytes)
    end

    def print_img
      set_esc do |pr|
        file.open do |f|
          data, row, height = BmpUtil.to_bitmap_bytes(f.path)
          pr.image(data, byteWidth: row, height: height)
        end
      end
    end

  end
end
