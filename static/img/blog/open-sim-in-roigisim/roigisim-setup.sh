#!/bin/bash
# Give Roigisim and .sim files a nice Roigisim icon, and associate .sim
# files with Roigisim.
#
# Send complaints to Austin Adams (aja@gatech.edu), not Roi
# More fun: https://austinjadams.com/blog/open-sim-in-roigisim/

set -e
set -o pipefail

if [[ -z $1 ]]; then
    printf "error: need to provide the version you want on the command line. "`
          `"If you're piping this script into bash, try ... | bash -s x.y.z\n"
    exit 1
fi

# Create directories used later
# TODO: read XDG environmental variables instead of assuming ~/.local
mkdir -p ~/.local/bin/ ~/.local/share/applications/ \
         ~/.local/share/mime/packages/

# Download that sucker
curl -fo ~/.local/bin/roigisim \
         "https://www.roiatalla.com/public/CircuitSim/Linux/CircuitSim$1"
chmod +x ~/.local/bin/roigisim

# Install Roigisim icons
tmpfile=$(mktemp --suffix=.png)
for size in 16 20 24 48 64 128 256 512; do
    curl -sL https://austinjadams.com/img/blog/open-sim-in-roigisim/roigisim-icon-$size.png -o "$tmpfile"
    xdg-icon-resource install --size $size "$tmpfile" roigisim-icon
done
rm "$tmpfile"

# Register the .circ mimetype
cat >~/.local/share/mime/packages/roigisim.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns='http://www.freedesktop.org/standards/shared-mime-info'>
  <mime-type type="application/roigisim">
    <comment>Roigisim circuit</comment>
    <glob pattern="*.sim"/>
    <icon name="roigisim-icon"/>
  </mime-type>
</mime-info>
EOF

update-mime-database ~/.local/share/mime

# Install the .desktop file for Roigisim
cat >~/.local/share/applications/roigisim.desktop <<EOF
[Desktop Entry]
Version=1.0

Type=Application
Name=Roigisim
Icon=roigisim-icon
GenericName=Logic circuit simulator
Comment=Digital logic circuit simulator
Categories=Development
MimeType=application/roigisim;
Exec=$HOME/.local/bin/roigisim
Terminal=false
StartupWMClass=com.ra4king.circuitsim.gui.CircuitSim
EOF

# Associate the .sim mimetype with Roigisim
xdg-mime default roigisim.desktop application/roigisim

# Remind people to log out and log back in. You might not need to do this, but
# might as well tell people to. I think I had to restart gnome-shell at least.
printf 'Done! Now log out and log back in\n'
