let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    python3
    python3Packages.pip
    python3Packages.virtualenv
  ];

  shellHook = ''
    if [ ! -d ".venv" ]; then
      echo "Creating virtual environment in .venv..."
      python3 -m venv .venv
      echo "Installing requirements..."
      .venv/bin/pip install --upgrade pip
      if [ -f requirements.txt ]; then
        .venv/bin/pip install -r requirements.txt
      else
        echo "No requirements.txt found. Skipping dependency installation."
      fi
    fi

    # Activate the virtual environment
    echo "Activating virtual environment..."
    source .venv/bin/activate
  '';
}