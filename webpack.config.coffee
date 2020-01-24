webpack = require 'webpack'
path = require 'path'
config = require 'sapper/config/webpack.js'
pkg = require './package.json'

mode = process.env.NODE_ENV
dev = mode is 'development'
alias = svelte: path.resolve 'node_modules', 'svelte'
extensions = ['.mjs', '.js', '.json', '.svelte', '.html']
mainFields = ['svelte', 'module', 'browser', 'main']

module.exports =
	client: {
		entry: config.client.entry()
		output: config.client.output()
		resolve: {alias, extensions, mainFields}
		module:
			rules: [
				test: /\.(svelte|html)$/
				use:
					loader: 'svelte-loader'
					options: {dev, hydratable: yes, hotReload: no}
			]
		mode
		plugins: [
			new (webpack.DefinePlugin)
				'process.browser': yes
				'process.env.NODE_ENV': JSON.stringify mode
		].filter Boolean
		devtool: dev and 'inline-source-map'
	}
	server:
		entry: config.server.entry()
		output: config.server.output()
		target: 'node'
		resolve: {alias, extensions, mainFields}
		externals: (Object.keys pkg.dependencies).concat 'encoding'
		module:
			rules: [
				test: /\.(svelte|html)$/
				use:
					loader: 'svelte-loader'
					options: {css: no, generate: 'ssr', dev}
			]
		mode: process.env.NODE_ENV
		performance: hints: no
	serviceworker:
		entry: config.serviceworker.entry()
		output: config.serviceworker.output()
		mode: process.env.NODE_ENV