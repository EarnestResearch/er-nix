{ earnestresearch, runCommand, dockerArchive, dockerName, dockerTag }:

runCommand "run-upload-to-aws" {}
  ''
    ${earnestresearch.upload_docker_to_aws}/bin/upload_docker_to_aws -n ${dockerName} -t ${dockerTag} ${dockerArchive} > $out
  ''
