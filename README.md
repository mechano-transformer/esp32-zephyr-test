# blinking

Minimal Zephyr application for **ESP32-S3-DevKitC-1**.
Flashes firmware and prints output via `west espressif monitor`.

---

## Native (ローカル環境)

Zephyr / west / Python 環境がセットアップ済みの場合。

```bash
west build -b esp32s3_devkitc/esp32s3/procpu
west flash
west espressif monitor
```

---

## Docker (推奨)

ローカル環境を汚さずにビルドできます。
Python・toolchain・west のインストールは不要です。

### イメージ作成

```bash
docker build -t zephyr-esp32 .
```

### コンテナ起動して入る（USBデバイス共有）

```bash
docker run --rm -it \
  --device=/dev/ttyUSB0 \
  --group-add dialout \
  -v $PWD:/workspace \
  zephyr-esp32
```

### コンテナ内で実行

```bash
west build -b esp32s3_devkitc/esp32s3/procpu
west build -b esp32s3_devkitc/esp32s3/procpu -p
west flash
west espressif monitor


# プログラムを消去
esptool.py --chip esp32s3 --port /dev/ttyUSB0 erase_flash
```

---

## Notes

* `/dev/ttyUSB0` は環境により `/dev/ttyACM0` などに変わる場合あり
* 初回のみ `west blobs fetch hal_espressif` が必要な場合あり
* Docker 利用時はホストに Zephyr 環境は不要
