{...}: {
	stalwart-mail = {
		enable = true;
		settings = {
			server.hostname = "mail.blusk.dev";
			server.run-as = {
				user = "stalwart";
				group = "stalwart";
			};
		};
	};
}
