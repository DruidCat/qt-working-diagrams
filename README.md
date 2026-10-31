# Mentor (Ментор)

Keep all your working documents in one place. Find the wiring diagram or manual you need in seconds,
not after hours of digging through folders!

## Description

Mentor is a desktop GUI application: a document catalog editor with a built-in document viewer.
Its main goal is to build a catalog of the documents you need at work, here and now. All documents live
in a single SQL database, so the whole catalog can be moved to any computer or phone in one step.

Application structure: Menu -> (Title + List) -> Elements -> (Data + Viewer) -> File Manager.

## Why Mentor is useful

- **Order instead of chaos.** Sites, assemblies and documents are neatly shelved: List -> Elements -> Data.
- **Fast search.** Search across the catalog, and full-text search inside PDF documents (Ctrl+F, F3 — next).
- **Works offline.** Everything is stored in a local SQLite database — no internet needed,
  your data is always with you.
- **Two work modes.** ADMINISTRATOR creates and deletes document catalogs; WORKER only views them —
  it is easy to explain to a newcomer what they may and may not do.
- **Clear from the first launch.** Hints in the Toolbar at every step, hotkeys for all standard operations,
  adjustable font size for any screen — from a desktop monitor to a phone.
- **PDF viewer out of the box.** Open, page through, zoom (pinch-to-zoom on tablets), rotate.
- **One database for everything.** Catalog, documents and title data share a single base — backup and transfer
  in a single step.

## Requirements

- Qt 6 (components: Core, Quick, QuickControls2, Sql, Pdf, PdfQuick)
- A C++17-capable compiler
- CMake 3.14+ or Qt Creator (qmake build also supported)
- SQLite (ships with Qt)

## Installation and build

### Ubuntu 22.04+

1. **Install Qt6 and dependencies:**

```bash
sudo apt update
sudo apt install -y build-essential cmake git \
  qt6-base-dev qt6-declarative-dev qml6-module-qtquick qtqml \
  qml6-module-qtquick-controls qml6-module-qtquick-templates \
  qml6-module-qtquick-window qml6-module-qtquick-dialogs \
  qt6-pdf-dev qml6-module-qtquick-pdf libqt6sql6-sqlite
```

2. **Clone the repository:**

```bash
git clone https://github.com/DruidCat/qt-working-diagrams.git
cd qt-working-diagrams
```

3. **Build the project:**

```bash
cmake -S . -B build
cmake --build build -j$(nproc)
```

4. **Run the application:**

```bash
./build/ru.Mentor
```

### Windows 10, 11

1. Install Qt6 from the official site: https://www.qt.io/download (Qt Online Installer).
   When choosing components, tick Qt 6.x, Quick Controls 2, QML, SQL (SQLite driver) and Qt PDF.
2. Open the project in Qt Creator: `CMakeLists.txt` or `ru.Mentor.pro` -> Configure -> Build.
3. Run the built `ru.Mentor.exe` from the build folder.

### AltLinux

The Qt6 package list for building from the AltLinux repository is in [Qt6_AltLinux.txt](Qt6_AltLinux.txt),
Qt5.15 notes are in [Qt5_AltLinux.txt](Qt5_AltLinux.txt).

### Android

The project builds for Android from Qt Creator (the [android](android) folder holds the manifest and
resources).

## Usage

On start, the app opens a document catalog following the scheme Menu -> List -> Elements -> Data -> Viewer.

- **ADMINISTRATOR** creates Lists and Elements, attaches documents via the File Manager, keeps a journal,
  picks the viewer. The mode flag (isAdmin) is set at project compile time.
- **WORKER** only browses catalogs and documents — no create or delete.
- Side panel (bookmarks, instructions) — F1. Search inside an open PDF — Ctrl+F, next match — F3.
- Font size adapts to the screen; every standard operation has a hotkey.

First-run documents are read from the `workingdata` folder next to the executable — the database and
the documents are stored in one folder.

## Project structure

```
qt-working-diagrams/
├── qml/                    # QML source code and interface resources
│   ├── DCButtons/          # Application buttons (the DCButtons library)
│   ├── DCMethods/          # Application widgets and methods
│   ├── DCPages/            # Pages (Menu, List, Elements, Data, File Manager)
│   └── ru.Mentor.qml       # Main qml file — the application window
├── src/                    # C++ source code
│   └── main.cpp            # Application entry point
├── js/                     # JavaScript files (JSON helper functions)
├── icons/                  # App icons for supported screen resolutions
├── fonts/                  # Application fonts
├── images/                 # Interface images
├── workingdata/            # Database and documents
├── android/                # Android manifest and resources
├── CMakeLists.txt          # Project structure for the cmake build system
├── ru.Mentor.pro           # Project structure for the qmake build system
└── qml.qrc                 # Project resource table
```

## How the application is built

- [DCDB](src/dcdb.h) — class working with the SQL database.
- [DCDBData](src/dcdbdata.h) — class working with files stored inside the SQL database.
- [DCCppQml](src/cppqml.h) — the single driver binding the C++ and QML code together.
- [DCPdfPoisk](src/dcpdfpoisk.h) — full-text search across PDF documents.
- [DCLogger](src/dclogger.h) — application error journal.
- [Stranica](qml/DCPages/Stranica.qml) — the main UI template of the program.

## Compatibility

The project is compatible with:

* Windows 7, 8, 10, 11.
* GNU/Linux.
* MacOS.
* Android.
* iOS.

## Tasks and bugs

All tasks, plans and bugs are tracked in [GitHub Issues](https://github.com/DruidCat/qt-working-
diagrams/issues).
Found a bug or want a feature? Open an issue! Code fixes close a task with a `Closes #N` line
in the commit message.

## Terms of use and participation

The project source code is provided under the [GPLv3 license](LICENSE.GPLv3.md), which requires
source code disclosure.

The [Contributor Agreement](CONTRIBUTING.md) governs the rights granted by contributors to the DruidCat
company.

Contributor information is in the [AUTHORS](AUTHORS.md) file.

The [Code of Conduct](CODE_OF_CONDUCT.md) is the current set of DruidCat company rules informing about the
expectations for interaction between community members when communicating and working on projects.

## Screenshots

![Mentor app screenshot](screenshots/ru.Mentor.png)

## Author

DruidCat

## Links

- GitHub: https://github.com/DruidCat/qt-working-diagrams
- Qt6 documentation: https://doc.qt.io/qt-6/
- Qt Creator: https://www.qt.io/download

## Этот документ на русском

- [README.ru.md](README.ru.md)
