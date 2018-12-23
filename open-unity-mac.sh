#!/bin/bash
#
# open unity via cli on mac

# consts
readonly unity_hub_installs_dir="/Applications/Unity/Hub/Editor"
readonly project_version_relpath="ProjectSettings/ProjectVersion.txt"

# parse cmd args
while getopts ":v:t:n" opt; do
    case $opt in

        # -v unity-version
        v)
            unity_app_name=$OPTARG >&2
            ;;

        # -t unity-build-target
        t)
            build_target=$OPTARG >&2
            unity_args+=" -buildTarget $build_target"
            ;;

        # -n always opens a new instance of the app
        n)
            open_args+=" -n"
            ;;

        # invalid args
        \?)
            echo "invalid option: -$OPTARG." >&2
            exit 1
            ;;
        :)
            ;;
    esac
done

# project dir is last arg
shift "$((OPTIND-1))"
if [ "$#" -gt 0 ]; then
    project_dir=$PWD/$1
fi

# unity app name not provided
if [ -z "$unity_app_name" ]; then

    # try parsing version string from project settings
    if [ -f "$project_dir/$project_version_relpath" ]; then
        line=$(head -n 1 "$project_dir/$project_version_relpath")
        version=${line:17}
        unity_app_name="$unity_hub_installs_dir/$version/Unity.app"

    # open app named Unity
    else
        unity_app_name="Unity"
    fi
fi

# build command string and eval run it
cmd="open -a $unity_app_name $open_args --args -projectPath $project_dir $unity_args"
eval $cmd
