#! /usr/bin/env sh
source env.sh

mkdir -p _experimental _experimental-dev _versioned _versioned-dev

dockerTemplate="template_Dockerfile"
dockerFileLatest="_experimental/Dockerfile"
dockerFileLatestDev="_experimental-dev/Dockerfile"
dockerFileVersioned="_versioned/Dockerfile"
requirementsFile="_versioned/requirements.txt"
requirementsAuxFile="_versioned/requirements-aux.txt"
dockerFileVersionedDev="_versioned-dev/Dockerfile"
requirementsFileDev="_versioned-dev/requirements.txt"
requirementsDevFileDev="_versioned-dev/requirements-dev.txt"
requirementsAuxFileDev="_versioned-dev/requirements-aux.txt"

function check_file () {
    if [ $1 -eq 1 ]; then
        while true; do
            read -p "$2" yn
            case $yn in
                [Yy]* ) echo 1; exit;;
                [Nn]* ) echo 0; exit;;
                * ) echo "Please answer yes [y] or [n]o.";;
            esac
        done
    else
        echo 1
    fi
}

[ ! -f $dockerFileVersioned ] ; cf_d=$?
cf_m="Dockerfile and requirements already exist, remove? [y/n] "
cf=$(check_file "$cf_d" "$cf_m")

if [ $cf -eq 1 ]; then
    # Create Dockerfile
    docker_args="ARG ALPINE_VERSION=${ALPINE_V}\nARG PYTHON_VERSION=${PYTHON_V}\nARG PYTHON_BASE=${PYTHON_V:0:3}\n\n"
    printf "$docker_args" > $dockerFileVersioned
    cat $dockerTemplate >> $dockerFileVersioned
    printf "$docker_args" > $dockerFileLatest
    cat $dockerTemplate >> $dockerFileLatest
    printf "$docker_args" > $dockerFileVersionedDev
    cat $dockerTemplate >> $dockerFileVersionedDev
    printf "$docker_args" > $dockerFileLatestDev
    cat $dockerTemplate >> $dockerFileLatestDev

    # Create requirements
    if [ -z $SCIKIT_V ]; then
        sk_v="scikit-learn"
    else
        sk_v="scikit-learn==${SCIKIT_V}"
    fi
    requirements_aux="jupyterlab\nmatplotlib\n${sk_v}"
    printf "$requirements_aux" > $requirementsAuxFile
    printf "$requirements_aux" > $requirementsAuxFileDev

    if [ -z $NUMPY_V ]; then
        np_v="numpy"
    else
        np_v="numpy==${NUMPY_V}"
    fi
    if [ -z $SCIPY_V ]; then
        sp_v="scipy"
    else
        sp_v="scipy==${SCIPY_V}"
    fi
    requirements="${np_v}\n${sp_v}"
    printf "$requirements" > $requirementsFile
    printf "$requirements" > $requirementsFileDev

    # Create dev requirements
    if [ -z $CODECOV_V ]; then
        cod_v="codecov"
    else
        cod_v="codecov==${CODECOV_V}"
    fi
    if [ -z $FLAKE8_V ]; then
        fla_v="flake8"
    else
        fla_v="flake8==${FLAKE8_V}"
    fi
    if [ -z $PYLINT_V ]; then
        ply_v="pylint"
    else
        ply_v="pylint==${PYLINT_V}"
    fi
    if [ -z $PYTEST_V ]; then
        pyt_v="pytest"
    else
        pyt_v="pytest==${PYTEST_V}"
    fi
    if [ -z $PYTESTCOV_V ]; then
        pyc_v="pytest-cov"
    else
        pyc_v="pytest-cov==${PYTESTCOV_V}"
    fi
    if [ -z $SPHINX_V ]; then
        sph_v="sphinx"
    else
        sph_v="sphinx==${SPHINX_V}"
    fi
    requirementsDev="${cod_v}\n${fla_v}\n${ply_v}\n${pyt_v}\n${pyc_v}\n${sph_v}"
    printf "$requirementsDev" > $requirementsDevFileDev
fi

# Git commit and tag
git_tag="py-${PYTHON_V:0:3}_ap-${ALPINE_V}___np-${NUMPY_V}_sp-${SCIPY_V}_sk-${SCIKIT_V}"
$(git tag | egrep -q "^${git_tag}$") ; tag_present=$?
if [ $tag_present -eq 0 ]; then
    echo "Git tag: '$git_tag' already exists. Please resolve this before retrying"
    exit 1
fi

echo "The following changes were made:"
sleep 2
git diff

git_m="Do you want to commit these changes? [y/n] "
git_a=$(check_file 1 "$git_m")
if [ $git_a -eq 1 ]; then
  t=$(date +%s)
  git commit -am "Script commit ($t): $git_tag"
fi

git_m1="Do you want to tag this commit? [y/n] "
git_a1=$(check_file 1 "$git_m1")
if [ $git_a1 -eq 1 ]; then
  git tag "$git_tag"
fi

git_m2="Do you want to 'git push'? [y/n] "
git_a2=$(check_file 1 "$git_m2")
if [ $git_a2 -eq 1 ]; then
  git push origin master
  git push origin "$git_tag"
fi
