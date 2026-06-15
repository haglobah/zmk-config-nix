# zmk-config

ZMK firmware config for a [rae_dux](https://github.com/StefanGulan/rae_dux) split keyboard with nice!nano v2 controllers, built with [zmk-nix](https://github.com/lilyinstarlight/zmk-nix).

## Build

```sh
nix build
```

Produces `result/zmk_left.uf2` and `result/zmk_right.uf2`.

## Flash

For each half:

1. Connect the half via USB.
2. Double-tap the reset button to enter bootloader mode — it will mount as a `NICENANO` USB drive.
3. Run:

   ```sh
   nix run .#flash
   ```

   The script will detect the mounted drive and copy the appropriate `.uf2` to it. The keyboard reboots automatically when flashing completes.

Repeat for the other half.

### Manual fallback

If `nix run .#flash` can't find the device, copy the file by hand:

```sh
cp result/zmk_left.uf2  /run/media/$USER/NICENANO/
# or
cp result/zmk_right.uf2 /run/media/$USER/NICENANO/
```

## Update Zephyr / ZMK deps

```sh
nix run .#update
```

This refreshes `zephyrDepsHash` in `flake.nix`. Commit the result.
