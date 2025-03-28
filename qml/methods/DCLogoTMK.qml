import QtQuick //2.15

Item {
    id: tmLogoTMK

    property int ntCoff: 1
    property color clrFona: "black"
    property color clrLogo: "orange"

    width: 16*ntCoff
    height: width

    Rectangle {
        id: rctLogoTMK
        anchors.fill: tmLogoTMK
        clip: true //Все прямоугольники, которые будут внутри, будут обрезаться по его границам.
        color: clrFona
        Rectangle {
            id: rctKrugPervi
            width: rctLogoTMK.width*2
            height: width
            anchors.right: rctLogoTMK.right
            anchors.top: rctLogoTMK.top
            anchors.rightMargin: -rctLogoTMK.width/1024
            anchors.topMargin: -rctLogoTMK.width/1024
            color: tmLogoTMK.clrLogo
            radius: width/2
        }
        Rectangle {
            id: rctKrugVtoroi
            width: rctLogoTMK.width*2.4
            height: width
            anchors.right: rctLogoTMK.right
            anchors.top: rctLogoTMK.top
            anchors.rightMargin: -rctLogoTMK.width/96
            anchors.topMargin: -rctLogoTMK.width/96
            color: tmLogoTMK.clrFona
            radius: width/2
        }
        Rectangle {
            id: rctLogoT
            width: 5*tmLogoTMK.ntCoff
            height: width
            anchors.top: rctLogoTMK.top
            anchors.left: rctLogoTMK.left
            anchors.topMargin: 7*tmLogoTMK.ntCoff
            color: "transparent"
            Rectangle {
                id: rctGorizont
                width: 5*tmLogoTMK.ntCoff
                height: 1*tmLogoTMK.ntCoff
                anchors.top: rctLogoT.top
                anchors.left: rctLogoT.left
                color: tmLogoTMK.clrLogo
                radius: height/4
            }
            Rectangle {
                id: rctVertikal
                width: 1*tmLogoTMK.ntCoff
                height: 5*tmLogoTMK.ntCoff
                anchors.top: rctLogoT.top
                anchors.horizontalCenter: rctLogoT.horizontalCenter
                color: tmLogoTMK.clrLogo
                radius: width/4
            }
        }
        Rectangle {
            id: rctLogoM
            width: 5*tmLogoTMK.ntCoff
            height: width
            anchors.top: rctLogoTMK.top
            anchors.left: rctLogoTMK.left
            anchors.topMargin: 9*tmLogoTMK.ntCoff
            anchors.leftMargin: 4*tmLogoTMK.ntCoff
            color: "transparent"
            Rectangle {
                id: rctVertikalMOdin
                width: 1*tmLogoTMK.ntCoff
                height: 5*tmLogoTMK.ntCoff
                anchors.top: rctLogoM.top
                anchors.left: rctLogoM.left
                color: tmLogoTMK.clrLogo
                radius: width/4
            }
            Rectangle {
                id: rctVertikalMDva
                width: 1*tmLogoTMK.ntCoff
                height: 1*tmLogoTMK.ntCoff
                anchors.top: rctLogoM.top
                anchors.left: rctVertikalMOdin.right
                anchors.topMargin: 1*tmLogoTMK.ntCoff
                color: tmLogoTMK.clrLogo
                radius: width/4
            }
            Rectangle {
                id: rctVertikalMTri
                width: 1*tmLogoTMK.ntCoff
                height: 1*tmLogoTMK.ntCoff
                anchors.top: rctLogoM.top
                anchors.left: rctVertikalMDva.right
                anchors.topMargin: 2*tmLogoTMK.ntCoff
                color: tmLogoTMK.clrLogo
                radius: width/4
            }
            Rectangle {
                id: rctVertikalMChetiri
                width: 1*tmLogoTMK.ntCoff
                height: 1*tmLogoTMK.ntCoff
                anchors.top: rctLogoM.top
                anchors.left: rctVertikalMTri.right
                anchors.topMargin: 1*tmLogoTMK.ntCoff
                color: tmLogoTMK.clrLogo
                radius: width/4
            }
            Rectangle {
                id: rctVertikalMPiyat
                width: 1*tmLogoTMK.ntCoff
                height: 5*tmLogoTMK.ntCoff
                anchors.top: rctLogoM.top
                anchors.left: rctVertikalMChetiri.right
                color: tmLogoTMK.clrLogo
                radius: width/4
            }
        }
        Rectangle {
            id: rctLogoK
            width: 5*tmLogoTMK.ntCoff
            height: width
            anchors.top: rctLogoTMK.top
            anchors.left: rctLogoTMK.left
            anchors.topMargin: 11*tmLogoTMK.ntCoff
            anchors.leftMargin: 10*tmLogoTMK.ntCoff
            color:  "transparent"
            Rectangle {
                id: rctVertikalKOdin
                width: 1*tmLogoTMK.ntCoff
                height: 5*tmLogoTMK.ntCoff
                anchors.top: rctLogoK.top
                anchors.left: rctLogoK.left
                color: tmLogoTMK.clrLogo
                radius: width/4
            }
            Rectangle {
                id: rctVertikalKDva
                width: 1*tmLogoTMK.ntCoff
                height: 1*tmLogoTMK.ntCoff
                anchors.top: rctLogoK.top
                anchors.left: rctVertikalKOdin.right
                anchors.topMargin: 2*tmLogoTMK.ntCoff
                color: tmLogoTMK.clrLogo
                radius: width/4
            }
            Rectangle {
                id: rctVertikalKTri
                width: 1*tmLogoTMK.ntCoff
                height: 1*tmLogoTMK.ntCoff
                anchors.top: rctLogoK.top
                anchors.left: rctVertikalKDva.right
                anchors.topMargin: 1*tmLogoTMK.ntCoff
                color: tmLogoTMK.clrLogo
                radius: width/4
            }
            Rectangle {
                id: rctVertikalKChetiri
                width: 1*tmLogoTMK.ntCoff
                height: 1*tmLogoTMK.ntCoff
                anchors.top: rctLogoK.top
                anchors.left: rctVertikalKTri.right
                color: tmLogoTMK.clrLogo
                radius: width/4
            }
            Rectangle {
                id: rctVertikalKPiyat
                width: 1*tmLogoTMK.ntCoff
                height: 1*tmLogoTMK.ntCoff
                anchors.top: rctLogoK.top
                anchors.left: rctVertikalKDva.right
                anchors.topMargin: 3*tmLogoTMK.ntCoff
                color: tmLogoTMK.clrLogo
                radius: width/4
            }
            Rectangle {
                id: rctVertikalKShest
                width: 1*tmLogoTMK.ntCoff
                height: 1*tmLogoTMK.ntCoff
                anchors.top: rctLogoK.top
                anchors.left: rctVertikalKTri.right
                anchors.topMargin: 4*tmLogoTMK.ntCoff
                color: tmLogoTMK.clrLogo
                radius: width/4
            }
        }
    }
}
