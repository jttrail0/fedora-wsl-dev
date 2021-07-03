# fedora-wsl-dev
fedora wsl container for wsl development


### Create new distro

Pull your prefered distro.

```bash
podman pull fedora:latest
```

Build new image with Dockerfile

```bash
podman build -t {container_tag} .
```

Create a writeable container layer from previous image, required
for WSL to work successfully. This will export a hash.

```bash
podman create -i {container_tag} bash # or any shell
```

Export container to tar file.

```bash
podman export {hash} > fedora.tar
```

GZip tar file to upload to Github.
```bash
gzip -9 fedora.tar
```

After downloading the file onto WSL host, you can import with the following comand:

```
wsl --import {distro_name} {root_directory} {distro_file}
```


