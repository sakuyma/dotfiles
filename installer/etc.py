import shutil
from pathlib import Path
from installer.env import DOTFILES_ETC, Colors


def setup_etc_configs() -> bool:
    src = Path(DOTFILES_ETC)
    dst = Path("/etc")

    if not src.exists():
        print(f"{Colors.RED}Error: {src} not found{Colors.RESET}")
        return False

    try:
        for item in src.rglob("*"):
            if item.is_file():
                dst_file = dst / item.relative_to(src)
                if dst_file.exists():
                    shutil.copy2(
                        dst_file, dst_file.with_suffix(dst_file.suffix + ".bak")
                    )
                dst_file.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(item, dst_file)

        print(f"{Colors.GREEN}/etc configurations applied{Colors.RESET}")
        return True
    except Exception as e:
        print(f"{Colors.RED}Failed: {e}{Colors.RESET}")
        return False
