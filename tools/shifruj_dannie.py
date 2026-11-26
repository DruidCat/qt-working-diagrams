#!/usr/bin/env python3
# Шифрование workingdata для защищённой Android-сборки (MENTOR_DATA_ENCRYPTED=ON).
# Формат бандла "mentor-lic-v1" (расшифровывает приложение, см. src/dcassets.cpp):
#  - tar всего workingdata шифруется AES-256-GCM чанками; каждый чанк в файле
#    dannie.tar.enc как [u32 LE длина шифртекста][шифртекст+тег]; для чанка i
#    nonce = blob_nonce_base (4 байта) + счётчик u64 LE.
#  - licenziya.bin: JSON с параметрами и таблицей устройств: для каждого кода
#    key_i = PBKDF2-HMAC-SHA256(master_secret, salt_i, iterations, 32),
#    salt_i = SHA256("mentor-wrap-v1|" + код), E_i = AES-256-GCM(key_i, DK).
#    DK - случайные 32 байта, шифрующие данные; в APK попадают только E_i.
# Мастер-секрет в репозиторий НЕ попадает: он в license.json вне git (путь ниже или
# MENTOR_LICENSE_JSON) и компилируется в бинарь CMake'ом.
# Запуск: tools/shifruj_dannie.py [каталог_проекта]
# Источник данных: MENTOR_WORKINGDATA или workingdata проекта (как у sync-скрипта).
import hashlib
import io
import json
import os
import secrets
import shutil
import struct
import subprocess
import sys
import tarfile

CHUNK = 1048576                                    # 1 МиБ открытого текста на чанк
WRAP_PREFIX = "mentor-wrap-v1|"


def sohtit_salt(kod):                              # соль ключа телефона = его код
    return hashlib.sha256((WRAP_PREFIX + kod).encode("utf-8")).digest()


def pol_wersiyu(repo_dir):                         # версия бандла как у sync-скрипта
    ver = os.environ.get("MENTOR_BUNDLE_VERSION")
    if ver:
        return ver
    try:
        return subprocess.run(
            ["git", "-C", repo_dir, "describe", "--tags", "--match", "v[0-9]*"],
            capture_output=True, text=True, check=True).stdout.strip() or "0.0.0"
    except Exception:
        return "0.0.0"


def shifrovat(src_dir, dst_dir, lic, master, ver):
    from cryptography.hazmat.primitives.ciphers.aead import AESGCM
    iters = int(lic.get("kdf_iterations", 100000))
    dk = secrets.token_bytes(32)
    entries = []
    for dev in lic.get("devices", []):
        kod = dev["code"].strip().lower()
        key = hashlib.pbkdf2_hmac("sha256", master, sohtit_salt(kod), iters, 32)
        nonce = secrets.token_bytes(12)
        ct = AESGCM(key).encrypt(nonce, dk, None)  # E_i: DK, завёрнутый в ключ телефона
        entries.append({"code": kod, "salt": sohtit_salt(kod).hex(),
                        "wrap_nonce": nonce.hex(), "wrap_ct": ct.hex()})
    if not entries:
        sys.exit("ОШИБКА: в лицензии нет ни одного кода устройства")
    blob_base = secrets.token_bytes(4)
    if os.path.isdir(dst_dir):                     # старый открытый бандл удаляем:
        shutil.rmtree(dst_dir)                     # он не должен остаться в APK
    os.makedirs(dst_dir)
    with open(os.path.join(dst_dir, "bundleversion.txt"), "w") as f:
        f.write(ver + "\n")
    licenziya = {"format": "mentor-lic-v1", "cipher": "aes-256-gcm",
                 "chunk_size": CHUNK, "blob_nonce_base": blob_base.hex(),
                 "kdf": "pbkdf2-hmac-sha256", "iterations": iters,
                 "devices": entries}
    with open(os.path.join(dst_dir, "licenziya.bin"), "w", encoding="utf-8") as f:
        json.dump(licenziya, f)
    aes = AESGCM(dk)
    unt_cantok = 0
    with open(os.path.join(dst_dir, "dannie.tar.enc"), "wb") as out:
        buff = io.BytesIO()
        # GNU_FORMAT: предсказуемые ustar-блоки для коротких имён - их понимает
        # минимальный парсер приложения (TarRasparshivatel в src/dcassets.cpp).
        with tarfile.open(fileobj=buff, mode="w", format=tarfile.GNU_FORMAT) as tar:
            tar.add(src_dir, arcname=".")
        # ВАЖНО: читать buff только ПОСЛЕ закрытия tar - close() дописывает два
        # пустых блока-терминатора и выравнивание до 10240, без них парсер
        # приложения не увидит конец архива.
        buff.seek(0)
        while True:
            data = buff.read(CHUNK)
            if not data:
                break
            ct = aes.encrypt(blob_base + struct.pack("<Q", unt_cantok), data, None)
            out.write(struct.pack("<I", len(ct)))
            out.write(ct)
            unt_cantok += 1
    return entries, unt_cantok


