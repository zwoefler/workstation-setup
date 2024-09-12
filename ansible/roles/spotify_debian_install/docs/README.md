# 📖 Docs for Spotify Debian Install

Table of Contents:
- [Why the steps differ from Spotifiys explanation](#-explanation---why-the-steps-differ-from-spotifys-explanation)
- [Errors](#-errors)

---

## ❓️ Explanation - Why the steps differ from Spotifys explanation
Spotifies installation manual differs from Debian recommendations.
Spotify says to:
- add the apt key to `/etc/apt/trusted.gpg.d/spotify.gpg` (No longer recommended)
- and "dearmor" the gpg key (not necessary)

Furthermore debian packages `sources.list` entrys SHOULD have the `signed-by` option set.

Spotify's installation:
```SHELL
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
```

Debian recomends that locally managed keys shall be put into `/etc/apt/keyrings/` directory.
Armored keys should use `.asc` extension, binary should use `.gpg`. Therefore "dearmoring" the key is not necessary.

That keyfile is then referenced by the repository `sources.list` entry like this:
```SHELL
deb [arch=amd64 signed-by=/etc/apt/keyrings/spotify.asc] http://repository.spotify.com stable non-free
```

#### ❓️ WHY?:
Security concerns: APT unconditionally trusts all keys in `/etc/apt/trusted.gpg` and `/etc/apt/trusted.gpg.d`.
Meaning any repository which it's signing key was added to `/etc/apt/trusted.gpg.d` can replace packages on the system.

So instead download the key, add it to the keyring and reference it in the repository definition.


#### 📚️ Sources
Debian Wiki - Use `/usr/share/keyrings` or `/etc/apt/keyrings`:
- 🔗 URL: https://wiki.debian.org/DebianRepository/UseThirdParty#OpenPGP_certificate_distribution

Debian Wiki - sources.list entrys should have `signed-by` option set:
- 🔗 URL: https://wiki.debian.org/DebianRepository/UseThirdParty#Sources.list_entry

---

## 🚧 Errors
### get_url throws CustomHTTPSConnection object has no attribute cert_file
FIX: Update to `ansible-core==2.16` or higher.

Trying to use the `get_url` Ansible module throws the CustomHTTPSConnection error:
```YAML
- name: Add Spotify's GPG key
  ansible.builtin.get_url:
    url: "{{ spotify_gpg_key_url }}"
    dest: "{{ spotify_gpg_asc_key_path }}"
```
The error:
```SHELL
An unknown error occurred: 'CustomHTTPSConnection' object has no attribute 'cert_file'
```

The Issue is, that on target runs Python3.12.
However, older versions of Ansible do not support Python3.12 on the target.
"[T]he first version of ansible-core to support Python3.12 is 2.16"

Ansible Version: core 2.13.9 (Python 3.8)
Target: Ubuntu 2404 LTS (Python 3.12)

🔗 URL: https://github.com/ansible/ansible/issues/83213

---

### Running spotify throws undefined symbol: snd_device_name_get_hint, version ALSA_0.9
FIX:
Install `libasound2t64` package
```SHELL
sudo apt install libasound2t64
```

Spotify requires the ALSA library, specifically the function `snd_device_name_get_hint` that is part of the `libasound2t64` package.

```SHELL
spotify: symbol lookup error: /usr/share/spotify/libcef.so: undefined symbol: snd_device_name_get_hint, version ALSA_0.9
```

You can check if it is installed:
```SHELL
dpkg -s libasound2 | grep Version
```

OS: Ubuntu 2404 LTS

---