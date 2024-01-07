# This file has been generated by node2nix 1.11.1. Do not edit!

{nodeEnv, fetchurl, fetchgit, nix-gitignore, stdenv, lib, globalBuildInputs ? []}:

let
  sources = {
    "@antfu/utils-0.7.7" = {
      name = "_at_antfu_slash_utils";
      packageName = "@antfu/utils";
      version = "0.7.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/@antfu/utils/-/utils-0.7.7.tgz";
        sha512 = "gFPqTG7otEJ8uP6wrhDv6mqwGWYZKNvAcCq6u9hOj0c+IKCEsY4L1oC9trPq2SaWIzAfHvqfBDxF591JkMf+kg==";
      };
    };
    "@unocss/autocomplete-0.56.5" = {
      name = "_at_unocss_slash_autocomplete";
      packageName = "@unocss/autocomplete";
      version = "0.56.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/@unocss/autocomplete/-/autocomplete-0.56.5.tgz";
        sha512 = "2vPkVZUDtd8xgdN9faHtp1f4HPx5/YS6l/RpqeLIE4jNlwxmNXqpIAQsLblDoOdq72PqMWYrrvjTg7STyADAJQ==";
      };
    };
    "@unocss/config-0.56.5" = {
      name = "_at_unocss_slash_config";
      packageName = "@unocss/config";
      version = "0.56.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/@unocss/config/-/config-0.56.5.tgz";
        sha512 = "rscnFIYgUlN/0hXHdhANyjFcDjDutt3JO0ZRITdNLzoglh7GVNiDTURBJwUZejF/vGJ7IkMd3qOdNhPFuRY1Bg==";
      };
    };
    "@unocss/core-0.56.5" = {
      name = "_at_unocss_slash_core";
      packageName = "@unocss/core";
      version = "0.56.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/@unocss/core/-/core-0.56.5.tgz";
        sha512 = "fx5VhOjSHn0HdV2D34pEwFMAHJcJQRTCp1xEE4GzxY1irXzaa+m2aYf5PZjmDxehiOC16IH7TO9FOWANXk1E0w==";
      };
    };
    "@unocss/extractor-arbitrary-variants-0.56.5" = {
      name = "_at_unocss_slash_extractor-arbitrary-variants";
      packageName = "@unocss/extractor-arbitrary-variants";
      version = "0.56.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/@unocss/extractor-arbitrary-variants/-/extractor-arbitrary-variants-0.56.5.tgz";
        sha512 = "p2pyzz/ONvc5CGcaB9OZvWE8qkRSgyuhaQqFQLdBFeUhveHC0CGP0iSnXwBgAFHWM7DJo4/JpWeZ+mBt0ogVLA==";
      };
    };
    "@unocss/preset-mini-0.56.5" = {
      name = "_at_unocss_slash_preset-mini";
      packageName = "@unocss/preset-mini";
      version = "0.56.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/@unocss/preset-mini/-/preset-mini-0.56.5.tgz";
        sha512 = "/KhlThhs1ilauM7MwRSpahLbIPZ5VGeGvaUsU8+ZlNT3sis4yoVYkPtR14tL2IT6jhOU05N/uu3aBj+1bP8GjQ==";
      };
    };
    "@unocss/preset-uno-0.56.5" = {
      name = "_at_unocss_slash_preset-uno";
      packageName = "@unocss/preset-uno";
      version = "0.56.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/@unocss/preset-uno/-/preset-uno-0.56.5.tgz";
        sha512 = "3hzE0X1oxMbHLvWyTj/4BrJQ7OAL428BpzEJos0RsxifM04vOJX4GC4khIbmTl8KIMECMtATK3ren3JqzD2bFw==";
      };
    };
    "@unocss/preset-wind-0.56.5" = {
      name = "_at_unocss_slash_preset-wind";
      packageName = "@unocss/preset-wind";
      version = "0.56.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/@unocss/preset-wind/-/preset-wind-0.56.5.tgz";
        sha512 = "iyMPvCEZkrGLHFXXlcqxDo/UcSK7KWw4x7/QUz7irrvc78cxYVuPm98QZgpCRcCwKerKVyFLjGOtwQ0kmVSVsQ==";
      };
    };
    "@unocss/rule-utils-0.56.5" = {
      name = "_at_unocss_slash_rule-utils";
      packageName = "@unocss/rule-utils";
      version = "0.56.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/@unocss/rule-utils/-/rule-utils-0.56.5.tgz";
        sha512 = "CXIGHCIC9B8WUl9KbbFMSZHcsIgfmI/+X0bjBv6xrgBVC1EQ2Acq4PYnJIbaRGBRAhl9wYjNL7Zq2UWOdowHAw==";
      };
    };
    "acorn-8.11.3" = {
      name = "acorn";
      packageName = "acorn";
      version = "8.11.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/acorn/-/acorn-8.11.3.tgz";
        sha512 = "Y9rRfJG5jcKOE0CLisYbojUjIrIEE7AGMzA/Sm4BslANhbS+cDMpgBdcPT91oJ7OuJ9hYJBx59RjbhxVnrF8Xg==";
      };
    };
    "defu-6.1.3" = {
      name = "defu";
      packageName = "defu";
      version = "6.1.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/defu/-/defu-6.1.3.tgz";
        sha512 = "Vy2wmG3NTkmHNg/kzpuvHhkqeIx3ODWqasgCRbKtbXEN0G+HpEEv9BtJLp7ZG1CZloFaC41Ah3ZFbq7aqCqMeQ==";
      };
    };
    "fzf-0.5.2" = {
      name = "fzf";
      packageName = "fzf";
      version = "0.5.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/fzf/-/fzf-0.5.2.tgz";
        sha512 = "Tt4kuxLXFKHy8KT40zwsUPUkg1CrsgY25FxA2U/j/0WgEDCk3ddc/zLTCCcbSHX9FcKtLuVaDGtGE/STWC+j3Q==";
      };
    };
    "jiti-1.21.0" = {
      name = "jiti";
      packageName = "jiti";
      version = "1.21.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/jiti/-/jiti-1.21.0.tgz";
        sha512 = "gFqAIbuKyyso/3G2qhiO2OM6shY6EPP/R0+mkDbyspxKazh8BXDC5FiFsUjlczgdNz/vfra0da2y+aHrusLG/Q==";
      };
    };
    "jsonc-parser-3.2.0" = {
      name = "jsonc-parser";
      packageName = "jsonc-parser";
      version = "3.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/jsonc-parser/-/jsonc-parser-3.2.0.tgz";
        sha512 = "gfFQZrcTc8CnKXp6Y4/CBT3fTc0OVuDofpre4aEeEpSBPV5X5v4+Vmx+8snU7RLPrNHPKSgLxGo9YuQzz20o+w==";
      };
    };
    "lru-cache-10.1.0" = {
      name = "lru-cache";
      packageName = "lru-cache";
      version = "10.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/lru-cache/-/lru-cache-10.1.0.tgz";
        sha512 = "/1clY/ui8CzjKFyjdvwPWJUYKiFVXG2I2cY0ssG7h4+hwk+XOIX7ZSG9Q7TW8TW3Kp3BUSqgFWBLgL4PJ+Blag==";
      };
    };
    "mlly-1.4.2" = {
      name = "mlly";
      packageName = "mlly";
      version = "1.4.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/mlly/-/mlly-1.4.2.tgz";
        sha512 = "i/Ykufi2t1EZ6NaPLdfnZk2AX8cs0d+mTzVKuPfqPKPatxLApaBoxJQ9x1/uckXtrS/U5oisPMDkNs0yQTaBRg==";
      };
    };
    "pathe-1.1.1" = {
      name = "pathe";
      packageName = "pathe";
      version = "1.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/pathe/-/pathe-1.1.1.tgz";
        sha512 = "d+RQGp0MAYTIaDBIMmOfMwz3E+LOZnxx1HZd5R18mmCZY0QBlK0LDZfPc8FW8Ed2DlvsuE6PRjroDY+wg4+j/Q==";
      };
    };
    "pkg-types-1.0.3" = {
      name = "pkg-types";
      packageName = "pkg-types";
      version = "1.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/pkg-types/-/pkg-types-1.0.3.tgz";
        sha512 = "nN7pYi0AQqJnoLPC9eHFQ8AcyaixBUOwvqc5TDnIKCMEE6I0y8P7OKA7fPexsXGCGxQDl/cmrLAp26LhcwxZ4A==";
      };
    };
    "ufo-1.3.2" = {
      name = "ufo";
      packageName = "ufo";
      version = "1.3.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/ufo/-/ufo-1.3.2.tgz";
        sha512 = "o+ORpgGwaYQXgqGDwd+hkS4PuZ3QnmqMMxRuajK/a38L6fTpcE5GPIfrf+L/KemFzfUpeUQc1rRS1iDBozvnFA==";
      };
    };
    "unconfig-0.3.11" = {
      name = "unconfig";
      packageName = "unconfig";
      version = "0.3.11";
      src = fetchurl {
        url = "https://registry.npmjs.org/unconfig/-/unconfig-0.3.11.tgz";
        sha512 = "bV/nqePAKv71v3HdVUn6UefbsDKQWRX+bJIkiSm0+twIds6WiD2bJLWWT3i214+J/B4edufZpG2w7Y63Vbwxow==";
      };
    };
    "vscode-jsonrpc-8.2.0" = {
      name = "vscode-jsonrpc";
      packageName = "vscode-jsonrpc";
      version = "8.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-jsonrpc/-/vscode-jsonrpc-8.2.0.tgz";
        sha512 = "C+r0eKJUIfiDIfwJhria30+TYWPtuHJXHtI7J0YlOmKAo7ogxP20T0zxB7HZQIFhIyvoBPwWskjxrvAtfjyZfA==";
      };
    };
    "vscode-languageserver-9.0.1" = {
      name = "vscode-languageserver";
      packageName = "vscode-languageserver";
      version = "9.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver/-/vscode-languageserver-9.0.1.tgz";
        sha512 = "woByF3PDpkHFUreUa7Hos7+pUWdeWMXRd26+ZX2A8cFx6v/JPTtd4/uN0/jB6XQHYaOlHbio03NTHCqrgG5n7g==";
      };
    };
    "vscode-languageserver-protocol-3.17.5" = {
      name = "vscode-languageserver-protocol";
      packageName = "vscode-languageserver-protocol";
      version = "3.17.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-protocol/-/vscode-languageserver-protocol-3.17.5.tgz";
        sha512 = "mb1bvRJN8SVznADSGWM9u/b07H7Ecg0I3OgXDuLdn307rl/J3A9YD6/eYOssqhecL27hK1IPZAsaqh00i/Jljg==";
      };
    };
    "vscode-languageserver-textdocument-1.0.11" = {
      name = "vscode-languageserver-textdocument";
      packageName = "vscode-languageserver-textdocument";
      version = "1.0.11";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-textdocument/-/vscode-languageserver-textdocument-1.0.11.tgz";
        sha512 = "X+8T3GoiwTVlJbicx/sIAF+yuJAqz8VvwJyoMVhwEMoEKE/fkDmrqUgDMyBECcM2A2frVZIUj5HI/ErRXCfOeA==";
      };
    };
    "vscode-languageserver-types-3.17.5" = {
      name = "vscode-languageserver-types";
      packageName = "vscode-languageserver-types";
      version = "3.17.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-types/-/vscode-languageserver-types-3.17.5.tgz";
        sha512 = "Ld1VelNuX9pdF39h2Hgaeb5hEZM2Z3jUrrMgWQAu82jMtZp7p3vJT3BzToKtZI7NgQssZje5o0zryOrhQvzQAg==";
      };
    };
  };
