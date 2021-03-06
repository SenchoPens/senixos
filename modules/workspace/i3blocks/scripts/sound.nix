{ pamixer, lxqt, iconfont, ... }: ''
  case $BLOCK_BUTTON in
       2) ${pamixer}/bin/pamixer --allow-boost -t;;
       4) ${pamixer}/bin/pamixer --allow-boost -i 5;;
       5) ${pamixer}/bin/pamixer --allow-boost -d 5;;
  esac
  code=0
  if [[ `${pamixer}/bin/pamixer --get-mute` = "true" ]]
  then
    volume=""
    end=""
    icon="婢"
  else
    volume=`${pamixer}/bin/pamixer --get-volume`
    end="%"
    if [[ $volume -lt 33 ]]
    then
      icon="奄"
    else
      if [[ $volume -lt 66 ]]
      then
        icon="奔"
      else
        icon="墳"
      fi
    fi
  fi
  text=" $volume$end"
  echo "<span font='${iconfont}'>$icon</span>$text"
  exit $code
''
