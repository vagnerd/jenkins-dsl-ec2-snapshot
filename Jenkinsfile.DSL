folder("AWS/EC2-SNAPSHOT/${ENV_NAME}/${JOB_NAME}") {
  displayName("${JOB_NAME}")
  description("${JOB_NAME}")
}

pipelineJob("AWS/EC2-SNAPSHOT/${ENV_NAME}/${JOB_NAME}/EC2-CREATE-SNAPSHOT") {

  environmentVariables {
    env('VOLUME_ID', "${VOLUME_ID}")
    env('ENV', "${ENV_NAME}")
  }

  triggers {
    cron("${CRON_VALUE}")
  }
  
  logRotator {
    numToKeep(5)
  }

  definition {
    cpsScm {
      scm {
        git('https://github.com/vagnerd/jenkins-dsl-ec2-snapshot.git')
        scriptPath('pipelines/Jenkinsfile.create')
      }
    }
  }

}

pipelineJob("AWS/EC2-SNAPSHOT/${ENV_NAME}/${JOB_NAME}/EC2-DELETE-SNAPSHOTS") {

  environmentVariables {
    env('VOLUME_ID', "${VOLUME_ID}")
    env('RETAIN', "${RETAIN}")
    env('REGION', "${REGION_NAME}")
    env('ENV', "${ENV_NAME}")
  }

  triggers {
    cron('@daily')
  }
  
  logRotator {
    numToKeep(5)
  }

  definition {
    cpsScm {
      scm {
        git('https://github.com/vagnerd/jenkins-dsl-ec2-snapshot.git')
        scriptPath('pipelines/Jenkinsfile.delete')
      }
    }
  }

}
