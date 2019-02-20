FROM balenalib/raspberrypi3:build AS build

RUN install_packages swig \
  libftdi-dev \
  libusb-1.0-0-dev \
  libc6-dev \
  pkg-config \
  protobuf-compiler \
  libprotobuf-dev \
  libprotoc-dev \
  automake \
  libtool \
  python-dev


WORKDIR /opt/ttn-gateway/

COPY dev dev
RUN chmod +x ./dev/build.sh
RUN ./dev/build.sh


FROM balenalib/raspberrypi3-python

RUN install_packages libftdi1

WORKDIR /opt/ttn-gateway

COPY --from=build /opt/ttn-gateway/mp_pkt_fwd .
COPY --from=build /usr/local/lib/libpaho-embed-* /usr/lib/
COPY --from=build /usr/lib/libttn* /usr/lib/
COPY --from=build /usr/local/lib/libmpsse* /usr/lib/

COPY run.py ./

CMD python /opt/ttn-gateway/run.py
