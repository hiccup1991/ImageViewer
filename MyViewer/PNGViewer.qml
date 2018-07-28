import QtQuick 2.9
import QtQml 2.2
import FileIO 1.0

Rectangle {
    id: root
    color: "transparent"
    property string image: ""        // url or base64 data of the png image
    property real fillMode: Image.Stretch
    Image{
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
                if(text.indexOf("data:image/png;base64,", 0) === 0)
                    text;
                else
                    "data:image/png;base64," + text;
            }
            /**base64 data (included header) on textArea**/
            else if(image.indexOf("data:image/png;base64,", 0) == 0){
                image;
            }
            /**base64 data (non included header) on textArea**/
            else if(image != ""){
                "data:image/png;base64," + image;
            }
            /**init**/
            else "";
        }
    }

    FileIO {
        id: myFile
        onError: console.log(msg)
    }
}
