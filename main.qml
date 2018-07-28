import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
import "MyViewer" as MyViewer
Window {
    visible: true
    width: 960
    height: 480
    title: qsTr("ImageViewer")

    Text {
        id: lblImageSource
        x: 0
        y: 40
        width: 80
        height: 26
        text: qsTr("Image Source")
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 12
    }


    Rectangle {
        id: rectangleSource
        x: 0
        y: 72
        width: 462
        height: 349
        color: "#ffffff"
        border.width: 3

        TextArea {
            id: imageSource
            x: 0
            y: 0
            width: 462
            height: 349
            //text: qsTr("file:///C:/Users/Hiccup/Downloads/Boss baby.png")
            //text: qsTr("file:///C:/Users/Hiccup/Downloads/giphy.gif")
            //text: "https://freepngimg.com/download/johnny_depp/33706-3-johnny-depp-transparent.png"
            text: "https://media0.giphy.com/media/YVbFW9JoU5v1K/giphy.gif"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            selectByMouse: true
        }
    }

    Rectangle {
        id: rectangleViewer
        x: 499
        y: 72
        width: 461
        height: 349
        color: "#ffffff"
        border.width: 3
        MyViewer.PNGViewer {
            id: pngViewer
            anchors.margins: 3
            border.width: 0
            anchors.fill: parent
            visible: {
                if(comboBox.currentIndex == 0) true;
                else false;
            }
        }
        MyViewer.GIFViewer {
            id: gifViewer
            anchors.margins: 3
            anchors.fill: parent
            border.width: 0
            loop: false
            visible: {
                if(comboBox.currentIndex == 0) false;
                else true;
            }
            onFrameChanged: {
                frameNo.text = currentFrame;
                console.log(frameCount);
                if(!loop && currentFrame == frameCount - 1 && paused) {
                    console.log("paused");
                    playButton.text = "PlayOnce";
                }
            }
        }
    }

    ComboBox {
        id: comboBox
        x: 499
        y: 18
        width: 194
        height: 40
        editable: false
        currentIndex: 1
        model: ListModel {
            id: cmbViewer
            ListElement { text: "PNGViewer" }
            ListElement { text: "GIFViewer" }
        }
    }

    Button {
        id: showImage
        x: 471
        y: 220
        width: 19
        height: 40
        text: qsTr(">")
        onClicked:   {
            if (comboBox.currentIndex == 0)pngViewer.image = imageSource.text;
            if (comboBox.currentIndex == 1){
                gifViewer.image = imageSource.text;
                playButton.enabled = true;
                loopButton.enabled = true;
            }
        }
    }

    Rectangle {
        id: gifPlayRect
        x: 332
        y: 427
        width: 628
        height: 53
        color: "#ffffff"
        border.width: 0
        visible: {
            if(comboBox.currentIndex == 0) false;
            else true;
        }

        Button {
            id: playButton
            x: -102
            y: 13
            width: 70
            height: 40
            text: "PlayOnce"
            enabled: false
            onClicked: {
                gifViewer.loop = false;
                if(gifViewer.paused) {
                    gifViewer.paused = false;
                    text = "Pause";
                }
                else
                {
                    gifViewer.paused = true;
                    text = "PlayOnce";
                }
            }
        }

        Button {
            id: loopButton
            x: -27
            y: 13
            width: 70
            height: 40
            text: "PlayLoop"
            enabled: false
            onClicked: {
                gifViewer.loop = true;
                if(gifViewer.paused) {
                    gifViewer.paused = false;
                    text = "Pause";
                }
                else
                {
                    gifViewer.paused = true;
                    text = "PlayLoop";
                }
            }
        }

        Button {
            id: stop
            x: 124
            y: 13
            width: 70
            height: 40
            text: "Stop"
            onClicked: {
                gifViewer.playing = false;
                gifViewer.paused = true;
                playButton.enabled = true;
                loopButton.enabled = true;
                gifViewer.currentFrame = 0;
                playButton.text = "PlayOnce"
                loopButton.text = "PlayLoop"
            }
        }

        Text {
            id: totalFrames
            x: 233
            y: 26
            width: 135
            height: 14
            text: {
                "totalFrames: " + gifViewer.frameCount
            }

            font.pixelSize: 12
        }

        Button {
            id: priorFrame
            x: 385
            y: 13
            width: 60
            height: 40
            text: qsTr("<")
            onClicked: {
                gifViewer.currentFrame--;
                if(gifViewer.frameCount != 0 && gifViewer.currentFrame == -1)gifViewer.currentFrame += gifViewer.frameCount;
                frameNo.text = gifViewer.currentFrame
            }
        }

        Rectangle {
            id: frameNoBorder
            x: 459
            y: 13
            width: 85
            height: 40
            border.width: 3

            TextInput {
                id: frameNo
                x: 0
                y: 10
                width: 80
                height: 20
                text: "0"
                leftPadding: 5
                padding: 3
                topPadding: 0
                selectByMouse: true
                onTextEdited: {
                    if(frameNo.text >= 0)
                        gifViewer.currentFrame = frameNo.text
                    if(gifViewer.frameCount != 0)gifViewer.currentFrame %= gifViewer.frameCount;
                }
            }
        }

        Button {
            id: nextFrame
            x: 560
            y: 13
            width: 60
            height: 40
            text: qsTr(">")
            onClicked: {
                gifViewer.currentFrame++;
                if(gifViewer.frameCount !=0 )gifViewer.currentFrame %= gifViewer.frameCount;
                frameNo.text = gifViewer.currentFrame
            }
        }
    }
}