in
{
  "unocss-language-server-git+https://git@github.com/Jason-Jay-Mason/unocss-language-server#main" = nodeEnv.buildNodePackage {
    name = "unocss-language-server";
    packageName = "unocss-language-server";
    version = "0.0.10";
    src = fetchgit {
      url = "https://git@github.com/Jason-Jay-Mason/unocss-language-server";
      rev = "9293c24d538fa52dbe9ebe73166824b830e124e6";
      sha256 = "e93640174cccaea7d9df5a92b6fbc2e74e0ad8a6074fefc9dd8dca063eeb895c";
    };
    dependencies = [
      sources."@antfu/utils-0.7.7"
      sources."@unocss/autocomplete-0.56.5"
      sources."@unocss/config-0.56.5"
      sources."@unocss/core-0.56.5"
      sources."@unocss/extractor-arbitrary-variants-0.56.5"
      sources."@unocss/preset-mini-0.56.5"
      sources."@unocss/preset-uno-0.56.5"
      sources."@unocss/preset-wind-0.56.5"
      sources."@unocss/rule-utils-0.56.5"
      sources."acorn-8.11.3"
      sources."defu-6.1.3"
      sources."fzf-0.5.2"
      sources."jiti-1.21.0"
      sources."jsonc-parser-3.2.0"
      sources."lru-cache-10.1.0"
      sources."mlly-1.4.2"
      sources."pathe-1.1.1"
      sources."pkg-types-1.0.3"
      sources."ufo-1.3.2"
      sources."unconfig-0.3.11"
      sources."vscode-jsonrpc-8.2.0"
      sources."vscode-languageserver-9.0.1"
      sources."vscode-languageserver-protocol-3.17.5"
      sources."vscode-languageserver-textdocument-1.0.11"
      sources."vscode-languageserver-types-3.17.5"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "unocss language server";
      license = "MIT";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
}
