{ bash, networkmanager, iconfont, config, ... }: ''
  #!${bash}/bin/bash
  SIGNAL=$(nmcli dev wifi list | awk '/\*/{if (NR!=1) {print $8}}')

  icons=" "

  index=$(($SIGNAL / 10))

  icon=''${icons:$index:1}
  full_text="$icon"

  if [[ $BLOCK_BUTTON -eq 1 ]] 
    then
      swaymsg "exec alacritty -e nmtui"
  fi

  echo "$full_text"
  echo "$full_text"
  exit 0
''
