#!/bin/bash

INSTALL_DIR="/opt/ttn-gateway"

mkdir -p $INSTALL_DIR/dev
cd $INSTALL_DIR/dev

if [ ! -d libmpsse ]; then
    git clone https://github.com/devttys0/libmpsse.git  || { echo 'Cloning libmpsse failed.' ; exit 1; }
else
    cd libmpsse
    git reset --hard
    git pull
    cd ..
fi

if [ ! -d lora_gateway ]; then
    git clone https://github.com/chrisys/lora_gateway.git  || { echo 'Cloning lora_gateway failed.' ; exit 1; }
else
    cd lora_gateway
    git reset --hard
    git pull
    cd ..
fi

if [ ! -d paho.mqtt.embedded-c ]; then
    git clone https://github.com/kersing/paho.mqtt.embedded-c.git  || { echo 'Cloning paho mqtt failed.' ; exit 1; }
else
    cd paho.mqtt.embedded-c
    git reset --hard
    git pull
    cd ..
fi

if [ ! -d ttn-gateway-connector ]; then
    git clone https://github.com/kersing/ttn-gateway-connector.git  || { echo 'Cloning gateway connector failed.' ; exit 1; }
else
    cd ttn-gateway-connector
    git reset --hard
    git pull
    cd ..
fi

if [ ! -d protobuf-c ]; then
    git clone https://github.com/kersing/protobuf-c.git  || { echo 'Cloning protobuf-c failed.' ; exit 1; }
else
    cd protobuf-c
    git reset --hard
    git pull
    cd ..
fi

if [ ! -d packet_forwarder ]; then
    git clone https://github.com/kersing/packet_forwarder.git  || { echo 'Cloning packet forwarder failed.' ; exit 1; }
else
    cd packet_forwarder
    git reset --hard
    git pull
    cd ..
fi

if [ ! -d protobuf ]; then
    git clone https://github.com/google/protobuf.git  || { echo 'Cloning protobuf failed.' ; exit 1; }
else
    cd protobuf
    git reset --hard
    git pull
    cd ..
fi

cd $INSTALL_DIR/dev/libmpsse/src/
./configure
make
make install

cd $INSTALL_DIR/dev/lora_gateway/libloragw
sed -i -e 's/PLATFORM= .*$/PLATFORM= rak831_usb/g' library.cfg
# Uncomment vv for balenaFin v1.0
# sed -i -e 's/DEVICE_INDEX .*$/DEVICE_INDEX 1/g' inc/rak831_usb.h
make -j$(nproc)

cd $INSTALL_DIR/dev/protobuf-c
./autogen.sh
./configure
make protobuf-c/libprotobuf-c.la
mkdir bin
./libtool install /usr/bin/install -c protobuf-c/libprotobuf-c.la `pwd`/bin
rm -f `pwd`/bin/*so*

cd $INSTALL_DIR/dev/paho.mqtt.embedded-c/
make
make install

cd $INSTALL_DIR/dev/ttn-gateway-connector
cp config.mk.in config.mk
make -j$(nproc)
cp bin/libttn-gateway-connector.so /usr/lib/

cd $INSTALL_DIR/dev/packet_forwarder/mp_pkt_fwd/
make -j$(nproc)

# Copy things needed at runtime to where they'll be expected
cp $INSTALL_DIR/dev/packet_forwarder/mp_pkt_fwd/mp_pkt_fwd $INSTALL_DIR/mp_pkt_fwd

echo "Build & Installation Completed."
