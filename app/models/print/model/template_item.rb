module Print
  module Model::TemplateItem
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :code, :string
      attribute :position, :integer

      enum :kind, {
        break_line: 'break_line',
        text: 'text',
        qrcode: 'qrcode',
        dash: 'dash'
      }

      belongs_to :template

      positioned on: :template_id

      validates :code, uniqueness: { scope: :template_id }
    end

  end
end
