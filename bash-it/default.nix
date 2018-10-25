{
fetchFromGitHub,
gawk,
stdenv }:

with builtins;

let
  baseName = "bash-it";
  version = "4a64dcb";
in
stdenv.mkDerivation rec {
  name = (concatStringsSep "-" [baseName version]);

  # nativeBuildInputs shouldn't persist as run-time dependencies.
  #   From the manual:
  #   "Since these packages are able to be run at build time, that are added to
  #    the PATH, as described above. But since these packages only are
  #    guaranteed to be able to run then, they shouldn't persist as run-time
  #    dependencies. This isn't currently enforced, but could be in the future."
  nativeBuildInputs = [ gawk ];

  # buildInputs may be used at run-time but are only on the PATH at build-time.
  #   From the manual:
  #   "These often are programs/libraries used by the new derivation at
  #    run-time, but that isn't always the case."
  buildInputs = [ ];

  awkAlias = "${gawk}/bin/awk";

  src = fetchFromGitHub {
    owner = "Bash-it";
    repo = "bash-it";
    rev = "4a64dcbc6f15b9b2cd3883a96f81bc94a5a0fe24";
    sha256 = "1zzi4iwznqsdy7kzkqh9clhvqlzh3bym1cfr1fhg701bnnnx8z0x";
  };

#  #doCheck = true;
#
#  checkPhase = ''
#  '';

  awkPattern = "[`(|[:space:]]awk[[:space:]]";

  installPhase = ''
    targetDir="$out/share/bash_it"
    mkdir -p $targetDir

    for content in aliases bash_it.sh completion custom install.sh lib plugins template themes uninstall.sh
    do
      cp -r "$content" "$targetDir/$content"
    done

    for f in $(grep -rIl '${awkPattern}' "$targetDir"); do
      substituteInPlace $f \
            --replace "awk" "${awkAlias}"
    done

    "./install.sh" --no-modify-config

    echo ""
    echo "****************************************"
    echo "* Add the following to your ~/.profile *"
    echo "****************************************"
    echo ""
echo "export BASH_IT=\"\$HOME/.nix-profile/share/bash_it\""
echo 'if [ -n "$BASH_VERSION" ] && [ -d "$BASH_IT" ]; then'
echo '	# Assume Bash'
echo ""
echo '	export PATH=$PATH:$BASH_IT'
echo ""
echo '	# http://powerline.readthedocs.io/en/master/usage/shell-prompts.html#bash-prompt'
echo '	powerline-daemon -q'
echo '	export POWERLINE_BASH_CONTINUATION=1'
echo '	export POWERLINE_BASH_SELECT=1'
echo '	. "$(nix-env -q --out-path --no-name 'python3.6-powerline-2.6')/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh"'
echo ""
echo '	# Lock and Load a custom theme file'
echo '	# location $HOME/.bash_it/themes/'
echo '	export BASH_IT_THEME="powerline"'
echo ""
echo '	# (Advanced): Uncomment this to make Bash-it reload itself automatically'
echo '	# after enabling or disabling aliases, plugins, and completions.'
echo '	export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1'
echo ""
echo '	# Load Bash It'
echo '	if [ -e "$BASH_IT/bash_it.sh" ]; then . "$BASH_IT/bash_it.sh"; fi'
echo 'fi'
    echo ""
  '';

  meta = with stdenv.lib;
    { description = "A community Bash framework";
      longDescription = ''
	Bash-it is a collection of community Bash commands and scripts for Bash 3.2+. (And a shameless ripoff of oh-my-zsh 😃)

	Includes autocompletion, themes, aliases, custom functions, a few stolen pieces from Steve Losh, and more.
      '';
      homepage = https://github.com/Bash-it/bash-it;
      #license = licenses.asl20;
      maintainers = with maintainers; [ ariutta ];
      platforms = platforms.all;
    };
}
