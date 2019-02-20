# TTN Gateway using balenaFin + RAK833 mPCIe module

This is a project to enable you to use a RAK833 module in the mPCIe slot on the balenaFin.

## Introduction
This [balenaCloud](https://www.balena.io/cloud/) setup is based on the [Multi-protocol Packet Forwarder by Jac Kersing](https://github.com/kersing/packet_forwarder/tree/master/mp_pkt_fwd).


## Difference between Poly-packet-forwarder and Multi-protocol-packet-forwarder
mp-pkt-fwd uses the new protocolbuffers-over-mqtt-over-tcp protocol for gateways, as defined by TTN and used by the TTN kickstarter gateway. Using this protcol the gateway is authenticated, which means it is registered under a specific user and can thus be trusted. Because it uses TCP, the chance of packet loss is much lower than with the previous protocol that used UDP. Protocolbuffers packs the data in a compact binary mode into packets, using much less space than the plaintext json that was previously used. It should therefore consume less bandwidth.

When you use this repository, the settings you set on the TTN console are taken as the primary settings. The settings from the console are read and applied at gateway startup. If you for example change the location of the gateway on the console, that setting will only be applied when the gateway restarts.

## balenaCloud TTN Gateway Connector for balenaFin + RAK833

balenaCloud Dockerfile & scripts for [The Things Network](http://thethingsnetwork.org/) gateways based on the Raspberry Pi. This updated version uses the gateway connector protocol, not the old packet forwarder. See the [TTN documentation on Gateway Registration](https://www.thethingsnetwork.org/docs/gateways/registration.html).

This project is only compatible with the version of the RAK833 module that includes the USB and SPI interface, the SPI-only module will not work.

**Note:** for versions of balenaFin prior to v1.1 this configuration is correct. For v1.1 and after, the following line in `build.sh` is no longer required and can be commented out: `sed -i -e 's/DEVICE_INDEX .*$/DEVICE_INDEX 1/g' inc/rak831_usb.h`.

## Prerequisites

1. Build your hardware.
2. Create a new gateway that uses `gateway connector` on the [TTN Console](https://console.thethingsnetwork.org/gateways). Also set the location and altitude of your gateway. We will come back to this console later to obtain the gateway ID and access key.
3. Create and sign into an account at https://www.balena.io/cloud/, which is the central "device dashboard".

## Create a balenaCloud application

1. On balenaCloud, create an "Application" for managing your TTN gateway devices. I'd suggest that you give it the name "ttnGateway", select the appropriate device type (i.e. 'Balena Fin (CM3)'),  and click "Create New Application".  You only need to do this once, after which you'll be able to manage one or many gateways of that type.

## Configure the gateway device

Click the "Environment Variables" section at the left side of the screen. This will allow you to configure this and only this device. These variables will be used to pull information about this gateway from TTN, and will be used to create a "global_conf.json" and "local_conf.json" file for this gateway.

For a more complete list of possible environment variables, see [CONFIGURATION](CONFIGURATION.md).

### Device environment variables - no GPS

For example, if you're not using a hardware GPS, the MINIMUM environment variables that you should configure at this screen should look something like this:

Name      	  	   | Value  
------------------|--------------------------  
GW_ID             | The gateway ID from the TTN console
GW_KEY            | The gateway KEY from the TTN console


### Device environment variables - with GPS

If you've added a hardware GPS to the balenaFin, i.e. with something like an [Adafruit Ultimate GPS HAT](https://www.adafruit.com/product/2324)

Name      	  	   | Value  
------------------|--------------------------
GW_ID             | The gateway ID from the TTN console
GW_KEY            | The gateway KEY from the TTN console
GW_GPS            | true

If you get the message
`ERROR: [main] failed to start the concentrator`
after balenaCLoud is finished downloading the application, or when restarting the gateway, it most likely means the `DEVICE_INDEX` line in `build.sh` is incorrect. This can be commented out for balenaFin v1.1 and higher.


# Credits

* [JP Meijers](https://github.com/jpmeijers) on the [ttn-resin-gateway-rpi](https://github.com/jpmeijers/ttn-resin-gateway-rpi) that forms the basis of this project
* [Jac Kersing](https://github.com/kersing) on the [Multi-protocol packet forwarder](https://github.com/kersing/packet_forwarder/tree/master/mp_pkt_fwd)
* [Ray Ozzie](https://github.com/rayozzie/ttn-resin-gateway-rpi) on the original ResinIO setup
