#include "dcfiledialog.h"

DCFileDialog::DCFileDialog(QObject* proditel) : QObject(proditel){//Конструктор.
////////////////////////////////
//---К О Н С Т Р У К Т О-Р----//
////////////////////////////////

    m_blFileDialogPervi = true;//Первый запуск проводника - это истина.
}

DCFileDialog::~DCFileDialog(){//Деструктор.
/////////////////////////////
//---Д Е С Т Р У К Т О Р---//
/////////////////////////////

}
