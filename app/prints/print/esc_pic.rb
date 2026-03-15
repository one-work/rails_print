# frozen_string_literal: true

module Print
  class EscPic

    def initialize(path = Rails.root.join('public/icon.png'))
      @png = ChunkyPNG::Image.from_file(path)
    end

    def xx
      bin = []
      @png.height.times do |y|
        row = []
        @png.width.times do |x|

        end
      end
    end

  end
end