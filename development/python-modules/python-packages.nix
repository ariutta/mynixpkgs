{ callPackage, buildPythonPackage }:

let
  jupyter_packaging = callPackage ./jupyter_packaging/default.nix {};
  simpervisor = callPackage ./simpervisor/default.nix {};
  json5 = callPackage ./json5/default.nix {};
  jupyter_server = callPackage ./jupyter_server/default.nix {};
  jupyterlab_server = callPackage ./jupyterlab_server/default.nix {
    inherit json5 jupyter_server;
  };
  nbclassic = callPackage ./nbclassic/default.nix {
    inherit jupyter_packaging jupyter_server;
  };
  jupyterlab = callPackage ./jupyterlab/default.nix {
    inherit nbclassic jupyter_packaging jupyter_server jupyterlab_server;
  };
  jupyter_lsp = callPackage ./jupyter_lsp/default.nix {
    inherit jupyter_server;
  };
  jupyter-resource-usage = callPackage ./jupyter-resource-usage/default.nix {
    inherit jupyterlab;
  };
  jupyterlab-topbar = callPackage ./jupyterlab-topbar/default.nix {
    inherit jupyterlab;
  };
in
{
  inherit jupyter_packaging simpervisor json5 jupyter_server jupyterlab_server nbclassic jupyterlab jupyter_lsp jupyter-resource-usage jupyterlab-topbar;
  arviz = callPackage ./arviz/default.nix {};
  daff = (callPackage ./daff/requirements.nix {}).packages.daff;
  flask-mwoauth = callPackage ./flask-mwoauth/default.nix {};

  jupyter-server-proxy = callPackage ./jupyter-server-proxy/default.nix { inherit simpervisor; };
  jupyterlab-lsp = callPackage ./jupyterlab_lsp/default.nix {
    inherit jupyterlab jupyter_lsp;
  };
  jupyterlab_code_formatter = callPackage ./jupyterlab_code_formatter/default.nix {
    inherit jupyterlab;
  };
  jupyterlab_hide_code = callPackage ./jupyterlab_hide_code/default.nix {
    inherit jupyterlab;
  };
  jupyterlab_vim = callPackage ./jupyterlab_vim/default.nix {
    inherit jupyterlab jupyter_packaging;
  };
  jupyterlab-vimrc = callPackage ./jupyterlab-vimrc/default.nix {
    inherit jupyterlab;
  };
  aquirdturtle_collapsible_headings = callPackage ./aquirdturtle_collapsible_headings/default.nix {
    inherit jupyterlab;
  };
  jupyterlab-system-monitor = callPackage ./jupyterlab-system-monitor/default.nix {
    inherit jupyterlab jupyter-resource-usage jupyterlab-topbar;
  };
  jupyterlab-drawio = callPackage ./jupyterlab-drawio/default.nix {
    inherit jupyterlab;
  };
  nb_black = callPackage ./nb_black/default.nix {};
  seaborn = callPackage ./seaborn/default.nix {};
  skosmos_client = callPackage ./skosmos_client/default.nix {};
  wikidata2df = callPackage ./wikidata2df/default.nix {};
  homoglyphs = callPackage ./homoglyphs/default.nix {};
  confusable-homoglyphs = callPackage ./confusable-homoglyphs/default.nix {};
  pyahocorasick = callPackage ./pyahocorasick/default.nix {};
}
