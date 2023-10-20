# For more information on themes, see
# https://www.nushell.sh/book/coloring_and_theming.html
let dark_theme = {
		# color for nushell primitives
		separator: white
		leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
		header: green_bold
		empty: blue
		# Closures can be used to choose colors for specific values.
		# The value (in this case, a bool) is piped into the closure.
		bool: { if $in { 'light_cyan' } else { 'light_gray' } }
		int: white
		filesize: {|e|
			if $e == 0b {
				'white'
			} else if $e < 1mb {
				'cyan'
			} else { 'blue' }
		}
		duration: white
		date: { (date now) - $in |
			if $in < 1hr {
				'#e61919'
			} else if $in < 6hr {
				'#e68019'
			} else if $in < 1day {
				'#e5e619'
			} else if $in < 3day {
				'#80e619'
			} else if $in < 1wk {
				'#19e619'
			} else if $in < 6wk {
				'#19e5e6'
			} else if $in < 52wk {
				'#197fe6'
			} else { 'light_gray' }
		}
		range: white
		float: white
		string: white
		nothing: white
		binary: white
		cellpath: white
		row_index: green_bold
		record: white
		list: white
		block: white
		hints: dark_gray

		shape_and: purple_bold
		shape_binary: purple_bold
		shape_block: blue_bold
		shape_bool: light_cyan
		shape_custom: green
		shape_datetime: cyan_bold
		shape_directory: cyan
		shape_external: cyan
		shape_externalarg: green_bold
		shape_filepath: cyan
		shape_flag: blue_bold
		shape_float: purple_bold
		# shapes are used to change the cli syntax highlighting
		shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b}
		shape_globpattern: cyan_bold
		shape_int: purple_bold
		shape_internalcall: cyan_bold
		shape_list: cyan_bold
		shape_literal: blue
		shape_matching_brackets: { attr: u }
		shape_nothing: light_cyan
		shape_operator: yellow
		shape_or: purple_bold
		shape_pipe: purple_bold
		shape_range: yellow_bold
		shape_record: cyan_bold
		shape_redirection: purple_bold
		shape_signature: green_bold
		shape_string: green
		shape_string_interpolation: cyan_bold
		shape_table: blue_bold
		shape_variable: purple
}



export def gpt [...query: string] = {
	sgpt --model=gpt-4 --cache --chat=default ($query | str join " ")
}

export def howdoi [...query: string] = {
	sgpt --model=gpt-4 --cache --shell ($query | str join " ")
}

$env.config = {
	color_config: $dark_theme
	show_banner: false
	shell_integration: false
	edit_mode: vi
	table: {
		mode: rounded
	},
	keybindings: [
		{
			name: zoxide_folder_sel
			modifier: CONTROL
			keycode: Char_f
			mode: [emacs, vi_normal, vi_insert]
			event: [
				{ edit: InsertString value: "zi" }
				{ send: Enter }
			]
		}
	],
	hooks: {
		pre_execution: [
			{ print $"(ansi title)(pwd)> (history | last | get command)(ansi st)" }
		]
	}
}
