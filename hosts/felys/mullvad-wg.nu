#!/usr/bin/env nu

# Select a random host based on a country or city filter
def select_host [--country: closure, --city: closure] {
	let country = if $country == null { {|x| $x.code == "us"} } else { $country }
	let city = if $city == null { {|x| true} } else { $city }
	let relays = open /etc/wireguard/relays.json | get countries
	let available_relays = $relays | filter $country | get cities | filter $city | each {|x| $x | get relays | flatten} | flatten
	let selection = $available_relays | get (random int 0..($available_relays | length))
	$selection
}

def get_addr [account: string, pubkey: string] {
	let body = $"account=($account)&pubkey=($pubkey | url encode)"
	# curl -sSL https://api.mullvad.net/wg -d $body
	http post -H [Content-Type application/x-www-form-urlencoded] -e "https://api.mullvad.net/wg" $body
}

def ifup [secrets: any, entry_host: any, exit_host: any, --ns: string, --if: string = "wg0"] {
	$secrets.addr | split row ',' | each {|addr| 
		if ($addr | str contains '.') {
			echo $"Adding ipv4 address ($addr)"
			# Very lazy and sloppy IPv4 address detection
			if $ns != null {
				ip -n $ns -4 address add $addr dev $if
			} else {
				ip -4 address add $addr dev $if
			}
		} else {
			echo $"Adding ipv6 address ($addr)"
			if $ns != null {
				ip -n $ns -6 address add $addr dev $if
			} else {
				ip -6 address add $addr dev $if
			}
		}
	}
	let conf_file = mktemp -t wg_XXXXX.conf
	$"
		[Interface]
		PrivateKey=($secrets.privkey)
		[Peer]
		PublicKey=(if $exit_host == null { $entry_host.public_key } else { $exit_host.public_key })
		AllowedIPs=0.0.0.0/0,::/0
		Endpoint=($entry_host.ipv4_addr_in):(if $exit_host == null { 51820 } else { $exit_host.multihop_port })
	" | save -f $conf_file
	echo "setting wireguard configuration"
	if $ns != null {
		ip netns exec $ns wg setconf $if $conf_file
	} else {
		wg setconf $if $conf_file
	}
	echo "setting link up"
	if $ns != null {
		ip -n $ns link set wg0 up
	} else {
		ip link set wg0 up
	}
	# rm -f $conf_file
}

def "main up" [entry_country?: closure, entry_city?: closure, exit_country?: closure, exit_city?: closure, --secrets_path: path = /etc/wireguard/secrets.json, --ns = "mullvad"] {
	let selected = select_host --country $entry_country --city $entry_city
	let exit_selected = select_host --country $exit_country --city $exit_country
	echo $"Connecting to ($exit_selected.hostname) via ($selected.hostname)..."
	let secrets = open $secrets_path

	echo "- adding link"
	ip link add wg0 type wireguard
	if $ns != null {
		echo "- creating namespace"
		ip netns add $ns 
		echo "- moving link into namespace"
		ip link set wg0 netns $ns 
	}
	echo "- setting up link"

	ifup $secrets $selected $exit_selected --ns $ns 

	echo "- setting default route"
	if $ns != null {
		ip -n $ns route add default dev wg0
	} else {
		ip route add default dev wg0
	}

	echo "- setting as default"
}

def "main down" [--secrets_path: path = /etc/wireguard/secrets.json, --country: closure, --city: closure, --ns: string = "mullvad"] {
	echo "deleting link"
	if $ns == null {
		ip link delete wg0
	} else {
		ip -n $ns link delete wg0
		echo "deleting namespace"
		ip netns delete $ns 
	}
}

def "main update-relays" [--relay_path = /etc/wireguard/relays.json] {
	http get https://api.mullvad.net/public/relays/wireguard/v1/ | save -f $relay_path
	echo "✅ Relays updated"
}

def "main update-secrets" [--secrets_path: path = /etc/wireguard/secrets.json] {
	mut data = try {
		open $secrets_path
	} catch { {} }
	if ($data | get -i account_id) == null {
		let account_id = (input "Enter your Mullvad Account ID: ")
		$data.account_id = $account_id
		echo "updated account id"
	}
	if ($data | get -i privkey) == null {
		$data.privkey = (wg genkey)
		echo "generated new private key"
	}
	let old_pubkey = $data | get -i pubkey
	$data.pubkey = ($data.privkey | wg pubkey)
	if old_pubkey != $data.pubkey {
		echo "updated public key"
	}
	let old_addr = $data | get -i addr
	$data.addr = (get_addr $data.account_id $data.pubkey)
	if old_addr != $data.addr {
		echo "updated address"
	}
	$data | to json | save -f $secrets_path
	echo "✅ Secrets updated"
}

def "main" [] {
	echo `Available subcommands:
  - up
  - down
  - update-relays
  - update-secrets`
}
