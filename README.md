# 🐍 Boot Sector Snake Game
This is a simple Snake game implemented as a boot-sector in Assembly language. It runs directly on the hardware without any operating system, making it a fun and educational project for learning low-level programming.

## 🎮 Features
- **Classic Snake game mechanics:** control a snake to eat food and grow longer.
- **Boot-Sector program:** runs directly on x86-based computers without an operating system.
- **Minimalist graphics:** uses text mode to display the game on the screen.
- **Basic input handling:** controls the snake using arrow keys.

## 🚀 Getting Started
### Prerequisites
To build and run the Snake game, you need:
- Assembler - [Flat Assembler](https://flatassembler.net/).
- An x86-based emulator - [QEMU](https://www.qemu.org/).
### Build the Game
1. Clone the repository:
    ```shell
    git clone https://github.com/Or-Fadlon/BootSector-SnakeGame.git
    ```
2. Move to the cloned directory:
    ```shell
    cd BootSector-SnakeGame
    ```
3. Compile the `code.asm` file using assembler:
    ```shell
    <path-to-the-assembler-folder>\fasm.exe code.asm
    ```
### Run the Game 
1. Boot the game on x86-based emulator:
    ```shell
    qemu-system-x86_64 code.bin
    ```
2. Enjoy playing the game!

## 🎥 Gameplay Video
TODO: add video

## 📄 License
This open-source project is available under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html).

## ✉️ Contact
If you have any questions, please feel free to contact me at [or5690@gmail.com](mailto:or5690@gmail.com).
