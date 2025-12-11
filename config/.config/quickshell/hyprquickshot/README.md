# HyprQuickshot

A simple, (hopefully) beautiful screenshot utility for Hyprland with smooth animations, built with [Quickshell](https://quickshell.org). PRs and contributions are appreciated.

## Demo

https://github.com/user-attachments/assets/7e3d5e3c-551a-4458-8dda-06cc3907dd92

## Dependencies

- [quickshell](https://git.outfoxxed.me/quickshell/quickshell)
- [grim](https://sr.ht/~emersion/grim/)
- [imagemagick](https://github.com/ImageMagick/ImageMagick)
- [wl-clipboard](https://github.com/bugaevc/wl-clipboard)

## Installation

### Nix

If using flakes, add this repo to your flake inputs:

```nix
{
  inputs = {
    hyprquickshot = {
      url = "github:jamdon2/hyprquickshot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```

The package is available as `hyprquickshot.packages.<system>.default`, which can be added to your `environment.systemPackages` or `home.packages` if you use home-manager.

### Arch

Install dependencies with pacman:

```bash
pacman -S grim imagemagick wl-clipboard
```

And get Quickshell with yay (or your AUR helper of choice)

```bash
yay -S quickshell
```

Now just clone this repo into Quickshell's config folder

```bash
git clone https://github.com/jamdon2/hyprquickshot ~/.config/quickshell/hyprquickshot
```

## Usage

Now you're ready to launch HyprQuickshot from your terminal, or add it to your Hyprland config.

```bash
quickshell -c hyprquickshot -n
```

> If you've installed package using nix flake, you should use `hyprquickshot` command instead.

You can remove the `-n` if you want to allow multiple instances of HyprQuickshot to be open (like wanting to screenshot HyprQuickshot for whatever reason).

Add this line to your `hyprland.conf` to bind HyprQuickshot to the Print Screen button on your keyboard.

```hypr
bind = , Print, exec, quickshell -c hyprquickshot -n
```

Or this to bind it to Meta + Shift + A

```hypr
bind = $mainMod+SHIFT, A, exec, quickshell -c hyprquickshot -n
```

## Configuration

You can choose a custom screenshot folder by setting the `HQS_DIR` environment variable.

If `HQS_DIR` is not set, HyprQuickshot will try to find a suitable directory in the following order:

1. `$XDG_SCREENSHOTS_DIR`

1. `$XDG_PICTURES_DIR`

1. `$HOME/Pictures`

## Known issues

- If you have high resolution monitors, grim might take a few seconds to save the screenshot, and if you select any option before that, your screenshot won't be saved. This will be fixed in the next release.

## TODO

- [x] Speed up grim by supplying the geometry of the selected monitor
- [ ] Add more animations and improve UI/UX
- [ ] Optimize shader (remove branching and add AA)
- [ ] Eliminate some dependencies
- [ ] Rewrite in Rust :)
