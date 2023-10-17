let 
  pubkey = (import ../identities/blusk.nix).pubkey;
in {
  "firefox-syncserver.age".publicKeys = [
    pubkey
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8Skc1428hufDn0heGoSK/8XNwtikU13gdVhFh/XyM7ePB/1ELQxu8uYYG+7GzPs8iSvQ2slNxhwgmqutWxPE/XZ0JmrzjW5aF6X+HOSeI/AiDaUcFr01QxL5wBQ/USiAkrfjie1GxREVViAX7Llis7NV6AnZ8uhasF+NoIZ8HPkPCaDHSwGFyu1012QcSF0ceSgWxY0BF92r9Ly1NYG9+I0es0gPN+ELu+hnNNIXnnw8ZMskvNou9jFfzw/QTfsYnXBY6r/jfJi11nqT2z7dN6Plno8rFHLUT2ljcq/CwIsgLqHNQ3qpDc0HAi8VQvVujIozVEa/+0irw10EsHwRgXTKDh0hpyoY9EYglZ488CmUzDJy4jk1DwpnFyi6LtIYW8VhJ30nbSfMD7q22Gvfcpi5C/RQr4fsvcFllja+M5dq2PMftSFVjXOfWpTc5eS+AnsQNxvbedbtRBmisBCVBorh2t1PpoxVpWNb5FcwfuH+2T4e+hF5rKOdo1YB/uzxRrjv6NFp+TaMWnTldzkbd12TrwKXbjUlmONOgtjiYL3Dum/83k8CjAZCO/ML5dtuxX+9n48sCAb/ot71SL3UKzCQSWz1TlOYNSc3o4sZ6h5ZQqf8uVHI/O0UIzOUQa2VbLYoofviftaort5tieFMzSjB3zA4DKpbeFPv5LMbMCw=="
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9l1P6YK1zIx2pt+dYGyHZX85N+wSwAdvUJf3gNsov7"
  ];
  "felys-xornet.age".publicKeys = [
    pubkey
  ];
  "nozomi-xornet.age".publicKeys = [
    pubkey
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8Skc1428hufDn0heGoSK/8XNwtikU13gdVhFh/XyM7ePB/1ELQxu8uYYG+7GzPs8iSvQ2slNxhwgmqutWxPE/XZ0JmrzjW5aF6X+HOSeI/AiDaUcFr01QxL5wBQ/USiAkrfjie1GxREVViAX7Llis7NV6AnZ8uhasF+NoIZ8HPkPCaDHSwGFyu1012QcSF0ceSgWxY0BF92r9Ly1NYG9+I0es0gPN+ELu+hnNNIXnnw8ZMskvNou9jFfzw/QTfsYnXBY6r/jfJi11nqT2z7dN6Plno8rFHLUT2ljcq/CwIsgLqHNQ3qpDc0HAi8VQvVujIozVEa/+0irw10EsHwRgXTKDh0hpyoY9EYglZ488CmUzDJy4jk1DwpnFyi6LtIYW8VhJ30nbSfMD7q22Gvfcpi5C/RQr4fsvcFllja+M5dq2PMftSFVjXOfWpTc5eS+AnsQNxvbedbtRBmisBCVBorh2t1PpoxVpWNb5FcwfuH+2T4e+hF5rKOdo1YB/uzxRrjv6NFp+TaMWnTldzkbd12TrwKXbjUlmONOgtjiYL3Dum/83k8CjAZCO/ML5dtuxX+9n48sCAb/ot71SL3UKzCQSWz1TlOYNSc3o4sZ6h5ZQqf8uVHI/O0UIzOUQa2VbLYoofviftaort5tieFMzSjB3zA4DKpbeFPv5LMbMCw=="
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9l1P6YK1zIx2pt+dYGyHZX85N+wSwAdvUJf3gNsov7"
  ];
}
