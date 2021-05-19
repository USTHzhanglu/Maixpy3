# 前言

maix2 dock使用的是全志V831芯片，运行在linux系统上。使用gpio时，需要先按照linux的方式进行GPIO注册，然后进行使用。本文将大致讲解下基于python3的GPIO注册使用流程，并大致讲解下相关API，供大家使用更多功能。

文章参考：[gpio接口是干什么的?gpio怎么用?](http://www.elecfans.com/emb/jiekou/20171206595752.html)

[Linux通用GPIO驱动写法与应用 - 云+社区 - 腾讯云 (tencent.com)](https://cloud.tencent.com/developer/article/1599571)

[在Linux中控制GPIO | St.Lee的个人站 (stlee.tech)](https://www.stlee.tech/2021/01/25/在Linux中控制GPIO/)

[Linux GPIO 驱动 （gpiolib）_StephenZhou-CSDN博客](https://blog.csdn.net/zhoutaopower/article/details/98082006)

例程参考：[GitHub - sipeed/MaixPy3: MaixPy for Python3, let's play with edge AI easier!](https://github.com/sipeed/maixpy3)

API参考：[Python gpiod | loliot](https://wiki.loliot.net/docs/lang/python/libraries/gpiod/python-gpiod-about/)

## 官方例程

```python
import time
from maix import gpio
PH_BASE = 224 # "PH"
gpiochip1 = gpio.chip("gpiochip1")
led = gpiochip1.get_line((PH_BASE + 14)) # "PH14"
config = gpio.line_request()
config.request_type = gpio.line_request.DIRECTION_OUTPUT
led.request(config)

while led:
    led.set_value(0)
    time.sleep(0.1)
    led.set_value(1)
    time.sleep(0.1)
```

## 例程讲解

1.PH_BASE:设置寄存器编号。GPIO编号计算公式：num=（n-1）x32+m，n为GPIO组号，m为pin号。例如PA(13)=（1-1）x32+13=13。为了方便使用，可以先设置寄存器编号，然后直接+Pin进行使用。

```python
PH_BASE = 224 # "PH",(6-1)*32=224
led = gpiochip1.get_line((PH_BASE + 14)) # "PH14",224+14
```

2.gpio.chip():实例化gpio_chip 结构体。通常在硬件上，一个芯片对 IO 口来说，分为了很多个 Bank，每个 Bank 分为了 N 组 GPIO。gpio_chip 是对一个 Bank 的 GPIO 的硬件的具体抽象。在maixii中，统一由gpiochip1进行管理。

3.chip.get_line():在给定的偏移地址，通过此芯片暴露该线。即将该地址上的GPIO暴露出来，未暴露的GPIO无法使用。

4.gpio.line_request():实例化line_request 结构体，该结构体中包含了GPIO的使用方法，例如：

```
DIRECTION_INPUT：输入模式
DIRECTION_OUTPUT：输出模式
```

5.config.request_type():设置GPIO参数。[更多参数请看](https://github.com/hhk7734/python3-gpiod/blob/dab4209073f649c08f79a65ccab831dfbcecb63a/py_src/gpiod/libgpiodcxx/__init__.py#L79)。

6.led.request(config) :以config设置的参数向内核注册GPIO。

7.led.set_value()：设置GPIO点评，0/1可选。get_value()读取GPIO电平。

## 常用API

### [chip](https://github.com/hhk7734/python3-gpiod/blob/dab4209073f649c08f79a65ccab831dfbcecb63a/py_src/gpiod/libgpiodcxx/__init__.py#L79)：

1.get_line(self, offset: int)：暴露一个GPIO地址线，即初始化一个GPIO。指向line结构体，然后即可调用line的api。

使用方法：

```python
led = chip.get_line((PH_BASE + 14)) # "PH14"
led.set_value(0)
```

返回值：一个GPIO对象

2.get_lines(self, offsets: List[int])：暴露一组GPIO地址线。即同时初始化多个GPIO，指向line_bulf结构体。

使用方法：

```python
led = chip.get_lines([(PH_BASE + 14),(PH_BASE + 15),(PH_BASE + 16)]) # "PH14","PH15","PH16"
for i in led:
    print(i)
```

返回值：多个GPIO对象

3.get_all_lines(self)：暴露所有GPIO地址线。即初始化所有GPIO

使用方法：

```python
lb = chip.get_all_lines()
```

返回值：多个GPIO对象

### [line](https://github.com/hhk7734/python3-gpiod/blob/dab4209073f649c08f79a65ccab831dfbcecb63a/py_src/gpiod/libgpiodcxx/__init__.py#L397):

1.request(self, config: line_request, default_val: int = 0):向内核注册该地址。line_request:GPIO 参数，使用config = line_request()进行设置；

default_val：默认电平，仅在输出方式下有效

使用方法：

```python
config = line_request()
config.request_type = line_request.DIRECTION_OUTPUT
# line.request(config)
line.request(config, 1)
```

返回值：无

2.release(self):释放该地址线

使用方法：

```python
line.release()
```

返回值：无

3.get_value(self)：获取该地址线的电平，0/1

使用方法：

```python
print(line.get_value())
```

返回值：地址线电平

4.set_value(self)：设置该地址线的电平，0/1

使用方法：

```python
line.set_value(1)
```

返回值：无

5.event_wait(self, timeout: timedelta)：等待该地址线活动

timeout：超时时间

使用方法：

```python
print(line.event_wait(timedelta(seconds=1000)))
```

返回值：bool值

5.event_read(self)：读取该地址线活动

使用方法：

```python
if line.event_wait(timedelta(seconds=10)):
    event = line.event_read()
    print(event.event_type == line_event.RISING_EDGE)
    print(event.timestamp)
 else:
    print("Timeout")
```

返回值：event对象。

event.event_type：事件类型，RISING_EDGE|FAILING_EDGE

6.reset(self)：重设该地址线的状态

使用方法：

```python
line.reset()
```

返回值：无

### [line_bulk](https://github.com/hhk7734/python3-gpiod/blob/dab4209073f649c08f79a65ccab831dfbcecb63a/py_src/gpiod/libgpiodcxx/__init__.py#L875):

1.append(self, new_line: line):向地址组添加新地址线。新line必须与地址组内其他lines同属一个gpio_chip。

使用方法：

```python
bulk.append(line1)
```

返回值：无

2.size(self) ：获取地址组内线数

使用方法：

```python
print(bulk.size)
```

返回值：地址线数量

3.chear(self) ：移除地址组内所有地址线

使用方法：

```python
bulk.clear()
```

返回值：无

4.request(self, config: line_request, default_vals: Optional[List[int]] = None):向内核注册该组地址。

使用方法：

```python
config = line_request()
config.consumer = "Application"
config.request_type = line_request.DIRECTION_OUTPUT
# bulk.request(config)
bulk.request(config, [1] * bulk.size)
```

返回值：地址线数量

5.release(self):释放该组地址线

使用方法：

```python
bulk.release()
```

返回值：无

6.get_values(self)：获取该组地址线的电平，0/1

使用方法：

```python
print(bulk.get_values())
```

返回值：地址线电平，数组

7.set_values(self, values: List[int])：设置该组地址线的电平，传入数组

使用方法：

```python
bulk.set_values([1] * bulk.size)
```

返回值：无

7.event_wait(self, timeout: timedelta)：等待该地址组活动

使用方法：

```python
ebulk = bulk.event_wait(timedelta(microseconds=20000))
```

返回值：发生活动的地址线。

## 常用常量

### line_request：

1.DIRECTION_INPUT 输出模式

2.DIRECTION_OUTPUT 输入模式

3.EVENT_FALLING_EDGE：下降沿触发

4.EVENT_RISING_EDGE：上升沿触发

5.EVENT_BOTH_EDGES：同时触发

### line_event:

1.RISING_EDGE:下降沿触发

2.FALLING_EDGE:上升沿触发

等待更新...



