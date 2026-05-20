import subprocess
from env import ALL_PACKAGES

def install_packages() -> bool:
    result = subprocess.run(
        ["paru", "-S", "--noconfirm", "--needed", *ALL_PACKAGES],
        capture_output=True,
        text=True,
    )
    if result.returncode == 0:
        return True
    else:
        return False
