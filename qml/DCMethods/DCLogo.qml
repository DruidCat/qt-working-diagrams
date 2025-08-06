import QtQuick //2.15
//Логотип ТМК
Item {
    id: root
    //Свойства.
    property int ntCoff: 1
    property color clrFona: "black"
    property color clrLogo: "orange"
    property string logoImya: "mentor"
    //Настройки.
    width: ntCoff*14.6875
    height: ntCoff*14.6875
    Image {
        id: imgTMK
        source: {
            if(logoImya === "mentor")
                return "qrc:/images/tmk-color-1.svg"
            else{
                if(logoImya === "tmk")
                    return "qrc:/images/tmk-color-1.svg"
                else{
                    if(logoImya === "tmk-ts")
                        return "qrc:/images/ts-rus-color.svg"
                    else{
                        if(logoImya === "tmk-ts-o")
                            return "qrc:/images/ts-rus-orange.svg"
                        else{
                            if(logoImya === "tmk-ts-o-1")
                                return "qrc:/images/ts-rus-orange-1.svg"
                            else{
                                if(logoImya === "tmk-ts-bw-1")
                                    return "qrc:/images/ts-rus-black-and-white-1.svg"
                                else{
                                    if(logoImya === "tmk-ts-bw-2")
                                        return "qrc:/images/ts-rus-black-and-white-2.svg"
                                }
                            }
                        }
                    }
                }
            }
        }
        sourceSize: Qt.size(232, 232)
        anchors.fill: root
        //Это свойство важно для качественного рендеринга SVG. Мы указываем исходный размер изображения.
        fillMode: Image.PreserveAspectFit//Сохраняем пропорции
        opacity: 1
    }
    /*
    //Настройки.
    width: 16*ntCoff
    height: width
    //Функции.
    Rectangle {
        id: rctLogoTMK
        anchors.fill: root
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
            color: root.clrLogo
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
            color: root.clrFona
            radius: width/2
        }
        Rectangle {
            id: rctLogoT
            width: 5*root.ntCoff
            height: width
            anchors.top: rctLogoTMK.top
            anchors.left: rctLogoTMK.left
            anchors.topMargin: 7*root.ntCoff
            color: "transparent"
            Rectangle {
                id: rctGorizont
                width: 5*root.ntCoff
                height: 1*root.ntCoff
                anchors.top: rctLogoT.top
                anchors.left: rctLogoT.left
                color: root.clrLogo
                radius: height/4
            }
            Rectangle {
                id: rctVertikal
                width: 1*root.ntCoff
                height: 5*root.ntCoff
                anchors.top: rctLogoT.top
                anchors.horizontalCenter: rctLogoT.horizontalCenter
                color: root.clrLogo
                radius: width/4
            }
        }
        Rectangle {
            id: rctLogoM
            width: 5*root.ntCoff
            height: width
            anchors.top: rctLogoTMK.top
            anchors.left: rctLogoTMK.left
            anchors.topMargin: 9*root.ntCoff
            anchors.leftMargin: 4*root.ntCoff
            color: "transparent"
            Rectangle {
                id: rctVertikalMOdin
                width: 1*root.ntCoff
                height: 5*root.ntCoff
                anchors.top: rctLogoM.top
                anchors.left: rctLogoM.left
                color: root.clrLogo
                radius: width/4
            }
            Rectangle {
                id: rctVertikalMDva
                width: 1*root.ntCoff
                height: 1*root.ntCoff
                anchors.top: rctLogoM.top
                anchors.left: rctVertikalMOdin.right
                anchors.topMargin: 1*root.ntCoff
                color: root.clrLogo
                radius: width/4
            }
            Rectangle {
                id: rctVertikalMTri
                width: 1*root.ntCoff
                height: 1*root.ntCoff
                anchors.top: rctLogoM.top
                anchors.left: rctVertikalMDva.right
                anchors.topMargin: 2*root.ntCoff
                color: root.clrLogo
                radius: width/4
            }
            Rectangle {
                id: rctVertikalMChetiri
                width: 1*root.ntCoff
                height: 1*root.ntCoff
                anchors.top: rctLogoM.top
                anchors.left: rctVertikalMTri.right
                anchors.topMargin: 1*root.ntCoff
                color: root.clrLogo
                radius: width/4
            }
            Rectangle {
                id: rctVertikalMPiyat
                width: 1*root.ntCoff
                height: 5*root.ntCoff
                anchors.top: rctLogoM.top
                anchors.left: rctVertikalMChetiri.right
                color: root.clrLogo
                radius: width/4
            }
        }
        Rectangle {
            id: rctLogoK
            width: 5*root.ntCoff
            height: width
            anchors.top: rctLogoTMK.top
            anchors.left: rctLogoTMK.left
            anchors.topMargin: 11*root.ntCoff
            anchors.leftMargin: 10*root.ntCoff
            color:  "transparent"
            Rectangle {
                id: rctVertikalKOdin
                width: 1*root.ntCoff
                height: 5*root.ntCoff
                anchors.top: rctLogoK.top
                anchors.left: rctLogoK.left
                color: root.clrLogo
                radius: width/4
            }
            Rectangle {
                id: rctVertikalKDva
                width: 1*root.ntCoff
                height: 1*root.ntCoff
                anchors.top: rctLogoK.top
                anchors.left: rctVertikalKOdin.right
                anchors.topMargin: 2*root.ntCoff
                color: root.clrLogo
                radius: width/4
            }
            Rectangle {
                id: rctVertikalKTri
                width: 1*root.ntCoff
                height: 1*root.ntCoff
                anchors.top: rctLogoK.top
                anchors.left: rctVertikalKDva.right
                anchors.topMargin: 1*root.ntCoff
                color: root.clrLogo
                radius: width/4
            }
            Rectangle {
                id: rctVertikalKChetiri
                width: 1*root.ntCoff
                height: 1*root.ntCoff
                anchors.top: rctLogoK.top
                anchors.left: rctVertikalKTri.right
                color: root.clrLogo
                radius: width/4
            }
            Rectangle {
                id: rctVertikalKPiyat
                width: 1*root.ntCoff
                height: 1*root.ntCoff
                anchors.top: rctLogoK.top
                anchors.left: rctVertikalKDva.right
                anchors.topMargin: 3*root.ntCoff
                color: root.clrLogo
                radius: width/4
            }
            Rectangle {
                id: rctVertikalKShest
                width: 1*root.ntCoff
                height: 1*root.ntCoff
                anchors.top: rctLogoK.top
                anchors.left: rctVertikalKTri.right
                anchors.topMargin: 4*root.ntCoff
                color: root.clrLogo
                radius: width/4
            }
        }
    }
    */
}
