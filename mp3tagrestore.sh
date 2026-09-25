# mymp3liste=$(find . -maxdepth 1 -mindepth 1  -type f -name '*.mp3' -printf '%P\n')
mymp3liste=$(ls *.mp3)
IFSold="$IFS"
while IFS= read -r mymp3file; do
    echo "******************************************************************************** Debut traitement"
	echo "Traitement file : ${mymp3file}"
	mv "${mymp3file}" "temp.mp3"
	echo "********************************** Debut traitement ffmpeg"
	ffmpeg -nostdin -i "temp.mp3" -acodec copy "result.mp3"
	#cp temp.mp3 result.mp3
	echo "********************************** Fin traitement ffmpeg"
	rm "temp.mp3"
	mv "result.mp3" "${mymp3file}"
done <<< "${mymp3liste}"

