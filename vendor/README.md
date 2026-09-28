# Vendored Docker installer

`get-docker.sh` is the official script downloaded from:

```text
https://get.docker.com
```

Snapshot details:

- Downloaded: 2026-09-28
- Upstream commit: `2b32480025b223ebfddae9a3a8bef09027680f53`

The offline installer runs it as:

```sh
sh vendor/get-docker.sh --mirror Aliyun
```

To update the snapshot, download `https://get.docker.com`, replace
`vendor/get-docker.sh`, and run:

```sh
sh vendor/get-docker.sh --help
```
