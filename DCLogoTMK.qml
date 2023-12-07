import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Item {
    id: tmLogoTMK

    property int ntCoff: 1
    property color clrFona: "black"
    property color clrLogo: "orange"

    width: 16*ntCoff
    height: width

    Rectangle {
        id: rctLogoTMK
        color: clrFona
        anchors.fill: tmLogoTMK

        Rectangle {
            id: rctLogoT
            width: 5*tmLogoTMK.ntCoff
            height: width
            color: "transparent"
            anchors.top: rctLogoTMK.top
            anchors.left: rctLogoTMK.left
            anchors.topMargin: 4*tmLogoTMK.ntCoff
            anchors.leftMargin: 1*tmLogoTMK.ntCoff

            Rectangle {
                id: rctGorizont
                width: 5*tmLogoTMK.ntCoff
                height: 1*tmLogoTMK.ntCoff
                radius: height/4
                color: tmLogoTMK.clrLogo

                anchors.top: rctLogoT.top
                anchors.left: rctLogoT.left
            }

            Rectangle {
                id: rctVertikal
                width: 1*tmLogoTMK.ntCoff
                height: 5*tmLogoTMK.ntCoff
                radius: width/4
                color: tmLogoTMK.clrLogo

                anchors.top: rctLogoT.top
                anchors.horizontalCenter: rctLogoT.horizontalCenter
            }
        }

        Rectangle {
            id: rctLogoM
            width: 5*tmLogoTMK.ntCoff
            height: width
            color: "transparent"
            anchors.top: rctLogoTMK.top
            anchors.left: rctLogoTMK.left
            anchors.topMargin: 6*tmLogoTMK.ntCoff
            anchors.leftMargin: 5*tmLogoTMK.ntCoff

            Rectangle {
                id: rctVertikalMOdin
                width: 1*tmLogoTMK.ntCoff
                height: 5*tmLogoTMK.ntCoff
                radius: width/4
                color: tmLogoTMK.clrLogo

                anchors.top: rctLogoM.top
                anchors.left: rctLogoM.left
            }

            Rectangle {
                id: rctVertikalMDva
                width: 1*tmLogoTMK.ntCoff
                height: 1*tmLogoTMK.ntCoff
                radius: width/4
                color: tmLogoTMK.clrLogo

                anchors.top: rctLogoM.top
                anchors.left: rctVertikalMOdin.right
                anchors.topMargin: 1*tmLogoTMK.ntCoff
            }

            Rectangle {
                id: rctVertikalMTri
                width: 1*tmLogoTMK.ntCoff
                height: 1*tmLogoTMK.ntCoff
                radius: width/4
                color: tmLogoTMK.clrLogo

                anchors.top: rctLogoM.top
                anchors.left: rctVertikalMDva.right
                anchors.topMargin: 2*tmLogoTMK.ntCoff
            }

            Rectangle {
                id: rctVertikalMChetiri
                width: 1*tmLogoTMK.ntCoff
                height: 1*tmLogoTMK.ntCoff
                radius: width/4
                color: tmLogoTMK.clrLogo

                anchors.top: rctLogoM.top
                anchors.left: rctVertikalMTri.right
                anchors.topMargin: 1*tmLogoTMK.ntCoff
            }

            Rectangle {
                id: rctVertikalMPiyat
                width: 1*tmLogoTMK.ntCoff
                height: 5*tmLogoTMK.ntCoff
                radius: width/4
                color: tmLogoTMK.clrLogo

                anchors.top: rctLogoM.top
                anchors.left: rctVertikalMChetiri.right
            }

        }

        Rectangle {
            id: rctLogoK
            width: 5*tmLogoTMK.ntCoff
            height: width
            color:  "transparent"
            anchors.top: rctLogoTMK.top
            anchors.left: rctLogoTMK.left
            anchors.topMargin: 8*tmLogoTMK.ntCoff
            anchors.leftMargin: 11*tmLogoTMK.ntCoff

            Rectangle {
                id: rctVertikalKOdin
                width: 1*tmLogoTMK.ntCoff
                height: 5*tmLogoTMK.ntCoff
                radius: width/4
                color: tmLogoTMK.clrLogo

                anchors.top: rctLogoK.top
                anchors.left: rctLogoK.left
            }

            Rectangle {
                id: rctVertikalKDva
                width: 1*tmLogoTMK.ntCoff
                height: 1*tmLogoTMK.ntCoff
                radius: width/4
                color: tmLogoTMK.clrLogo

                anchors.top: rctLogoK.top
                anchors.left: rctVertikalKOdin.right
                anchors.topMargin: 2*tmLogoTMK.ntCoff
            }

            Rectangle {
                id: rctVertikalKTri
                width: 1*tmLogoTMK.ntCoff
                height: 1*tmLogoTMK.ntCoff
                radius: width/4
                color: tmLogoTMK.clrLogo

                anchors.top: rctLogoK.top
                anchors.left: rctVertikalKDva.right
                anchors.topMargin: 1*tmLogoTMK.ntCoff
            }

            Rectangle {
                id: rctVertikalKChetiri
                width: 1*tmLogoTMK.ntCoff
                height: 1*tmLogoTMK.ntCoff
                radius: width/4
                color: tmLogoTMK.clrLogo

                anchors.top: rctLogoK.top
                anchors.left: rctVertikalKTri.right
            }

            Rectangle {
                id: rctVertikalKPiyat
                width: 1*tmLogoTMK.ntCoff
                height: 1*tmLogoTMK.ntCoff
                radius: width/4
                color: tmLogoTMK.clrLogo

                anchors.top: rctLogoK.top
                anchors.left: rctVertikalKDva.right
                anchors.topMargin: 3*tmLogoTMK.ntCoff
            }

            Rectangle {
                id: rctVertikalKShest
                width: 1*tmLogoTMK.ntCoff
                height: 1*tmLogoTMK.ntCoff
                radius: width/4
                color: tmLogoTMK.clrLogo

                anchors.top: rctLogoK.top
                anchors.left: rctVertikalKTri.right
                anchors.topMargin: 4*tmLogoTMK.ntCoff
            }

        }
    }
}
