import subprocess
from typing import List
from env import DISABLED_SERVICES, ENABLED_SERVICES


def _enable_services() -> bool:
    for service in ENABLED_SERVICES:
        result = subprocess.run(
            ["systemctl", "enable", "--now", service],
            capture_output=True,
            text=True,
        )

        if result.returncode != 0:
            print(f"Failed to enable {service}: {result.stderr}")
            return False

    return True


def _disable_services() -> bool:
    for service in DISABLED_SERVICES:
        result = subprocess.run(
            ["systemctl", "disable", service],
            capture_output=True,
            text=True,
        )

        if result.returncode != 0:
            print(f"Failed to disable {service}: {result.stderr}")
            return False

    return True

def configure_services() -> bool:
    print("Configuring services")
    
    if not _disable_services():
        return False

    if not _enable_services():
        return False

    return True
