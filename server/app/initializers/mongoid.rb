require 'mongoid'

Mongoid.load! File.join( Application.root, "configuration/mongoid.yml" ), Application.env
