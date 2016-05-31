function setversion(){
	sed -i "" -e "s/SDK_VERSION = @\".*;/SDK_VERSION = @\"$1\";/g" ./src/ios/RevMobPlugin.m
	sed -i "" -e "s/SDK_VERSION = \".*/SDK_VERSION = \"$1\";/g" ./src/android/RevMobPlugin.java
	sed -i "" -e "1,// s/version.*/version\": \"$1\",/" package.json
	sed -i "" -e "1,// s/plugin\" version.*/plugin\" version=\"$1\"\>/" plugin.xml
	echo Updated Cordova version: $1
}

# call arguments verbatim:
$@