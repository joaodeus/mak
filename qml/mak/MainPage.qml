import QtQuick 1.1
import com.nokia.meego 1.0
import QtMultimediaKit 1.1
import "js/countdown.js" as Conv

Page {
    tools: commonTools
    id:totalarea

    Image {
        id: clock
        source: "images/meegoclock400.png"
        width: 400
        height: 400
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    Image {
        id: secondPointer
        anchors.horizontalCenter: parent.horizontalCenter
        height: 140
        y: (centerPoint.y + centerPoint.height/2) - height
        source: "images/second.png"
        smooth: true
        transform: Rotation {
            id: secondRotation
            origin.x: 2.5
            origin.y: secondPointer.height
        }
    }

    Image {
        id: minutePointer
        anchors.horizontalCenter: parent.horizontalCenter
        height: secondPointer.height
        y: (centerPoint.y + centerPoint.height/2) - height
        source: "images/minute.png"
        smooth: true
        transform: Rotation {
            id: minuteRotation
            origin.x: 6.5
            origin.y: minutePointer.height
        }
    }

    Image {
        id: centerPoint
        anchors.centerIn: clock
        source: "images/center.png"
    }

    Rectangle {
        id: timeLCD
        width: 100
        height: 30
        radius: 8
        color: "#FFFFFF"
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: centerPoint.bottom
            topMargin: 30
        }
        Text {
            id: timeSeparator
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: ":"
            font {
                bold: true
                family: "Courier"
                pixelSize: 25
            }
        }

        Text {
            id: timeMinutes
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: timeSeparator.left
            text: "00"
            font {
                bold: true
                family: "Courier"
                pixelSize: 25
            }
        }

        Text {
            id: timeSeconds
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: timeSeparator.right
            text: "00"
            font {
                bold: true
                family: "Courier"
                pixelSize: 25
            }
        }
    }

    MouseArea {
        id: clockClickArea
        anchors.fill: clock
        onMousePositionChanged: {
            countDown.running = false;
            secondPointer.visible = false;
            var x_centro;
            var y_centro;
            var angulo;
            var minutes;
            var seconds;
            var minutes_angle;
            var seconds_angle;
            x_centro = clock.width/2;
            y_centro = clock.height/2;
            angulo = Conv.getAngle(x_centro, y_centro, clockClickArea.mouseX, clockClickArea.mouseY);
            minutes = Conv.getMinutesFromAngle(angulo);
            seconds = Conv.getSecondsFromAngle(angulo);
            minutes_angle = Conv.getMinutesAngleFromTime(minutes, seconds);
            minuteRotation.angle = minutes_angle;
            timeSeconds.text = ((seconds <= 9) ? ("0") : ("")) + seconds;
            timeMinutes.text = ((minutes <= 9) ? ("0") : ("")) + minutes;
        }

        onReleased: {
            countDown.running = true;
        }
    }

    Timer {
        id: countDown
        interval: 1000
        repeat: true
        onTriggered: {
            secondPointer.visible = true;
            var minutes;
            var seconds;
            var minutes_angle;
            var seconds_angle;
            var total_seconds;
            minutes = parseInt(timeMinutes.text, 10);
            seconds = parseInt(timeSeconds.text, 10);
            total_seconds = Conv.convertMinSecToSec(minutes, seconds);
            total_seconds--;
            if (total_seconds <= 0) {
                countDown.running = false;
                alarm.play();
            }
            minutes = Conv.convertSecToMinSec(total_seconds, 1);
            seconds = Conv.convertSecToMinSec(total_seconds, 2);
            minutes_angle = Conv.getMinutesAngleFromTime(minutes, seconds);
            seconds_angle = Conv.getSecondsAngleFromTime(seconds);
            minuteRotation.angle = minutes_angle;
            secondRotation.angle = seconds_angle;
            timeSeconds.text = ((seconds <= 9) ? ("0") : ("")) + seconds;
            timeMinutes.text = ((minutes <= 9) ? ("0") : ("")) + minutes;
        }
    }

    SoundEffect {
        id: alarm
        source: "sounds/beep-01.wav"
        loops: 5
    }

    Rectangle {
        id: info
        width: 60
        height: 60
        color: "transparent"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        Image {
            id: btInfo
            source: "images/info.png"
            anchors.fill: parent
            anchors.margins: 5
        }
        MouseArea {
            id: infoClickArea
            anchors.fill: parent
            onClicked: {
                about.visible = !about.visible;
                clockClickArea.enabled = !about.visible;
                aboutClickArea.enabled = about.visible;
            }
        }
    }


    Rectangle {
        id: about
        visible: false
        anchors.centerIn: parent
        opacity: 0.8
        y: 0
        radius: 8
        width: 430
        height: 350
        Label {
            id: name
            anchors.verticalCenter: parent.verticalCenter
            anchors.fill: parent
            anchors.margins: 10
            text: qsTr("<b>Lead Designer</b><br />João de Deus<br /><br /><b>Lead Developer</b><br />Flávio Simões<br /><br /><b>Website:</b> soft-ingenium.planetaclix.pt<br /><b>E-mail:</b> joaodeusmorgado@yahoo.com<br /><br />Version: 1.0.0")
        }
        MouseArea {
            id: aboutClickArea
            anchors.fill: parent
            onClicked: {
                aboutClickArea.enabled = false;
                about.visible = false;
                clockClickArea.enabled = true;
            }
        }
    }
}
