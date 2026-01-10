# 此模块专为页模式设计，暂不考虑标准模式
class BaseEsc
  # Printer hardware
  HW_SELECT = [ 0x1b, 0x3d, 0x01 ] # Printer select
  HW_RESET = [ 0x1b, 0x3f, 0x0a, 0x00 ] # Reset printer hardware

  # Feed control sequences
  CTL_LF = [ 0x0a ]                   # Print and line feed
  CTL_FF = [ 0x0c ]                   # Form feed
  CTL_CR = [ 0x0d ]                   # Carriage return
  CTL_HT = [ 0x09 ]                   # Horizontal tab
  CTL_VT = [ 0x0b ]                   # Vertical tab

  # Paper
  PAPER_FULL_CUT = [ 0x1d, 0x56, 0x00 ]			   # 全切纸
  PAPER_PARTIAL_CUT = [ 0x1d, 0x56, 0x01 ]			   # 半切纸（中间还有部分相连）
  PAPER_CUT_A = [ 0x1d, 0x56, 0x41 ]			   # Paper cut A
  PAPER_CUT_B = [ 0x1d, 0x56, 0x42 ]			   # Paper cut B

  # Cash Drawer
  CD_KICK_2 = [ 0x1b, 0x70, 0x00 ]			   # Send pulse to pin 2
  CD_KICK_5 = [ 0x1b, 0x70, 0x01 ]			   # Send pulse to pin 5

  # Code Pages
  CP_SET = [ 0x1b, 0x74 ]	      		   # Set Code Page

  # Text formating
  TXT_NORMAL = [ 0x1b, 0x21, 0x00 ]        # Normal text
  TXT_UNDERL_OFF = [ 0x1b, 0x2d, 0x00 ]        # Underline font OFF
  TXT_BOLD_OFF = [ 0x1b, 0x45, 0x00 ]        # Bold font OFF
  TXT_ALIGN_LT = [ 0x1b, 0x61, 0x00 ]        # 左对齐
  TXT_COLOR_BLACK = [ 0x1b, 0x72, 0x00 ]        # Default Color
  TXT_COLOR_RED = [ 0x1b, 0x72, 0x01 ]        # Alternative Color (Usually Red)

  # Barcodes
  BARCODE_FONT_A = [ 0x1d, 0x66, 0x00 ]         # Font type A for HRI barcode chars
  BARCODE_FONT_B = [ 0x1d, 0x66, 0x01 ]         # Font type B for HRI barcode chars

  attr_reader :data
  def initialize
    @data = []
    data_push 0x1b, 0x40  # 初始化打印机：清除打印缓存，各参数恢复默认值
  end

  def set_pad
    data_push 0x1d, 0x4c, 0x12, 0x00  # 设置左限（左边距）：向右移动 18（0x12）点
  end

  def set_cn
    data_push 0x1c, 0x26 # 启用 16×16 点阵中文打印模式
    data_push 0x1c, 0x21, 0x00  # 中文字间距为 0 点
  end

  def partial_cut!
    data_push *PAPER_PARTIAL_CUT
  end

  def cut!
    data_push *PAPER_FULL_CUT
  end

  def break_line
    data_push *CTL_LF
  end

  def render
    data_push *(CTL_LF * 10)
    cut!
    @data
  end

  def render_raw
    @data.map(&:to_16_str).join('')
  end

  def render_0x
    @data.pack('C*')
  end

  def text(data)
    data_push *TXT_NORMAL
    data_push *data.encode('gb18030').bytes
    data_push *TXT_NORMAL
    data_push *CTL_LF
  end

  def double_height(data)
    data_push 0x1b, 0x21, 0x10, *data.bytes, *TXT_NORMAL
  end

  def text_big(data)
    data_push 0x1b, 0x21, 0x30 # Quad area text
    data_push *data.encode('gb18030').bytes
    data_push *TXT_NORMAL
    data_push *CTL_LF
  end

  def text_big_center(data)
    data_push 0x1b, 0x61, 0x01
    data_push 0x1d, 0x21, 0x11 # Quad area text
    data_push *data.encode('gb18030').bytes
    data_push *CTL_LF
    data_push *TXT_ALIGN_LT
  end

  def double_width(data)
    data_push 0x1b, 0x21, 0x20, *data.bytes, *TXT_NORMAL
  end

  def underline(data)
    data_push 0x1b, 0x2d, 0x01, *data.bytes, *TXT_UNDERL_OFF
  end

  def underline2(data)
    data_push 0x1b, 0x2d, 0x02, *data.bytes, *TXT_UNDERL_OFF
  end

  def bold(data)
    data_push 0x1b, 0x45, 0x01, *data.bytes, TXT_BOLD_OFF
  end

  def left(data = '')
    data_push *TXT_ALIGN_LT, data.bytes, *TXT_ALIGN_LT
  end

  def right(data = '')
    data_push 0x1b, 0x61, 0x02, *data.bytes, *TXT_ALIGN_LT
  end

  def center(data = '')
    data_push 0x1b, 0x61, 0x01, *data.bytes, *TXT_ALIGN_LT
  end

  # Inverted color text
  def inverted(data)
    data_push 0x1d, 0x42, 0x01, *data.bytes, 0x1d, 0x42, 0x00
  end

  def black
    data_push *TXT_COLOR_BLACK, *data.bytes, *TXT_COLOR_BLACK
  end

  def red
    data_push *TXT_COLOR_BLACK, *data.bytes, *TXT_COLOR_RED
  end

  def qrcode(data, y: nil)
    bytes = data.bytes
    #qr_type = [0x1d, 0x28, 0x6b, 0x03, 0x00, 0x31, 0x41, 0x03] # 模块类型
    qr_size = [0x1d, 0x28, 0x6b, 0x03, 0x00, 0x31, 0x43, 0x06] # 二维码模块大小
    qr_err = [0x1d, 0x28, 0x6b, 0x03, 0x00, 0x31, 0x45, 0x30] # 错误校正水平
    qr_data = [0x1d, 0x28, 0x6b, bytes.size + 3, 0x00, 0x31, 0x50, 0x30] # 二维码数据
    qr_run = [0x1d, 0x28, 0x6b, 0x03, 0x00, 0x31, 0x51, 0x30] # 打印二维码

    data_push *qr_size, *qr_err, *qr_data, *bytes, *qr_run
    data_push *(CTL_LF * 2)
  end

  # 0 不显示数据，只显示条码
  # 1 数据在条码上方显示
  # 2 数据在条码下方显示
  # 3 数据在条码上下显示
  def barcode(data, position: 2, width: 3, height: 50, format: 0x02)
    text_position = [0x1d, 0x48, position]
    bar_width = [0x1d, 0x77, width ]      # Barcode Width (2 - 6)
    bar_height = [0x1d, 0x68, height]   # Barcode Height (1 - 255)
    bar_format = [0x1d, 0x6b, format]

    unless [0, 1, 2, 3].include?(position)
      raise ArgumentError("Wrong text position.")
    end
    if height && (height < 1 || height > 255)
      raise ArgumentError("Height must be in range from 1 to 255.")
    end
    if width && (width < 2 || width > 6)
      raise ArgumentError("Width must be in range from 2 to 6.")
    end

    data_push *text_position, *bar_height, *bar_width, *bar_format, *data.bytes, 0x00
  end

  def dash(paper_mm = 58)
    text '-' * 32
  end

  def table_3(headers: ['商品', '单价', '数目', '小计'], cols: [])
    #
    data_push 0x1b, 0x44, 16, 22, 28, 0x00
    data_push *headers.map { |h| h.encode('gb18030').bytes << 0x09 }.flatten, 0x0d
    cols.each do |col|
      data_push *col.map { |h| h.encode('gb18030').bytes << 0x09 }.flatten, 0x0d
    end
  end

  def partial_cut
    data_push *PAPER_PARTIAL_CUT
  end

  def cut
    data_push 0x1d, 0x56, 0x00  # 全切纸
  end

  def data_push(*data)
    @data.concat data
    self
  end

end
