{...}: {
  programs.gpg = {
    enable = true;
    settings = {
      "personal-cipher-preferences" = "AES256 AES192 AES";
      "personal-digest-preferences" = "SHA512 SHA384 SHA256";
      "personal-compress-preferences" = "ZLIB BZIP2 ZIP Uncompressed";
      "default-preference-list" = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      "cert-digest-algo" = "SHA512";
      "s2k-digest-algo" = "SHA512";
      "s2k-cipher-algo" = "AES256";
      "charset utf-8" = true;
      "fixed-list-mode" = true;
      "no-comments" = true;
      "no-emit-version" = true;
      "no-greeting" = true;
      "keyid-format 0xlong" = true;
      "list-options show-uid-validity" = true;
      "verify-options show-uid-validity" = true;
      "with-fingerprint" = true;
      "require-cross-certification" = true;
      "no-symkey-cache" = true;
      "use-agent" = true;
      "throw-keyids" = true;
    };
    mutableTrust = false;
    mutableKeys = false;
    publicKeys = [
      {
        source = ../../identities/blusk.asc;
        trust = 5;
      }
    ];
  };
}
