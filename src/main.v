module main

import os
import json
import veb
import veb.assets

struct ViteManifestEntry {
	file             string @[required]
	name             string @[required]
	src              string
	is_entry         bool
	is_dynamic_entry bool
	imports          []string
	css              []string
}

type ViteManifest = map[string]ViteManifestEntry

pub struct Context {
	veb.Context
pub mut:
	am assets.AssetManager
}

pub struct Vite {
}

pub struct App {
	veb.StaticHandler
	mode string
	dist string = 'dist'
mut:
	manifest ViteManifest
}

pub fn (app App) vite(paths []string) string {
	mut render := ''
	for path in paths {
		render += app.render_asset(path)
	}
	return render
}

pub fn (mut app App) load_manifest() {
	if os.is_file('${app.dist}/.vite/manifest.json') {
		app.manifest = json.decode(ViteManifest, os.read_file('${app.dist}/.vite/manifest.json') or {
			panic(err)
		}) or { panic(err) }
	}
}

pub fn (app App) render_asset(path string) string {
	print('Manifest:')
	println(app.manifest[path])
	return path
}

fn main() {
	mut app := &App{
		mode: os.getenv('ENV')
	}

	app.handle_static('dist', true)!

	veb.run[App, Context](mut app, 8080)
}
