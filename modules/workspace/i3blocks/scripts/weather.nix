{ bash, config, curl, iconfont, ... }: ''
  #!${bash}/bin/bash
  echo $(curl wttr.in/?format=1)
''
