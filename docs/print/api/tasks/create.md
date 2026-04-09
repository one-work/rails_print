
绑定云打印机之后，你会在云打印机对应的页面看到特有的 webhook_url 用于发送打印任务；

如未绑定云打印机，请点击[链接](/print/admin/mqtt_printers)添加

# 打印指令

将打印指令字节码使用 base64 编码

假定字节码为`\e@\x1DL\x12\x00`

* Ruby
```ruby
Base64.encode64(bytes)
```

* Python
```python
import base64
base64.b64encode(bytes)
```
