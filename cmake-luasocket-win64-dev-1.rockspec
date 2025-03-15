package = "cmake-luasocket-win64"
version = "dev-1"
source = {
   url = "git+ssh://git@github.com/qlua-project/cmake-luasocket-win64.git",
   tag = "v3.scm.20250301-5.4.1",
}
supported_platforms = {
    "win32",
}
dependencies = {
   "lua ~> 5.4",
}
build = {
   type = "builtin",
   platforms = {
      windows = {
         install = {
            lib = {
               ["mime.core"]      = "bin/mime/core.dll",
               ["socket.core"]    = "bin/socket/core.dll",
            }
         },
         modules = {
               ["socket.http"]    = "bin/socket/http.lua",
               ["socket.url"]     = "bin/socket/url.lua",
               ["socket.tp"]      = "bin/socket/tp.lua",
               ["socket.ftp"]     = "bin/socket/ftp.lua",
               ["socket.headers"] = "bin/socket/headers.lua",
               ["socket.smtp"]    = "bin/socket/smtp.lua",
               ltn12              = "bin/ltn12.lua",
               socket             = "bin/socket.lua",
               mbox               = "bin/mbox.lua",
               mime               = "bin/mime.lua",
         },
      },
   },
}
