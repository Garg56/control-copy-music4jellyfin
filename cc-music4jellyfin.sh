#!/bin/bash
# Script to copy all files in a jukebox directory for jellyfin

# Need :
# - id3v2
#      id3v2 -R "toto.mp3" | grep TPE1:
# - identify from imagemagik
#      identify -format "%w\n" "toto.jpg"
#      identify -format "%h\n" "toto.jpg"
# Safety mode => turning bugs into errors.
set -o errexit -o pipefail -o noclobber -o nounset

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
LIGHT_PURPLE='\033[1;35m'
NC='\033[0m' # No Color
counterrormp3=0
counterrorcover=0
counterroralbum=0
counterrorfolder=0
counterrorlogo=0
counterrorbackground=0
counterartist=0
counteralbum=0
counterrorartist=0
counterrorname=0
CC_DEBUG=0

function jukusage () {
    printf "\nhelp: %s %s\n" $(basename "$0") "[--debug] [--check] [--white list] [destination]"
    exit $1
}

function checkartist() {
if (( ${CC_DEBUG} )) ; then echo "DEBUG: listartist=${listartist}=" ; fi
                        if [[ "${listartist}" == *'&'* ]]; then
                        	counterrorartist=$(expr ${counterrorartist} + 1 )
                        	echo -e "=========>${RED}Error artist *&* : '${listartist}'${NC}"
                        fi
                        # loop on artist
                        IFS='/' read -ra NARTIST <<< "${listartist}"
                        for i in "${NARTIST[@]}"; do
                            # suppress extra blank
                            i=$(echo -e "${i}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
if (( ${CC_DEBUG} )) ; then echo "DEBUG: currentartist=${artistname}=${i}=" ; fi
                            # find "$i" in second level
                            if [[ "${i// }" == "" ]]; then
                                    echo -e "=========>${RED}Error artist void: '${i}'${NC}"
                                    counterrorartist=$(expr ${counterrorartist} + 1 )
                            elif [[ "${artistname}" != "${i}" ]]; then
                                dir=$(find ./* -maxdepth 1 -mindepth 1 -type d -name "${i}")
                                # check if directory exist
if (( ${CC_DEBUG} )) ; then echo "DEBUG: otherartist=${dir}=${i}=" ; fi
                                if [[ "${dir##*/}" != "${i}" ]]; then
                                    echo -e "=========>${RED}Error no artist: '${i}'${NC}"
                                    counterrorartist=$(expr ${counterrorartist} + 1 )
                                fi
                            fi
                        done
}

if ! command -v id3v2 -v 2>&1 >/dev/null; then
	echo "id3v2 could not be found !"
	exit 1
fi

runmode="normal"
juknbarg="$#"
if [[ ${juknbarg} -ge 6 ]]; then
    jukusage 1
fi
if [[ ${juknbarg} -ge 1 ]] && [[ "${1}" == "--help" ]]; then
    jukusage 0
elif [[ ${juknbarg} -ge 1 ]] && [[ "${1}" == "--debug" ]]; then
    CC_DEBUG=1
    shift
fi
if [[ ${juknbarg} -ge 1 ]] && [[ "${1}" == "--check" ]]; then
    runmode="check"
    shift
fi
if [[ ${juknbarg} -ge 2 ]] && [[ "${1}" == "--white" ]]; then
    shift
    whitelist="${1}"
    shift
else
    whitelist=""
fi
juknbarg="$#"
if [[ ${juknbarg} -ge 1 ]] && [[ "${1}" != "" ]]; then
    TODIR="$1"
fi

# get the script location to became source
FROMDIR="$( cd "$( dirname -- "${BASH_SOURCE[0]}" )" && pwd)@"
FROMDIR="${FROMDIR%@}"

# get the destination
TODIR="$(pwd)"

echo -e "\nStarting copying Jellyfin Jukebox\nfrom '${FROMDIR}'\n to  '${TODIR}'\n"

# do not coppy these directories
exception='./Audiobook ./Podcasts'
# whitelist='./A ./B ./C ./D ./E ./F ./Y ./Z'
if [[ "${whitelist}" != "" ]]; then
    echo "White list: ${whitelist}"
else
    echo "Exception: ${exception}"
fi

# loop in the directory Music
cd "${FROMDIR}"
dirletter=$(find . -maxdepth 1 -mindepth 1 -type d )
while IFS= read -r d; do
    if [[ "${whitelist}" != "" ]]; then
        if [[ " ${whitelist} " =~ " ${d} " ]]; then
            echo -e "\n=>Reading '${d}' :"
        else
            echo -e "\n=>${BLUE}Skipping '${d}'.${NC}"
            continue;
        fi
    elif [[ " ${exception} " =~ " ${d} " ]]; then
        echo -e "\n=>${BLUE}Skipping '${d}'.${NC}"
        continue;
    else
        echo -e "\n=>Reading '${d}' :"
    fi
    dirartist=$(find "${d}" -maxdepth 1 -mindepth 1 -type d )
    while IFS= read -r artist; do
        artistname=$(basename "${artist}")
        if [[ ${runmode} == "check" ]]; then
            echo  -e "=====>Checking artist '${artistname}'"
            counterartist=$(expr ${counterartist} + 1 )
            nbfolder=0
            nblogo=0
            nbground=0
            diralbum=$(find "${artist}" -maxdepth 1 -mindepth 1 -type f )
            while IFS= read -r  album; do
                albumname=$(basename "${album}")
                if [[ "${albumname}" == "folder.jpg" ]] || [[ "${albumname}" == "folder.png" ]] || [[ "${albumname}" == "folder.webp" ]]; then
                    nbfolder=$(expr ${nbfolder} + 1 )
if (( ${CC_DEBUG} )) ; then echo "DEBUG: '${artist}/artist.nfo'" ; fi
                    if [[ -f "${artist}/artist.nfo" ]]; then
                        if ! grep -q '</poster>' "${artist}/artist.nfo"; then
                            echo -e "=====>${RED}Error poster in artist.nfo${NC}"
                            counterrorname=$(expr ${counterrorname} + 1 )
                        fi
                    fi
                elif [[ "${albumname}" == "logo.jpg" ]] || [[ "${albumname}" == "logo.png" ]] || [[ "${albumname}" == "logo.webp" ]]; then
                    nblogo=$(expr ${nblogo} + 1 )
                elif [[ "${albumname}" == "backdrop.jpg" ]] || [[ "${albumname}" == "backdrop.png" ]] || [[ "${albumname}" == "backdrop.webp" ]]; then
                    nbground=$(expr ${nbground} + 1 )
                    if [[ -f "${artist}/artist.nfo" ]]; then
                        if ! grep -q '</fanart>' "${artist}/artist.nfo"; then
                            echo -e "=====>${RED}Error fanart in artist.nfo${NC}"
                            counterrorname=$(expr ${counterrorname} + 1 )
                        fi
                    fi
                elif [[ "${albumname}" == "artist.nfo" ]]; then
                    if ! grep -q '<title>'"${artistname}"'</title>' "${album}"; then
                        echo -e "=====>${RED}Error title in artist.nfo${NC}"
                        counterrorname=$(expr ${counterrorname} + 1 )
                    fi
                fi
            done <<< "${diralbum}"
            if [[ ${nbfolder} -eq 0 ]]; then
               echo -e "=====>${RED}Error no Folder${NC}"
               counterrorfolder=$(expr ${counterrorfolder} + 1 )
            fi
            if [[ ${nblogo} -eq 0 ]]; then
                echo -e "=====>${BLUE}Warning no Logo${NC}"
                counterrorlogo=$(expr ${counterrorlogo} + 1 )
            fi
            if [[ ${nbground} -eq 0 ]]; then
                echo -e "=====>${BLUE}Warning no Background${NC}"
                counterrorbackground=$(expr ${counterrorbackground} + 1 )
            fi
            nbcover=0
            nbmp3=0
            diralbum=$(find "${artist}" -maxdepth 1 -mindepth 1 -type d )
            while IFS= read -r  album; do
                albumname=$(basename "${album}")
                localerror=0
                echo  -e "=========>Reading disc '${albumname}'"
                if [[ "${albumname}" == "" ]]; then
                    echo -e "=========>${BLUE}Warning no album${NC}"
                    counterroralbum=$(expr ${counterroralbum} + 1 )
                    break 1
                fi
                counteralbum=$(expr ${counteralbum} + 1 )
                dirmusic=$(find "${album}" -maxdepth 1 -mindepth 1 -type f )
                while IFS= read -r  music; do
                    simplemusic=$(basename "${music}")
if (( ${CC_DEBUG} )) ; then echo "DEBUG: file=${music}=" ; fi
                    if [[ "${simplemusic}" == "cover.jpg" ]]; then
                        nbcover=$(expr ${nbcover} + 1 )
                        continue
                    fi
                    if [[ "${simplemusic##*.}" == "mp3" ]]; then
                        nbmp3=$(expr ${nbmp3} + 1 )
                        # get list of artist in mp3 tag
                        listartist=$(id3v2 -R "${music}" | grep TPE1: || true)
                        # suppress label
                        listartist="${listartist#*: }"
                	elif [[ "${simplemusic##*.}" == "flac" ]]; then
                        nbmp3=$(expr ${nbmp3} + 1 )
                        listartist=$(metaflac --list --block-number=1 "${music}" | grep ' ARTIST=' || true)
                        # suppress label
                        listartist="${listartist#*=}"
                    else
                        continue
                    fi
                    checkartist 
                    if [[ "${simplemusic##*.}" == "mp3" ]]; then
                        # get list of artist in mp3 tag
                        listartist=$(id3v2 -R "${music}" | grep TPE2: || true)
                        # suppress label
                        listartist="${listartist#*: }"
                	elif [[ "${simplemusic##*.}" == "flac" ]]; then
                        nbmp3=$(expr ${nbmp3} + 1 )
                        listartist=$(metaflac --list --block-number=1 "${music}" | grep ' ALBUMARTIST=' || true)
                        # suppress label
                        listartist="${listartist#*=}"
                    fi
                    checkartist 
                done <<< "${dirmusic}"
if (( ${CC_DEBUG} )) ; then echo "DEBUG: synthese album=${album}=" ; fi
                if [[ ${nbmp3} -eq 0 ]]; then
                    echo -e "=========>${RED}Error no MP3${NC}"
                    counterrormp3=$(expr ${counterrormp3} + 1 )
                    localerror=1
                fi
                if [[ ${nbcover} -eq 0 ]]; then
                    echo -e "=========>${RED}Error no cover${NC}"
                    counterrorcover=$(expr ${counterrorcover} + 1 )
                    localerror=1
                fi
                if [[ ${localerror} -eq 0 ]]; then
                    echo -e "=========>${GREEN}OK${NC}"
                fi
            done <<< "${diralbum}"
        else
            echo  -e "=====>Copying artist : '${artistname}'"
            counterartist=$(expr ${counterartist} + 1 )
            cp -r "${artist}" "${TODIR}/"
            diralbum=$(find "${artist}" -maxdepth 1 -mindepth 1 -type d )
            if [[ "${diralbum}" != "" ]]; then
                count=$(echo "${diralbum}" | wc -l )
                counteralbum=$(expr ${counteralbum} + ${count} )
            fi
            # if no image => nothing
            if [[ ! -f "${TODIR}/${artistname}/folder.jpg" ]]   && [[ ! -f "${TODIR}/${artistname}/folder.png" ]]   && [[ ! -f "${TODIR}/${artistname}/folder.webp" ]]   && \
               [[ ! -f "${TODIR}/${artistname}/backdrop.jpg" ]] && [[ ! -f "${TODIR}/${artistname}/backdrop.png" ]] && [[ ! -f "${TODIR}/${artistname}/backdrop.webp" ]]; then
                counterrorfolder=$(expr ${counterrorfolder} + 1 )
                echo -e "=====>${RED}Error no Folder${NC}"
            # if no artist.nfo => create a nfo file
            elif [[ ! -f "${TODIR}/${artistname}/artist.nfo" ]]; then
                echo "=====>Creating NFO file"
                echo "﻿<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\"?>
<artist>
  <biography />
  <outline />
  <lockdata>false</lockdata>
  <dateadded>$(date +"%Y-%m-%d %H:%M:%S")</dateadded>
  <title>${artistname}</title>
  <runtime>0</runtime>
  <art>" > "${TODIR}/${artistname}/artist.nfo"
                if [[ -f "${TODIR}/${artistname}/folder.jpg" ]]; then
                    echo "    <poster>${TODIR}/${artistname}/folder.jpg</poster>"   >> "${TODIR}/${artistname}/artist.nfo"
                elif [[ -f "${TODIR}/${artistname}/folder.png" ]]; then
                    echo "    <poster>${TODIR}/${artistname}/folder.png</poster>"   >> "${TODIR}/${artistname}/artist.nfo"
                elif [[ -f "${TODIR}/${artistname}/folder.webp" ]]; then
                    echo "    <poster>${TODIR}/${artistname}/folder.webp</poster>"  >> "${TODIR}/${artistname}/artist.nfo"
                fi
                if [[ -f "${TODIR}/${artistname}/backdrop.jpg" ]]; then
                    echo "    <fanart>${TODIR}/${artistname}/backdrop.jpg</fanart>"   >> "${TODIR}/${artistname}/artist.nfo"
                elif [[ -f "${TODIR}/${artistname}/backdrop.png" ]]; then
                    echo "    <fanart>${TODIR}/${artistname}/backdrop.png</fanart>"   >> "${TODIR}/${artistname}/artist.nfo"
                elif [[ -f "${TODIR}/${artistname}/backdrop.webp" ]]; then
                    echo "    <fanart>${TODIR}/${artistname}/backdrop.webp</fanart>"  >> "${TODIR}/${artistname}/artist.nfo"
                fi
                echo "  </art>
</artist>" >> "${TODIR}/${artistname}/artist.nfo"
            # if artist.nfo => update nfo file
            else
                echo "=====>Updating NFO file"
                sed -i -e 's%<poster>.*folder%<poster>'"${TODIR}/${artistname}"'/folder%g' "${TODIR}/${artistname}/artist.nfo"
                sed -i -e 's%<fanart>.*backdrop%<fanart>'"${TODIR}/${artistname}"'/backdrop%g' "${TODIR}/${artistname}/artist.nfo"
            fi
        fi
    done  <<< "${dirartist}"
done <<< "${dirletter}"

localerror=0
echo -e "\n\nEND========================================="
if [[ ${counterrormp3} -ne 0 ]]; then
   echo -e "TOTAL ${RED}Error on MP3${NC}.........: ${counterrormp3}"
   localerror=1
else
   echo -e "TOTAL ${GREEN}No error on MP3${NC}......: ${counteralbum}"
fi
if [[ ${counterrorcover} -ne 0 ]]; then
   echo -e "TOTAL ${RED}Error on cover${NC}.......: ${counterrorcover}"
   localerror=1
else
   echo -e "TOTAL ${GREEN}No error on cover${NC}....: ${counteralbum}"
fi
if [[ ${counterroralbum} -ne 0 ]]; then
   echo -e "TOTAL ${LIGHT_PURPLE}Warning on album${NC}.....: ${counterroralbum}/${counteralbum}"
else
   echo -e "TOTAL ${GREEN}No warning on album${NC}..: ${counteralbum}"
fi
if [[ ${counterrorfolder} -ne 0 ]]; then
   echo -e "TOTAL ${RED}Error on folder${NC}......: ${counterrorfolder}/${counterartist}"
   localerror=1
else
   echo -e "TOTAL ${GREEN}No warning on folder${NC}.: ${counterartist}"
fi
if [[ ${counterrorname} -ne 0 ]]; then
   echo -e "TOTAL ${RED}Error artist name${NC}....: ${counterrorname}/${counterartist}"
   localerror=1
else
   echo -e "TOTAL ${GREEN}No error artist name${NC}.: ${counterartist}"
fi
if [[ ${counterrorartist} -ne 0 ]]; then
   echo -e "TOTAL ${RED}Error on artist${NC}......: ${counterrorartist}/${counterartist}"
   localerror=1
else
   echo -e "TOTAL ${GREEN}No error on artist${NC}...: ${counterartist}"
fi
if [[ ${localerror} -eq 0 ]]; then
   echo -e "TOTAL ${GREEN}OK${NC}"
fi
echo -e "TOTAL Artists: ${counterartist} - Albums : ${counteralbum}"



