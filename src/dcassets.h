#ifndef DCASSETS_H
#define DCASSETS_H

#include <QString>

//Сборка MENTOR_DB_MOBILE=ON: база druidcat.db и все документы
//лежат внутри установочного пакета (Android — assets APK, Аврора — каталог
//внутри RPM). DCAssets распаковывает их в записываемый каталог данных
//приложения при первом запуске и обновляет при смене версии бандла.
class DCAssets
{
public:
    static QString polDataPut(const QString& strImyaKataloga);//Каталог данных + подкаталог.
    static bool obnovitRabochieData(const QString& strRabochiPut);//Синхронизировать с пакетом.
    static QString polPosledneyayaOshestka();//Ошибка распаковки пакета ('' если всё хорошо).
};

#endif // DCASSETS_H
