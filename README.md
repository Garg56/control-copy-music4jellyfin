# Control or copy music to Jellyfin

_Check your music or copy it to Jellyfin._

A simple bash script[^1] to check your music referential.

## Step 1: Initial referential repository

_Organize your music referential:_

```text
    ../Music
    ├── A
    │   ├── Artist Name 1
    │   │   |── Title Album 1
    │   │   │   ├── 01 - first track.mp3
    │   │   │   ├── 02 - second track.mp3
    │   │   │   ...
    │   │   │   └── cover.jpg
    │   │   ├── Title Album 2
    │   │   │   ├── 01 - first track.mp3
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
    ├── Audiobook
    ├── ...
    ├── Podcasts
    ├── ...
    └── Z
```

**First level**: Just the alphabet. To simplify humain access to artist/album, artists are grouped in alphabetical directory. `Audiobooks` and `Podcasts` directories are specific, they are skipped while checking or copying.

**Second level**: Artist name. The full artist name, the same used in id3v2 tags. I chose `LAST NAME First Name`. Files are :

- **folder**: portrait of the artist or group (file required, jpg, png or webp),
- **backdrop**: artist in action (file optional, jpg, png or webp),
- **logo**: logo or signature on a black background (file optional, jpg, png or webp),
- **artist.nfo**: XML metadata with artist musicbrainz id, link to folder and backdrop (file optional).

**Third level**: Album name. This level is optional. Files are :

- **track**: track file (mp3 or flac),
- **cover**: cover of the album (file required, jpg, png or webp).

### Step 2: Check referential repository

```bash
/home/myname/Music/cc-music4jellyfin.sh --check ./
```

```bash
/home/myname/Music/cc-music4jellyfin.sh --check --white "./A ./R" ./
```

The displaying log:

```text
    White list: ./A ./R
     
    =>Skipping './M'.
     
    =>Skipping './N'.

    =>Reading './A' :
    =====>Checking artist 'Artist Name 1'
    =========>Reading disc 'Title Album 1'
    =========>OK
    =========>Reading disc 'Title Album 2'
    =========>OK
    =====>Checking artist 'Artist Name 2'
    =========>Reading disc ''
    =========>Warning no album
```

The summary result:

```text
    END=========================================
    TOTAL No error on MP3......: 75
    TOTAL No error on cover....: 75
    TOTAL Warning on album.....: 12/75
    TOTAL No warning on folder.: 16
    TOTAL No error artist name.: 16
    TOTAL No error on artist...: 16
    TOTAL OK
    TOTAL Artists: 16 - Albums : 75
```

### Step 3: Copy referential repository

The script copy all the files in the current directory but suppress the first level directory (the alphabetic one).

To copy all files:

```bash
/home/myname/Music/cc-music4jellyfin.sh  ./
```

If you want to copy only some letters (A et C):

```bash
/home/myname/Music/cc-music4jellyfin.sh --white "./A ./C" ./
```

### Step 4: Final Jellyfin media library

Jellyfin will create album.nfo in each album directory, and update/create artist.nfo.

```text
    ../Music
    ├── Artist Name 1
    │   |── Title Album 1
    │   │   ├── 01 - first track.mp3
    │   │   ├── 02 - second track.mp3
    │   │   ...
    │   │   ├── cover.jpg
    │   │   └── album.npo <--
    │   ├── Title Album 2
    │   │   ├── 01 - first track.mp3
    │   │   ...
    │   │   ├── cover.jpg
    │   │   └── album.npo <--
    │   ├── backdrop.jpg
    │   ├── folder.jpg
    │   └── artist.npo <--
    ├── Artist Name 2
    │   ├── artist.nfo
    │   ├── backdrop.jpg
    │   ├── folder.jpg
    │   └── logo.png
    ├── ...
```
  
---

[^1]: [MIT License](https://gh.io/mit)
