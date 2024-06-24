{
  pkgs,
  firefox-devedition,
}:
pkgs.runCommand "patched-firefox" {} ''
  mkdir -p $out
  cp -RL ${firefox-devedition}/* $out/
  chmod -R u+w $out/

  mkdir -p $out/tmp/firefox-omni
  cd $out/tmp/firefox-omni
  echo $(${pkgs.unzip}/bin/unzip $out/lib/firefox/browser/omni.ja)

  patch chrome/browser/content/browser/browser.xhtml < ${./browser.xhtml.patch}

  ${pkgs.zip}/bin/zip -0DXqr $out/tmp/omni.ja *
  cp -f $out/tmp/omni.ja $out/lib/firefox/browser/omni.ja
  rm -rf $out/tmp
''
