
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
    - artist.nfo: XML metadata with artist musicbrainz id, link to folder and backdrop(file optional).

**What is a repository?**: A _[repository](https://docs.github.com/get-started/quickstart/github-glossary#repository)_ is a project containing files and folders. A repository tracks versions of files and folders. For more information, see "[About repositories](https://docs.github.com/en/repositories/creating-and-managing-repositories/about-repositories)" from GitHub Docs.

**What is a branch?**: A _[branch](https://docs.github.com/en/get-started/quickstart/github-glossary#branch)_ is a parallel version of your repository. By default, your repository has one branch named `main` and it is considered to be the definitive branch. Creating additional branches allows you to copy the `main` branch of your repository and safely make any changes without disrupting the main project. Many people use branches to work on specific features without affecting any other parts of the project.

Branches allow you to separate your work from the `main` branch. In other words, everyone's work is safe while you contribute. For more information, see "[About branches](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-branches)".

**What is a profile README?**: A _[profile README](https://docs.github.com/account-and-profile/setting-up-and-managing-your-github-profile/customizing-your-profile/managing-your-profile-readme)_ is essentially an "About me" section on your GitHub profile where you can share information about yourself with the community on GitHub.com. GitHub shows your profile README at the top of your profile page. For more information, see "[Managing your profile README](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-github-profile/customizing-your-profile/managing-your-profile-readme)".

![profile-readme-example](/images/profile-readme-example.png)

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