def prowerit(dst_dir, master, kod, iters):
    # Самопроверка: ключом первого устройства развернуть DK из записи licenziya.bin,
    # расшифровать blob, разобрать tar и посчитать файлы.
    from cryptography.hazmat.primitives.ciphers.aead import AESGCM
    licenziya = json.load(open(os.path.join(dst_dir, "licenziya.bin"), encoding="utf-8"))
    ent = next(e for e in licenziya["devices"] if e["code"] == kod)
    key = hashlib.pbkdf2_hmac("sha256", master, sohtit_salt(kod), iters, 32)
    dk = AESGCM(key).decrypt(bytes.fromhex(ent["wrap_nonce"]),
                             bytes.fromhex(ent["wrap_ct"]), None)
    aes = AESGCM(dk)
    base = bytes.fromhex(licenziya["blob_nonce_base"])
    buff = io.BytesIO()
    unt_cantok = 0
    with open(os.path.join(dst_dir, "dannie.tar.enc"), "rb") as f:
        while True:
            zag = f.read(4)
            if not zag:
                break
            ct = f.read(struct.unpack("<I", zag)[0])
            buff.write(aes.decrypt(base + struct.pack("<Q", unt_cantok), ct, None))
            unt_cantok += 1
    buff.seek(0)
    unt_failov = sum(1 for m in tarfile.open(fileobj=buff).getmembers() if m.isfile())
    # Строгая проверка терминатора: Python-tarfile прощает отсутствие пустых
    # блоков в хвосте, а парсер приложения - нет. Требую выравнивание и нули.
    b = buff.getvalue()
    if len(b) % 10240 != 0 or b[-1024:] != b"\0" * 1024:
        raise SystemExit("ОШИБКА: tar без пустых блоков-терминаторов или без "
                         "выравнивания 10240 - устройство не увидит конец архива")
    return unt_cantok, unt_failov


if __name__ == "__main__":
    repo_dir = sys.argv[1] if len(sys.argv) > 1 else \
        os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    src_dir = os.environ.get("MENTOR_WORKINGDATA") or \
        os.path.join(repo_dir, "workingdata")
    if not os.path.isdir(src_dir):
        sys.exit(f"ОШИБКА: каталог данных не найден: {src_dir}")
    lic_path = os.environ.get(
        "MENTOR_LICENSE_JSON",
        os.path.expanduser("~/secrets/mentor-licensing/license.json"))
    with open(lic_path, encoding="utf-8") as f:
        lic = json.load(f)
    if lic.get("format") != "mentor-license-v1":
        sys.exit(f"ОШИБКА: неожиданный format лицензии в {lic_path}")
    master = bytes.fromhex(lic["master_secret_hex"])
    if len(master) != 32:
        sys.exit("ОШИБКА: master_secret_hex должен быть 64 символа (32 байта)")
    dst_dir = os.path.join(repo_dir, "android", "assets", "workingdata")
    ver = pol_wersiyu(repo_dir)
    entries, unt_cantok = shifrovat(src_dir, dst_dir, lic, master, ver)
    iters = int(lic.get("kdf_iterations", 100000))
    kod0 = lic["devices"][0]["code"].strip().lower()
    cantok, failov = prowerit(dst_dir, master, kod0, iters)
    unt_ist_failov = sum(len(fs) for _, _, fs in os.walk(src_dir))
    if failov != unt_ist_failov:
        sys.exit(f"ОШИБКА САМОПРОВЕРКИ: в tar {failov} файлов, в источнике "
                 f"{unt_ist_failov}")
    razmer = subprocess.run(["du", "-sh", dst_dir], capture_output=True,
                            text=True).stdout.split()[0]
    print(f"Защищённый бандл готов и самопроверен: устройств {len(entries)}, "
          f"чанков {cantok} (расшифровано), файлов в tar {failov}, размер {razmer}, "
          f"версия {ver}")
