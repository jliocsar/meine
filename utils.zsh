echo_title() {
  echo "🐗 $1"
}

echo_success() {
  echo_title "[✅] $1"
}

echo_info() {
  echo_title "[⏺️] $1"
}

grep_zshrc() {
  cat "$HOME/.zshrc" | grep -q $1
}

command_exists() {
  command -v $1 &> /dev/null
}

import() {
  . "$HOME/.meine/$1"
}
