reload() {
    curdir=$(pwd)
    source ~/.zshrc
    cd $curdir
    echo 'zshrc successfully reloaded!'
}

pse() {
    pse-command $@ | less
}

mkcd() {
    mkdir -p "$@" && eval cd "\"\$$#\""
}

hs() {
    hoogle search --count=10000 $1 | less
}

download_ftp() {
    wget -m --user=$1 --password=$2 $3
}

dd_to_sdb() {
    sudo dd if=$1 of=/dev/sdb
}

winformat() {
    sudo mkfs -t vfat $1
}

mksession() {
    session_name="$HOME/sessions/$1.sh"
    touch $session_name
    tail --lines=500 ~/.zsh_history | cut --delimiter=';' --fields=2 > $session_name
    $EDITOR $session_name
}

test-py() {
    cat "$2.in" | python3 "$1.py"
}

test-cpp() {
    g++ --std=c++17 "$1.cpp" && cat "$2.in" | a.out
}

stress-test() {
    gen_stress="$2_gen_stress"
    stress_in="$2_stress"
    test_prog="$3"
    test_stress="$2_test_stress"
    g++ "$3.cpp"
    for i in {1..$1};
    do
        python3 "$gen_stress.py" > "$stress_in.in"

        test-py $test_stress $stress_in > /tmp/A
        cat "$stress_in.in" | a.out > /tmp/B


        difference=$(diff /tmp/A /tmp/B)

        if [[ $difference != "" ]]; then
            echo $difference
            echo "Test file:"
            cat "$stress_in.in"
            break
        fi
    done;
}

export-from-file() {
    source $1
    export $(cut -d= -f1 $1)
}

diff-strings() {
    diff <(echo $1 ) <(echo $2)
}

sync-gdrive() {
    rclone sync -P local-kp:/home/sencho/Shared GDrive:/ 
}

push-shared() {
    rclone copy local-kp:/home/sencho/Shared GDrive:/ 
}

pull-shared() {
    rclone copy GDrive:/ local-kp:/home/sencho/Shared 
}

ga-and-commit() {
    git add $2 && git commit -S --signoff -m "$1 $2"
}

ds() {
    echo $(pwd) > /tmp/saved-dir
}

dr() {
    cd $(cat /tmp/saved-dir)
}
