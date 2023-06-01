#!/bin/sh

# This script is intended to be used on SX1302 CoreCell platform, it performs
# the following actions:
#       - export/unpexort GPIO23 and GPIO18 used to reset the SX1302 chip and to enable the LDOs
#       - export/unexport GPIO22 used to reset the optional SX1261 radio used for LBT/Spectral Scan
#
# Usage examples:
#       ./reset_lgw.sh stop
#       ./reset_lgw.sh start

# GPIO mapping has to be adapted with HW
#

SX1302_RESET_PIN_GPIOCHIP=1
SX1261_RESET_PIN_GPIOCHIP=1
SX1302_RESET_PIN=309     # SX1302 reset GPO 0,12
SX1261_RESET_PIN=446     # SX1261 reset (LBT / Spectral Scan) GPO 0,63

WAIT_GPIO() {
    sleep 0.1
}

reset() {
    echo "SX1302 reset through GPIO$SX1302_RESET_PIN..."
    echo "SX1261 reset through GPIO$SX1261_RESET_PIN..."

    # write output for SX1302 CoreCell power_enable and reset

    echo $SX1302_RESET_PIN > /sys/class/gpio/export;WAIT_GPIO
    echo $SX1261_RESET_PIN > /sys/class/gpio/export;WAIT_GPIO

    echo "out" > /sys/class/gpio/gpio$SX1302_RESET_PIN/direction;WAIT_GPIO
    echo "out" > /sys/class/gpio/PP.06/direction;WAIT_GPIO

    echo "1" > /sys/class/gpio/gpio$SX1302_RESET_PIN/value; WAIT_GPIO
    echo "0" > /sys/class/gpio/gpio$SX1302_RESET_PIN/value; WAIT_GPIO
    #gpioset $SX1302_RESET_PIN_GPIOCHIP $SX1302_RESET_PIN=1
    #sleep 1
    #gpioset $SX1302_RESET_PIN_GPIOCHIP $SX1302_RESET_PIN=0

    echo "0" > /sys/class/gpio/$SX1302_RESET_PIN/value; WAIT_GPIO
    echo "1" > /sys/class/gpio/$SX1302_RESET_PIN/value; WAIT_GPIO
    #gpioset $SX1261_RESET_PIN_GPIOCHIP $SX1261_RESET_PIN=0
    #sleep 1
    #gpioset $SX1261_RESET_PIN_GPIOCHIP $SX1261_RESET_PIN=1
}

case "$1" in
    start)
    reset
    ;;
    stop)
    reset
    ;;
    *)
    echo "Usage: $0 {start|stop}"
    exit 1
    ;;
esac