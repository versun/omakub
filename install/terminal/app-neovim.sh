# Detect architecture
ARCH=$(uname -m)
NVIM_URL=""
if [ "$ARCH" = "x86_64" ]; then
    NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
elif [ "$ARCH" = "aarch64" ]; then
    NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

cd /tmp
wget -O nvim.tar.gz "$NVIM_URL"
tar -xf nvim.tar.gz
# Adjust directory name based on architecture
NVIM_DIR=$([ "$ARCH" = "x86_64" ] && echo "nvim-linux64" || echo "nvim-linux-arm64")
sudo install $NVIM_DIR/bin/nvim /usr/local/bin/nvim
sudo cp -R $NVIM_DIR/lib /usr/local/
sudo cp -R $NVIM_DIR/share /usr/local/
rm -rf $NVIM_DIR nvim.tar.gz
cd -

# Only attempt to set configuration if Neovim has never been run
if [ ! -d "$HOME/.config/nvim" ]; then
	# Use LazyVim
	git clone https://github.com/LazyVim/starter ~/.config/nvim
	# Remove the .git folder, so you can add it to your own repo later
	rm -rf ~/.config/nvim/.git

	# Make everything match the terminal transparency
	mkdir -p ~/.config/nvim/plugin/after
	cp ~/.local/share/omakub/configs/neovim/transparency.lua ~/.config/nvim/plugin/after/

	# Default to Tokyo Night theme
	cp ~/.local/share/omakub/themes/tokyo-night/neovim.lua ~/.config/nvim/lua/plugins/theme.lua

	# Enable default extras
	cp ~/.local/share/omakub/configs/neovim/lazyvim.json ~/.config/nvim/lazyvim.json
fi

# Replace desktop launcher with one running inside Alacritty
if [[ -d ~/.local/share/applications ]]; then
	sudo rm -rf /usr/share/applications/nvim.desktop
	source ~/.local/share/omakub/applications/Neovim.sh
fi
