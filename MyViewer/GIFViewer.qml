import QtQuick 2.9
import QtQml 2.2
import FileIO 1.0

Rectangle {
    id: root
    color: "transparent"
    property string image: ""                                       // url or base64 data of the gif image
    property real fillMode: Image.Stretch                           // image fillMode
    property int currentFrame: 0                                    // can be used goto any frame.
    property int frameCount: gifImage.frameCount           // total frame cout
    property bool playing: false                                    // can be used play/stop
    property bool loop: false                                       // can be used play Once/Loop
    property bool paused: true                                      // can be used play/pause


    signal frameChanged()
    onFrameChanged: {
        currentFrame = gifImage.currentFrame;
        frameCount = gifImage.frameCount;
        if(!loop && !gifImage.paused && gifImage.currentFrame == gifImage.frameCount - 1){
            console.log("paused");
            gifImage.paused = true;
            paused = true;
        }
    }
    onPlayingChanged: gifImage.playing = playing
    onPausedChanged: gifImage.paused = paused
    onCurrentFrameChanged: gifImage.currentFrame = currentFrame



    AnimatedImage{
        id: gifImage
        fillMode: parent.fillMode
        anchors.fill: parent
        source:
        {
            /**file:/// or http://**/
            if(image.toLowerCase().indexOf("http", 0) === 0 || image.toLowerCase().indexOf("file", 0) === 0)
            {
                image;
            }
            /**txt file included base64 data **/
            else if(image.toLowerCase().lastIndexOf(".txt") == image.length - 4){
                myFile.source = image;
                var text = myFile.read();
                if(text.indexOf("data:image/gif;base64,", 0) === 0)
                    text;
                else
                    "data:image/gif;base64," + text;
            }
            /**base64 data (included header) on textArea**/
            else if(image.indexOf("data:image/gif;base64,", 0) == 0){
                image;
            }
            /**base64 data (non included header) on textArea**/
            else if(image != ""){
                "data:image/gif;base64," + image;
            }
            /**init**/
            else "";
        }        
        Component.onCompleted: {
            gifImage.frameChanged.connect(parent.frameChanged);
            paused = true;
        }
    }

    FileIO {
        id: myFile
        onError: console.log(msg)
    }
}
