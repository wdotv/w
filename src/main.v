module main

import veb

pub struct Context {
	veb.Context
}

pub struct App {
	veb.StaticHandler
}

fn main() {
	mut app := &App{}

	app.handle_static('dist', true)!

	veb.run[App, Context](mut app, 8080)
}
