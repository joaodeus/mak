import QtQuick 1.1
import com.nokia.meego 1.0
import QtMultimediaKit 1.1
import "js/countdown.js" as Conv

Page {
    tools: commonTools

    Image {
        id: clock
        source: "images/clock_meego_blue.png"
        width: 400
        height: 400
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    Image {
        id: secondPointer
        anchors.horizontalCenter: parent.horizontalCenter
        height: 150
        y: (centerPoint.y + centerPoint.height/2) - height
        source: "images/second.png"
        smooth: true
        transform: Rotation {
            id: secondRotation
            origin.x: 2.5
            origin.y: secondPointer.height
            /*Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }*/
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
            /*Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }*/
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
            //seconds_angle = Conv.getSecondsAngleFromTime(seconds);
            minuteRotation.angle = minutes_angle;
            //secondRotation.angle = seconds_angle;
            timeSeconds.text = ((seconds <= 9) ? ("0") : ("")) + seconds;
            timeMinutes.text = ((minutes <= 9) ? ("0") : ("")) + minutes;
            //label.text = angulo;
            //label2.text = x_centro + " ** " + y_centro + " ** " + clockClickArea.mouseX + " ** " + clockClickArea.mouseY
        }

        onReleased: {
            countDown.running = true;
        }
    }

    /*
    Label {
        id: label
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: timeLCD.bottom
            topMargin: 30
        }
    }

    Label {
        id: label2
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: label.bottom
            topMargin: 30
        }
    }

    Button {
        id: btStart
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: label.bottom
            topMargin: 20
        }
        text: qsTr("Start")
        onClicked: if (btStart.text == "Start") {
                       btStart.text = "Stop";
                       countDown.running = true;
                   } else {
                       btStart.text = "Start";
                       countDown.running = false;
                   }
    }
    */

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
            //if ((minutes === 0) && ((seconds <= 5) || (seconds === 30))) beep.play();
            //beep.play();
        }
    }

    SoundEffect {
        id: beep
        source: "sounds/beep-07.wav"
        volume: 0.5
    }

    SoundEffect {
        id: alarm
        source: "sounds/beep-01.wav"
        loops: 5
        volume: 1.0
    }

    Rectangle {
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
                info.visible = !info.visible;
                clockClickArea.enabled = !info.visible
            }
        }
    }

    Rectangle {
        id: info
        visible: false
        anchors.centerIn: parent
        opacity: 0.7
        y: 0
        radius: 8
        width: 400
        height: 200
        Text {
            id: name
            text: qsTr("<b>Lead Designer</b><br />João de Deus<br /><br /><b>Lead Developer</b><br />Flávio Simões<br /><br /><b>Website:</b> soft-ingenium.planetaclix.pt<br /><b>E-mail:</b> joaodeusmorgado@yahoo.com<br /><br />Version: 1.0.0")
        }
    }
}
