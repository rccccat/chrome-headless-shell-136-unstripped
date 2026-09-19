# chrome-headless-shell 136.0.7103.94, unstripped

This repository template builds the Chromium `headless_shell` target from the
exact source commit tagged `136.0.7103.94`, with full DWARF symbols, on standard
GitHub-hosted Linux runners. It publishes a runtime archive plus a split symbol
archive as a GitHub Release.

## What this does and does not reproduce

- Source tag: `136.0.7103.94`
- Source commit: `fa0be0b33debeb378a8e6ad9c599be34e2dc3b37`
- Full symbols: `symbol_level=2`, `blink_symbol_level=2`, `v8_symbol_level=2`
- The output is an open-source Chromium build, not a bit-identical Google CfT
  build. Google branding, internal build settings, PGO data, and the build
  environment are not reproduced.
- The official CfT ELF Build ID
  `b7f06e222a7203cb9da1ba646660536a5096ee0d` belongs to the official binary.
  This rebuilt, symbol-bearing ELF must and will have a different Build ID.
- The URL for the official headless package is
  `https://storage.googleapis.com/chrome-for-testing-public/136.0.7103.94/linux64/chrome-headless-shell-linux64.zip`.
  The `chrome-linux64.zip` URL is the full Chrome package, not headless shell.

## Run it

1. Create a **public** empty GitHub repository. Standard hosted-runner usage is
   free for public repositories; private repositories consume included minutes.
2. Copy this directory into the repository and push it.
3. Open **Actions**, select `build-chrome-headless-shell-136-unstripped`, and
   choose **Run workflow**.
4. Leave the default 240-minute time box. The scheduled job runs every six
   hours and reuses a 9 GB `sccache` until compilation finishes.
5. Download the release tagged `v136.0.7103.94-unstripped`.

To join and unpack the full symbols:

```bash
cat chrome-headless-shell-136.0.7103.94-linux64-full-symbols.tar.zst.part-* \
  > chrome-headless-shell-136.0.7103.94-linux64-full-symbols.tar.zst
tar --zstd -xf chrome-headless-shell-136.0.7103.94-linux64-full-symbols.tar.zst
```

For GDB, keep `chrome-headless-shell` and
`chrome-headless-shell.dwp` together in the same directory and point GDB at the
matching Chromium source checkout.

## Practical limitation

The referenced `chromium-tabscroll` workflow was designed around a
symbol-free (`symbol_level=0`) component build. Full Blink/V8 DWARF makes both
compilation and cache much larger. The workflow here preserves that project's
time-box-and-cache technique, but a free runner is not guaranteed to converge:
the default Actions cache limit is 10 GB, and a standard public Linux runner has
4 vCPUs, 16 GB RAM, and 14 GB documented SSD storage before image cleanup.

If repeated runs stop gaining cache hits, the reliable options are a self-hosted
runner with at least 100 GB free disk or a paid larger runner. If complete local
variables/types are not required, changing all three symbol levels from `2` to
`1` is much more likely to fit the free-cache strategy while still retaining
enough symbols for stack traces.
