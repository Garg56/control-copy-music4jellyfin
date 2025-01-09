
# Control and copy music to Jellyfin

_Check your music and then copy to Jellyfin._

## Step 1: Initial referential repository

_Organize your music referential:_

    ../Musique
    ├── A
    │   ├── Artist Name 1
    │   │   |── Title Album 1
    │   │   │   ├── 01 - first.mp3
    │   │   │   ├── 02 - second.mp3
    │   │   │   ...
    │   │   │   └── cover.jpg
    │   │   ├── Title Album 2
    │   │   │   ├── 01 - first.mp3
    │   │   │   ...
    │   │   │   └── cover.jpg
    │   │   ├── backdrop.jpg
    │   │   └── folder.jpg
    │   └── Artist Name 2
    │       ├── artist.nfo
    │       ├── backdrop.jpg
    │       ├── folder.jpg
    │       └── logo.png
    ├── ...
    └── Z

**First level**: Just the alphabet. To simplify humain access to artist/album, artists are grouped in alphabetical directory.

**Second level**: Artist name. The full artist name, the same used in id3v2 tags. I chose `LAST NAME First Name`. Files are :

- folder: portrait of the artist or group (file required, jpg, png or webp),
- backdrop.jpg: artist in action (file optional, jpg, png or webp),
- logo.png: logo or signature on a black background (file optional, jpg, png or webp),
- artist.nfo: XML metadata with artist musicbrainz id, link to folder and backdrop (file optional).

### Step 2: Check referential repository

### Step 3: Copy referential repository

### Step 4: Final Jellyfin repository


<footer>

<!--
  <<< Author notes: Footer >>>
  Add a link to get support, GitHub status page, code of conduct, license link.
-->

---

[MIT License](https://gh.io/mit)

</footer>
