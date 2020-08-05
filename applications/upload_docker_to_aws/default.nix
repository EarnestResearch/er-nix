{ awscli, coreutils, gawk, skopeo, writeShellScriptBin }:

writeShellScriptBin "upload_docker_to_aws"
  ''
    set -o errexit
    set -o errtrace
    set -o pipefail

    # Enable debugging in CI environment
    # Note that this'll leak sensitive tokens to logs and should not be left enabled
    if [ -n "$DEBUG" ] ; then
       set -o xtrace
    fi

    export AWS_CONTAINER_CREDENTIALS_RELATIVE_URI="${builtins.getEnv "AWS_CONTAINER_CREDENTIALS_RELATIVE_URI"}"
    export AWS_DEFAULT_REGION="${builtins.getEnv "AWS_DEFAULT_REGION"}"
    export AWS_REGION="${builtins.getEnv "AWS_REGION"}"

    PARAMS=""
    while (( "$#" )); do
      case "$1" in
        -n | --name)
          NAME=$2
          shift 2
          ;;
        -t | --tag)
          TAG=$2
          shift 2
          ;;
        -h | --help)
          echo "Usage: upload_docker_to_aws -n [docker_name] -t [docker_tag] [path to docker archive]"
          exit 0
          ;;
        --) # end argument parsing
          shift
          break
          ;;
        -* | --*=) # unsupported flags
          echo "Error: Unsupported flag $1" >&2
          exit 1
          ;;
        *) # preserve positional arguments
          PARAMS="$PARAMS $1"
          shift
          ;;
      esac
    done

    # set positional arguments in their proper place
    eval set -- "$PARAMS"

    if [ -z "$1" ]; then
      echo "No Docker archive supplied" >&2
      exit 1
    fi

    if [ -z "$NAME" ]; then
      echo "No Docker image name specified" >&2
      exit 1
    fi

    if [ -z "$TAG" ]; then
      echo "No Docker image tag specified" >&2
      exit 1
    fi

    AUTH=''$(${awscli}/bin/aws ecr get-authorization-token --output text --query 'authorizationData[]')

    TOKEN=$( ${coreutils}/bin/echo $AUTH | ${gawk}/bin/awk '{ print $1 }' | ${coreutils}/bin/base64 -d | ${coreutils}/bin/cut -d: -f2 )
    DOCKER_HOST=$( ${coreutils}/bin/echo $AUTH | ${gawk}/bin/awk '{ print $3 }' | cut -d/ -f3 )
    DOCKER_URL="$DOCKER_HOST/$NAME:$TAG"

    ${skopeo}/bin/skopeo copy "--dest-creds=AWS:$TOKEN" "docker-archive:$1" "docker://$DOCKER_URL" >&2

    ${coreutils}/bin/echo "$DOCKER_URL"
  ''
