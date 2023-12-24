#!/bin/bash

COLOR_INFO='\033[0;36m'
COLOR_SUCCESS='\033[0;32m'
COLOR_QUESTION='\033[0;33m'
COLOR_ERROR='\033[0;31m'
COLOR_NC='\033[0m' # No Color

is_installed() {
  if which "$1" >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

# Kiểm tra package được cài đặt từ gói nào
# return "apt" | "snap" | "other"
check_package_origin() {
  app_name=$1
  installed_via_apt=$(dpkg -l | awk '$2 == "'"$app_name"'" {print $1}')
  installed_via_snap=$(snap list | grep -E "^$app_name\b")

  if [ -n "$installed_via_apt" ]; then
    echo "apt"
  elif [ -n "$installed_via_snap" ]; then
    echo "snap"
  else
    echo "other"
  fi
}

check_installed_app() {
  app_name=$1
  if is_installed "$app_name"; then
    check_package_origin "$app_name"
  else
    echo "notfound"
  fi
}

install_git() {
  local check_installed_git=$(check_installed_app "git")
  if [ "$check_installed_git" = "notfound" ]; then
    echo "${COLOR_INFO}[🚀 ~ INFO ~ Git] Git is not installed. Installing Git...${COLOR_NC}"
    sudo apt update
    sudo apt install git
    check_installed_git=$(check_installed_app "git")
    
    if [ "$check_installed_git" = "notfound" ]; then
      echo "${COLOR_ERROR}[🚀 ~ ERROR ~ Git] Failed to install Git. Exiting script.${COLOR_NC}"
      exit 1
    else
      echo "${COLOR_SUCCESS}[🚀 ~ SUCCESS ~ Git] Git has been installed successfully.${COLOR_NC}"
    fi
  else
    echo "${COLOR_INFO}[🚀 ~ INFO ~ Git] Git is already installed.${COLOR_NC}"
  fi
}

install_curl() {
  local check_installed_curl=$(check_installed_app "curl")
  if [ "$check_installed_curl" = "notfound" ]; then
    echo "${COLOR_INFO}[🚀 ~ INFO ~ curl] curl is not installed. Installing curl...${COLOR_NC}"
    sudo apt update
    sudo apt install curl
    check_installed_curl=$(check_installed_app "curl")

    if [ "$check_installed_curl" = "notfound" ]; then
      echo "${COLOR_ERROR}[🚀 ~ ERROR ~ curl] Failed to install curl. Exiting script.${COLOR_NC}"
      exit 1
    else
      echo "${COLOR_SUCCESS}[🚀 ~ SUCCESS ~ curl] curl has been installed successfully.${COLOR_NC}"
    fi
  else
    echo "${COLOR_INFO}[🚀 ~ INFO ~ curl] curl is already installed via ${check_installed_curl}.${COLOR_NC}"
  fi
}

install_zsh() {
  local check_installed_zsh=$(check_installed_app "zsh")
  if [ "$check_installed_zsh" = "notfound" ]; then
    echo "${COLOR_INFO}[🚀 ~ INFO ~ Zsh] Zsh is not installed. Installing Zsh...${COLOR_NC}"
    sudo apt update
    sudo apt install zsh -y

    check_installed_zsh=$(check_installed_app "zsh")
    if [ "$check_installed_zsh" = "notfound" ]; then
      echo "${COLOR_ERROR}[🚀 ~ ERROR ~ Zsh] Failed to install Zsh. Exiting script.${COLOR_NC}"
      exit 1
    else
      echo "${COLOR_SUCCESS}[🚀 ~ SUCCESS ~ Zsh] Zsh has been installed successfully.${COLOR_NC}"
    fi
  else
    echo "${COLOR_INFO}[🚀 ~ INFO ~ Zsh] Zsh is already installed.${COLOR_NC}"
  fi
}

install_powerlevel10k() {
  if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "${COLOR_INFO}[🚀 ~ INFO ~ Zsh themes] Installing powerlevel10k...${COLOR_NC}"
    git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

    if [ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
      echo "${COLOR_SUCCESS}[🚀 ~ SUCCESS ~ Zsh themes] Powerlevel10k installed successfully.${COLOR_NC}"
    else
      echo "${COLOR_ERROR}[🚀 ~ ERROR ~ Zsh themes] Failed to install powerlevel10k.${COLOR_NC}"
    fi
  else
    echo "${COLOR_INFO}[🚀 ~ INFO ~ Zsh themes] powerlevel10k is already installed.${COLOR_NC}"
  fi
}

install_zsh_autosuggestions() {
  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "${COLOR_INFO}[🚀 ~ INFO ~ Zsh plugins] Installing zsh-autosuggestions...${COLOR_NC}"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
      echo "${COLOR_SUCCESS}[🚀 ~ SUCCESS ~ Zsh plugins] zsh-autosuggestions installed successfully.${COLOR_NC}"
    else
      echo "${COLOR_ERROR}[🚀 ~ ERROR ~ Zsh plugins] Failed to install zsh-autosuggestions.${COLOR_NC}"
    fi
  else
    echo "${COLOR_INFO}[🚀 ~ INFO ~ Zsh plugins] zsh-autosuggestions is already installed.${COLOR_NC}"
  fi
}

install_zsh_syntax_highlighting() {
  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "${COLOR_INFO}[🚀 ~ INFO ~ Zsh plugins] Installing zsh-syntax-highlighting...${COLOR_NC}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
      echo "${COLOR_SUCCESS}[🚀 ~ SUCCESS ~ Zsh plugins] zsh-syntax-highlighting installed successfully.${COLOR_NC}"
    else
      echo "${COLOR_ERROR}[🚀 ~ ERROR ~ Zsh plugins] Failed to install zsh-syntax-highlighting.${COLOR_NC}"
    fi
  fi
}

install_ohmyzsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "${COLOR_INFO}[🚀 ~ INFO ~ Oh My Zsh] Oh My Zsh is not installed. Installing Oh My Zsh...${COLOR_NC}"

    # Set the RUNZSH environment variable to skip the Zsh default shell prompt
    RUNZSH="no" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # echo -e "\n" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    if [ -d "$HOME/.oh-my-zsh" ]; then
      echo "${COLOR_SUCCESS}[🚀 ~ SUCCESS ~ Oh My Zsh] Oh My Zsh installed successfully.${COLOR_NC}"
    else
      echo "${COLOR_ERROR}[🚀 ~ ERROR ~ Oh My Zsh] Failed to install Oh My Zsh. Exiting script.${COLOR_NC}"
      exit 1
    fi
  else
    echo "${COLOR_INFO}[🚀 ~ INFO ~ Oh My Zsh] Oh My Zsh is already installed.${COLOR_NC}"
  fi

  ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
  ZSHRC_FILE="$HOME/.zshrc"

  install_powerlevel10k
  install_zsh_autosuggestions
  install_zsh_syntax_highlighting
}

install_custom_fonts() {
  local font_system_dir="/usr/share/fonts/truetype/custom_fonts"
  local fonts_dir="$(pwd)/custom_fonts"
  local is_new_install_run_fc_cache=false

  if [ ! -d "$font_system_dir" ]; then
    echo "${COLOR_INFO}[🚀 ~ INFO ~ Font] Creating font directory in the system...${COLOR_NC}"
    sudo mkdir -p "$font_system_dir"
  fi

  echo "${COLOR_INFO}[🚀 ~ INFO ~ Font] Installing font files...${COLOR_NC}"
  for font_file in "$fonts_dir"/*.ttf; do
    if [ -f "$font_file" ]; then
      if fc-list | grep -q "$(basename "$font_file")"; then
        echo "${COLOR_INFO}[🚀 ~ INFO ~ Font] Font $(basename "$font_file") is already installed.${COLOR_NC}"
      else
        echo "${COLOR_INFO}[🚀 ~ INFO ~ Font] Font $(basename "$font_file") is not installed. Proceeding with the installation...${COLOR_NC}"
        is_new_install_run_fc_cache=true
        sudo cp "$font_file" "$font_system_dir"
      fi
    fi
  done

  if [ "$is_new_install_run_fc_cache" = true ]; then
    echo "${COLOR_INFO}[🚀 ~ INFO ~ Font] Updating the font cache...${COLOR_NC}"
    sudo fc-cache -f -v
  else
    echo "${COLOR_INFO}[🚀 ~ INFO ~ Font] No changes in the font list.${COLOR_NC}"
  fi

  echo "${COLOR_SUCCESS}[🚀 ~ SUCCESS ~ Font] Font installation completed!${COLOR_NC}"
}

new_preference_dracula_theme() {
  local new_profile=$(uuidgen)
  local scheme_dir="$(pwd)/Dracula"
  local bg_color_file=$scheme_dir/bg_color
  local fg_color_file=$scheme_dir/fg_color
  local bd_color_file=$scheme_dir/bd_color
  local palette_file=$scheme_dir/palette

  dconf write /org/gnome/terminal/legacy/profiles:/:$new_profile/palette "'$(<$palette_file)'"
  dconf write /org/gnome/terminal/legacy/profiles:/:$new_profile/bold-color "'$(cat $bd_color_file)'"
  dconf write /org/gnome/terminal/legacy/profiles:/:$new_profile/background-color "'$(cat $bg_color_file)'"
  dconf write /org/gnome/terminal/legacy/profiles:/:$new_profile/foreground-color "'$(cat $fg_color_file)'"

  dconf write /org/gnome/terminal/legacy/profiles:/:$new_profile/default-size-columns 126
  dconf write /org/gnome/terminal/legacy/profiles:/:$new_profile/default-size-rows 36

  dconf write /org/gnome/terminal/legacy/profiles:/:$new_profile/font "'UbuntuMono Nerd Font Mono 16'"
  dconf write /org/gnome/terminal/legacy/profiles:/:$new_profile/use-system-font false

  dconf write /org/gnome/terminal/legacy/profiles:/:$new_profile/use-theme-colors false
  dconf write /org/gnome/terminal/legacy/profiles:/:$new_profile/bold-color-same-as-fg false

  dconf write /org/gnome/terminal/legacy/profiles:/:$new_profile/visible-name "'Dracula'"

  dconf write /org/gnome/terminal/legacy/profiles:/default "'$new_profile'"

  list_profiles=$(dconf read /org/gnome/terminal/legacy/profiles:/list)
  list_profiles="${list_profiles%\]}"
  if [ -z "$list_profiles" ]; then
    list_profiles="['$new_profile']"
  else
    list_profiles="$list_profiles, '$new_profile']"
  fi
  dconf write /org/gnome/terminal/legacy/profiles:/list "$list_profiles"

  echo "${COLOR_SUCCESS}[🚀 ~ SUCCESS ~ Preference] Preference named Dracula has been created and installed!${COLOR_NC}"
}

ask_set_zsh_default() {
  case "$SHELL" in
  *zsh)
    echo "${COLOR_INFO}[🚀 ~ INFO ~ Zsh] Zsh has been set as your default shell.${COLOR_NC}"
    ;;
  *)
    if ask_yes_no "[🚀 ~ INFO ~ Zsh] Do you want to set Zsh as your default shell?" "yes"; then
      chsh -s $(which zsh)
      case "$SHELL" in
      *zsh)
        echo "${COLOR_SUCCESS}[🚀 ~ SUCCESS ~ Zsh] Zsh has been set as your default shell.${COLOR_NC}"
        ;;
      *)
        echo "${COLOR_INFO}[🚀 ~ INFO ~ Zsh] Unable to set Zsh as the default shell. Please run the following command in your terminal:${COLOR_NC}"
        echo "chsh -s \$(which zsh)"
        ;;
      esac
    else
      echo "${COLOR_INFO}[🚀 ~ INFO ~ Zsh] No action taken. Your default shell remains unchanged.${COLOR_NC}"
    fi
    ;;
  esac
}

ask_yes_no() {
  local question="$1"
  local default_answer="$2"

  if ! echo "$question" | grep -q '\[.*~.*~.*\]'; then
    question="[🚀 ~ QUESTION ~ Ask] $question"
  fi

  default_answer=$(echo "$default_answer" | tr '[:upper:]' '[:lower:]')

  if [ "$default_answer" = "yes" ]; then
    read -rp "$(echo "${COLOR_QUESTION}${question} (YES/no): ${COLOR_NC}")" choice
  elif [ "$default_answer" = "no" ]; then
    read -rp "$(echo "${COLOR_QUESTION}${question} (yes/NO): ${COLOR_NC}")" choice
  else
    read -rp "$(echo "${COLOR_QUESTION}${question} (yes/no): ${COLOR_NC}")" choice
  fi

  case "$choice" in
  [yY] | [yY][eE][sS])
    true
    ;;
  [nN] | [nN][oO])
    false
    ;;
  "")
    if [ "$default_answer" = "yes" ]; then
      true
    elif [ "$default_answer" = "no" ]; then
      false
    else
      echo "${COLOR_ERROR}[🚀 ~ ERORR ~ Ask] Empty choice not allowed. Exiting.${COLOR_NC}"
      exit 1
    fi
    ;;
  *)
    echo "${COLOR_ERROR}[🚀 ~ ERORR ~ Ask] Invalid choice '$choice'. Exiting.${COLOR_NC}"
    exit 1
    ;;
  esac
}

backup() {
  local current_date=$(date +%s)
  local backup_dir=dotfiles_$current_date

  mkdir ~/$backup_dir

  mv ~/.zshrc ~/$backup_dir/.zshrc
  mv ~/.p10k.zsh ~/$backup_dir/.p10k.zsh

  echo "${COLOR_SUCCESS}[🚀 ~ SUCCESS ~ Backup] Backing up dotfiles: directory $backup_dir!${COLOR_NC}"
}

link_dotfiles() {
  cp $(pwd)/zshrc ~/.zshrc
  cp $(pwd)/p10k.zsh ~/.p10k.zsh

  echo "${COLOR_SUCCESS}[🚀 ~ SUCCESS ~ DotFiles] Linking dotfiles!${COLOR_NC}"
}

install_all() {
  install_git
  install_curl
  install_zsh
  ask_set_zsh_default
  install_ohmyzsh
  install_custom_fonts
#   new_preference_dracula_theme
  backup
  link_dotfiles
}

show_help() {
  echo "Usage: install.sh [-h] [-a] [-f] [-b] [-d]"
  echo
  echo "Options"
  echo "  -h, --help"
  echo "    Show this information"
  echo "  -a, --all"
  echo "    Customize terminal with ohmyzsh and Dracula theme."
  echo "  -f, --fonts"
  echo "    Installing fonts in the directory $(pwd)/custom_fonts."
  echo "  -b, --backup"
  echo "    Backup current configuration dotfiles to directory dotfiles_*."
  echo "  -d, --dotfiles"
  echo "    Install custom configuration dotfiles."
}

while [ $# -gt 0 ]; do
  case $1 in
  -h | --help)
    show_help
    exit 0
    ;;
  -a | --all)
    install_all
    exit 0
    ;;
  -b | --backup)
    backup
    exit 0
    ;;
  -f | --fonts)
    install_custom_fonts
    exit 0
    ;;
  -d | --dotfiles)
    link_dotfiles
    exit 0
    ;;
  *)
    echo "${COLOR_ERROR}[🚀 ~ ERORR ~ Ask] Invalid choice '$1'. Exiting.${COLOR_NC}"
    exit 1
    ;;
  esac
done
