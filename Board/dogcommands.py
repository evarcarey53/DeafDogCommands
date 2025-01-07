from machine import Pin, PWM
import utime

MID = 1500000
MIN = 1000000
MAX = 2000000

led_onboard = machine.Pin(25,machine.Pin.OUT)
lpwm = PWM(Pin(11))
rpwm = PWM(Pin(15))

lpwm.freq(50)
lpwm.duty_ns(MID)
rpwm.freq(50)
rpwm.duty_ns(MID)
     
def doubleTap():
    lpwm.duty_ns(MAX)
    rpwm.duty_ns(MAX)
    utime.sleep(0.5)
    lpwm.duty_ns(MID)
    rpwm.duty_ns(MID)
    utime.sleep(0.5)
    lpwm.duty_ns(MAX)
    rpwm.duty_ns(MAX)
    utime.sleep(0.5)
    lpwm.duty_ns(MIN)    
    rpwm.duty_ns(MIN)
    
def singleTap(motor, duration):
    if motor == "left":
        lpwm.duty_ns(MAX)
        utime.sleep(duration)   
        lpwm.duty_ns(MIN)
    elif motor == "right":
        rpwm.duty_ns(MAX)
        utime.sleep(duration)   
        rpwm.duty_ns(MIN)
    elif motor == "both":
        lpwm.duty_ns(MAX)
        rpwm.duty_ns(MAX)
        utime.sleep(duration)   
        lpwm.duty_ns(MIN)
        rpwm.duty_ns(MIN)
            
#  double Tap
def StopCommand():
    doubleTap()
    
# single Tap followed by long single Tap
def ComeBack():
    singleTap(0.5)
    utime.sleep(1)   
    singleTap(2)
    
# double Tap twice fast
def Danger():
    doubleTap()
    utime.sleep(0.5)
    doubleTap()

def LookAtMe():
    singleTap("left", 0.5)
    utime.sleep(1)
    singleTap("right",0.5)
    
def DropIt():
    singleTap("left", 0.5)
    utime.sleep(0.25)
    singleTap("right", 0.5)
    
def Sit():
    singleTap("both", 1)
    
def Off():
    singleTap("left",0.25)
    utime.sleep(0.25)   
    singleTap("right",0.25)
    utime.sleep(0.25)   
    singleTap("left",0.25)
    utime.sleep(0.25)   
    singleTap("right",0.25)
    
def Stay():
    singleTap("both",1)
    utime.sleep(1)
    singleTap("both",1)
    utime.sleep(1)
    singleTap("both",1)
    
def No():
    singleTap("both",0.5)
    
def Quiet():
    singleTap("both",0.5)
    utime.sleep(0.5)
    singleTap("both",0.5)
    

