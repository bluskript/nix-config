{...}: {
  programs.gpg = {
    enable = true;
    settings = {
      "use-agent" = true;
      "no-comments" = true;
      "no-greeting" = true;
      "throw-keyids" = true;
      "charset utf-8" = true;
      "fixed-list-mode" = true;
      "no-emit-version" = true;
      "no-symkey-cache" = true;
      "with-fingerprint" = true;
      "keyid-format 0xlong" = true;
      "s2k-cipher-algo" = "AES256";
      "s2k-digest-algo" = "SHA512";
      "cert-digest-algo" = "SHA512";
      "require-cross-certification" = true;
      "list-options show-uid-validity" = true;
      "verify-options show-uid-validity" = true;
      "personal-cipher-preferences" = "AES256 AES192 AES";
      "personal-digest-preferences" = "SHA512 SHA384 SHA256";
      "personal-compress-preferences" = "ZLIB BZIP2 ZIP Uncompressed";
      "default-preference-list" = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
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
