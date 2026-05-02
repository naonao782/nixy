return {
  cmd = { "clangd" },
  filetypes = {
    "c",
    "cpp",
    "objc",
    "objcpp",
    "cuda",
    "proto",
  },
  root_markers = {
    ".clangd",
    ".clang-tidy",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
    ".git",
  },
}
