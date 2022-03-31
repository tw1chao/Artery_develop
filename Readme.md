# ARTERY Development Environment

為 ARTERY（雅特力）所開發的 MCU 製作開發模版 For Visual Studio Code

模版建立參考 [ARTERY AN0033](https://www.arterytek.com/download/AN0033_Eclipse_with_GCC_CH_V1.0.4.pdf)


[Library 提供](https://www.arterytek.com/cn/product/AT32F415.jsp#Resource)

## 更新 Library 方法

以下目錄皆為 AT32F415_Firmware_Library_V2.0.3 目錄底下文件。

複製程式碼：
複製 /Libraries/AT32F4xx_StdPeriph_Driver 至 Project/Libraries<br>
複製 /Libraries/CMSIS/CM4 至 Project/Libraries/CMSIS<br>
複製 /project/AT32_Board 至 Project/Core<br>
複製 /project/st_start_f415/templates/inc src 至 Project/Core<br>

註：AT32F415_Firmware_Library_V2.0.3 為官方下載最新的 Library, 範例 AN0033 為 1.1.5 板，命名方式有些為差異，不過還是有跡可循。


## 開發環境
透過以下方式建立環境及工具鏈，依作業系統不同需自行設定環境變數。<br>
若將環境建立完成即可跨系統 (Windows, Linux, MacOS) 編譯、開發

### 開源編輯器
微軟所提供開源簡易型編輯器 [Visual Studio Code](https://code.visualstudio.com)

### ARM 編譯器
ARM 官方提供 Compiler
[ARM-none-eabi-GCC](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads)

### GNU-Make
在終端機執行 `make -v` 命令，查看 make 版本號，若出現 command not found 則依照以下系統安裝

#### Windows
[Mingw-w64](https://www.mingw-w64.org/downloads/)
在 Sources 底下 Tarballs for the mingw-w64 sources are hosted on [SourceForge](http://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/). jnkek下載一版

#### Linux
`sudo apt-get install build-essential`

#### MacOS
參考以下方法
1. [macOS 缺少套件的管理工具](https://brew.sh/index_zh-tw)
2. [[MacOS] 使用 brew 指令透過終端機下載套件](https://clay-atlas.com/blog/2020/10/19/mac-cn-homebrew-brew-install-package/)

### OpenOCD
燒錄與除錯工具
<!-- [Open On-Chip Debugger](https://openocd.org)
在 Getting OpenOCD 中查看
- Liviu Ionescu maintains multi-platform binaries ([Windows 32/64-bit, Intel GNU/Linux 32/64-bit, Arm GNU/Linux 32/64-bit, and Intel macOS 64-bit](https://github.com/xpack-dev-tools/openocd-xpack/releases)) as part of [The xPack OpenOCD](https://xpack.github.io/openocd/) project. -->

根據 [AN0033](https://www.arterytek.com/download/APNOTE/AN0033_Eclipse_with_GCC_ZH_V2.0.0.pdf) 第 20 頁，在[Artery 技術開發與支持](https://www.arterytek.com/cn/support/index.jsp) AN0033 附檔中的 OpenOCD 即可使用 **Artery 官方編譯完成的 OpenOCD** (註1) ，這邊比較可惜是沒有支援 Linux / OSX 系統除錯(註2)。

* 註1: 若使用官方提供最新版本 0.11.0 之 OpenOCD 則會出現 `Error: Flash dirver "at32f415xx" not found`狀況 
* 註2: 目前仍努力尋找在 Linux / OSX 能夠成功燒錄 ARTERY 之 MCU 的方法。

## 燒錄說明

ATLINK 使用 DAPLink (CMSIS-DAP)的方式燒錄，於此專案只需下 `make install` 命令即可。

