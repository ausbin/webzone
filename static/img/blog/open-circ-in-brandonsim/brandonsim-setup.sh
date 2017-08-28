#!/bin/bash
# Give Brandonsim and .circ files a nice Brandonsim icon, and associate .circ
# files with Brandonsim.
#
# Send complaints to Austin Adams (aja@gatech.edu), not Brandon
# More fun: https://austinjadams.com/blog/open-circ-in-brandonsim/

set -e
set -o pipefail

# If first argument is provided, use it as the path to the Brandonsim jar,
# otherwise prompt for it
if [[ -n $1 ]]; then
    brandonsim_jar_path=$1
else
    read -r -p "Enter absolute path to Brandonsim-X.Y.Z.jar: " brandonsim_jar_path </dev/tty
fi

# .desktop files require an absolute path
brandonsim_jar_path=$(readlink -f "${brandonsim_jar_path/#~/$HOME}") && \
[[ -f $brandonsim_jar_path ]] || {
    printf 'error: the file `%s` does not exist. Please try again.\n' "$brandonsim_jar_path" >&2
    exit 1
}

# Create directories used later
mkdir -p ~/.local/share/applications/ ~/.local/share/mime/packages/

# Install Brandonsim icons
tmpfile=$(mktemp --suffix=.png)
for size in 16 20 24 48 64 128; do
    curl -sL https://austinjadams.com/img/blog/open-circ-in-brandonsim/brandonsim-icon-$size.png -o "$tmpfile"
    xdg-icon-resource install --size $size "$tmpfile" brandonsim-icon
done
rm "$tmpfile"

# Register the .circ mimetype
cat >~/.local/share/mime/packages/brandonsim.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns='http://www.freedesktop.org/standards/shared-mime-info'>
  <mime-type type="application/brandonsim">
    <comment>Brandonsim circuit</comment>
    <glob pattern="*.circ"/>
    <icon name="brandonsim-icon"/>
  </mime-type>
</mime-info>
EOF

update-mime-database ~/.local/share/mime

# Install the .desktop file for Brandonsim
cat >~/.local/share/applications/brandonsim.desktop <<EOF
[Desktop Entry]
Version=1.0

Type=Application
Name=Brandonsim
Icon=brandonsim-icon
GenericName=Logic circuit simulator
Comment=Digital logic circuit simulator
Categories=Development
MimeType=application/brandonsim;
Exec=java -jar $brandonsim_jar_path %U
Terminal=false
StartupWMClass=com-cburch-logisim-Main
EOF

# Associate the .circ mimetype with Brandonsim
xdg-mime default brandonsim.desktop application/brandonsim

# Remind people to log out and log back in. You might not need to do this, but
# might as well tell people to. I think I had to restart gnome-shell at least.
printf 'Done! Now log out and log back in\n'
