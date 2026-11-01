# Mentor (Ментор)

Desktop application: a catalog editor for working documents with a built-in viewer.
UI: QML, application code: C++, data storage: SQLite.

Application structure: Menu -> (Title + List) -> Elements -> (Data + Viewer) -> File Manager.

## Features

- Single storage: the catalog, documents and title data live in one SQL database (SQLite).
  Backup and transfer of the catalog is done by copying a single folder.
- Works offline, no internet connection required.
- Catalog search; full-text search inside PDF documents (Ctrl+F, F3 — next match).
- PDF viewer: open, paging, zooming (including pinch-to-zoom on tablets), rotation.
- Two work modes: ADMINISTRATOR (create and delete) and WORKER (view only).
  The mode flag (isAdmin) is set at project compile time.
- Hints in the Toolbar, hotkeys for standard operations, adjustable font size.

## Installation and build

### Ubuntu 22.04+

Requirements:
- Qt 6, components: Core, Quick, QuickControls2, Sql (SQLite driver), Pdf, PdfQuick;
- a C++17-capable compiler, CMake 3.14+, git.

1. Install Qt 6 and dependencies:

```bash
sudo apt update
sudo apt install -y build-essential cmake git \
  qt6-base-dev qt6-declarative-dev qml6-module-qtquick qtqml \
  qml6-module-qtquick-controls qml6-module-qtquick-templates \
  qml6-module-qtquick-window qml6-module-qtquick-dialogs \
  qt6-pdf-dev qml6-module-qtquick-pdf libqt6sql6-sqlite
```

2. Clone the repository:

```bash
git clone https://github.com/DruidCat/qt-working-diagrams.git
cd qt-working-diagrams
```

3. Build the project (qmake build is also supported, file `ru.Mentor.pro`):

```bash
cmake -S . -B build
cmake --build build -j$(nproc)
```

4. Run the application:

```bash
./build/ru.Mentor
```

### Windows 10, 11

Requirements:
- Qt 6 from the Qt Online Installer (https://www.qt.io/download).
  Components: Qt 6.x — Core, Quick, Quick Controls 2, SQL (SQLite driver), Qt PDF.
  A C++17 compiler (MSVC or MinGW from the Qt installer).
- CMake 3.14+ or Qt Creator (shipped with Qt).

Build:
1. Open the project in Qt Creator: `CMakeLists.txt` or `ru.Mentor.pro` -> Configure -> Build.
2. Run `ru.Mentor.exe` from the build folder.

### AltLinux

Requirements: Qt 6 packages from the AltLinux repository, the list is in
[Qt6_AltLinux.txt](Qt6_AltLinux.txt). Qt 5.15 notes are in [Qt5_AltLinux.txt](Qt5_AltLinux.txt).

Build: the same CMake commands as in the Ubuntu section.

### Android

Build from Qt Creator using the Android kit.
The manifest and resources are in the [android](android) folder.

## Usage

On start, the application opens the document catalog following the scheme
Menu -> List -> Elements -> Data -> Viewer.

- ADMINISTRATOR: creates Lists and Elements, attaches documents via the File Manager,
  keeps a journal, picks the viewer.
- WORKER: browses catalogs and documents only, no create or delete.
- F1 — side panel (bookmarks, instructions). Ctrl+F — search inside an open PDF, F3 — next match.
- Font size adapts to the screen; hotkeys are defined for standard operations.

On first run the application reads documents from the `workingdata` folder next to the
executable; the database and the documents are stored in one folder.

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

All tasks, plans and bugs are tracked in
[GitHub Issues](https://github.com/DruidCat/qt-working-diagrams/issues).
Code fixes close a task with a `Closes #N` line in the commit message.

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
