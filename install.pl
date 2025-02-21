#!/usr/bin/env perl
my $HOME = $ENV{HOME};

sub run {
  my $cmd = shift;
  system($cmd) == 0 or die "Failed to run: $cmd";
}

sub println {
  my $msg = shift;
  print $msg."\n";
}

println "Installing dependencies (`apt` + `pip`)...";
run "sudo apt-get install -y zsh bat tree python3-venv i3-wm libnotify-bin dunst perl libjson-perl > /dev/null";
run "pip install -q --user i3-swallow";

if (-d "$HOME/.oh-my-zsh") {
  println "oh-my-zsh already installed.";
} else {
  println "Installing oh-my-zsh...";
  run 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"';
}

if (-d "$HOME/.local/share/zinit") {
  println "zinit already installed.";
} else {
  println "zinit not found, installing...";
  run 'bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"';
}

if (-e "/usr/bin/code") {
  println "VS Code already installed.";
} else {
  println "Installing VS Code...";
  run "curl -o /tmp/code.deb -L https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64";
  run "sudo dpkg -i /tmp/code.deb";
}

if (-e "/usr/local/bin/lit") {
  println "Lit already installed.";
} else {
  `curl -L https://github.com/luvit/lit/raw/master/get-lit.sh | sh`;
  `sudo mv lit luvi luvit /usr/local/bin`;
}

if (-d "$HOME/.nvm") {
  println "nvm already installed.";
} else {
  println "Installing nvm...";
  run "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash";
}

run "sed -i '/zsh_custom_config/d' $HOME/.zshrc";
run "echo 'source $HOME/.meine/zsh_custom_config.zsh' >> $HOME/.zshrc";

println "All done!";
