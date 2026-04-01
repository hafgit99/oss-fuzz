FROM gcr.io/oss-fuzz-base/base-builder-javascript

RUN git clone --depth 1 https://github.com/hafgit99/AegisVault_V.4.0.0 $SRC/aegis-vault

WORKDIR $SRC/aegis-vault

COPY fuzz_targets $SRC/fuzz_targets
COPY build.sh $SRC/build.sh
