# Package

version       = "0.1.0"
author        = "Grabli66"
description   = "Библиотека для генерации историй"
license       = "MIT"
srcDir        = "src"
bin           = @["storyteller"]
binDir        = "out"

requires "nim >= 2.2.2"

switch "d", "ssl"
