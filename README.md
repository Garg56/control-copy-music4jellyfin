<!-- markdownlint-disable MD033 -->

# Check or copy music to Jellyfin

_Check your music or copy it to Jellyfin._

You have your classified and ordered music in your reference folder, and you want :

- to check if Jellyfin will integrate it,
- to copy your music to a Jellyfin folder.

Here, a simple bash script[^1] to check or copy your music referential.

## Mandatory

Necessary tools:  

- id3v2 (package id3v2),
- metaflac (package flac).

## Step 1: Initial referential repository

_Organize your music referential:_

```text
    ../Music
    ├── A
    │   ├── Artist Name A1
    │   │   |── Title Album 1
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
    │   └── Artist Name A2
    │       ├── artist.nfo
    │       ├── backdrop.jpg
    │       ├── folder.jpg
    │       └── logo.png
    ├── B
    │   ├── Artist Name B1
    │   ...
    .  
    .  
    └── Z
```

**First level**: Just letters of the alphabet. To simplify humain access to artist/album, artists are grouped in alphabetical directory. `Audiobooks` and `Podcasts` directories are specific, they are skipped while checking or copying.

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
cc-music4jellyfin.sh -i /home/myname/Music -v
```

```bash
cc-music4jellyfin.sh  -i /home/myname/Music -v -w "./A ./R"
```

The displaying log:

```text
    White list: ./A ./R
     
    =>Skipping './M'.
     
    =>Skipping './N'.

    =>Reading './A' :
    =====>Checking artist 'Artist Name A1'
    =========>Reading disc 'Title Album 1'
    =========>OK
    =========>Reading disc 'Title Album 2'
    =========>OK
    =====>Checking artist 'Artist Name A2'
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
cc-music4jellyfin.sh -i /home/myname/Music ./
```

If you want to copy only some letters (A and C):

```bash
cc-music4jellyfin.sh -i /home/myname/Music -w "./A ./C" ./
```

### Step 4: Final Jellyfin media library

Jellyfin will create album.nfo in each album directory, and update/create the file artist.nfo in the artist directory (if you chose medadata recorded in NFO files in the Jellyfin configuration).

```text
    ../Music
    ├── Artist Name A1
    │   |── Title Album 1
    │   │   ├── 01 - first track.mp3
    │   │   ├── 02 - second track.mp3
    │   │   ...
    │   │   ├── cover.jpg
    │   │   └── album.nfo <--
    │   ├── Title Album 2
    │   │   ├── 01 - first track.mp3
    │   │   ...
    │   │   ├── cover.jpg
    │   │   └── album.nfo <--
    │   ├── backdrop.jpg
    │   ├── folder.jpg
    │   └── artist.nfo <--
    ├── Artist Name A2
    │   ├── artist.nfo
    │   ├── backdrop.jpg
    │   ├── folder.jpg
    │   └── logo.png
    ├── ...
```

## Usage

The arguments of the script:

cc-music4jellyfin.sh [-a _pattern_] [-b _list_] [-c] [-d] [-e] [-h] [-i _dir_] [-v] [-w _list_] [_destination_]  

```text
       -a pattern : pattern of artists to check or copy in line with white list  
       -b list ...: directory list to not check or copy (black list) (incompatible with -w)  
       -c ........: copy only (default)  
       -d ........: debug display  
       -e ........: exit on first error when checking  
       -h ........: this help
       -i dir ....: input directory (default is script directory)  
       -v ........: check and verify only (incompatible with -c)  
       -w list ...: directory list to check or copy (white list)  
       destination: output directory  
```

---

[^1]: [MIT License](https://gh.io/mit)
