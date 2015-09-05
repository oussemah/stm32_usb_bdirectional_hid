USB Bi-Directional HID device
Based on codeninja project available at https://github.com/codeninja69/STM32F4DiscoveryBidirectionalHID

Main modifications are :
 1- Removing unnecessary code
 2- Adding a Makefile and a linker script and fixing build instruction to fit Linux OS
 3- Some minor updates in usb library code to fix some errors/warnings

This can be flashed to an STM32F4 discovery board, and you should be able to communicate
with STM32F4 Discovery using Micro USB Type B port available on it

Sample script to communicate with it using a python script is provided.

A sample command is :

ledX, where x is in 3,4,5,6 ; This will toggle the given led on the discovery board.

Author : Oussema Harbi <oussema.elharbi@gmail.com>
