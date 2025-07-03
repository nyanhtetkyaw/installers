pipeline {
    agent { label 'Jenkins-Agent' }

    tools {
        jdk 'Java17'
        maven 'Maven3'
    }

    environment {
        APP_NAME = "register-app-pipeline"
        RELEASE = "1.0.0"
        DOCKER_USER = "jnhk"
        DOCKER_PASS = "dockerhub"  // This must be the credentialsId, not the actual password
        IMAGE_NAME = "${DOCKER_USER}/${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
    }

    stages {
        stage("Cleanup Workspace") {
            steps {
                cleanWs()
            }
        }

        stage("Checkout from SCM") {
            steps {
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/nyanhtetkyaw/installers'
            }
        }

        stage("Build Application") {
            steps {
                sh 'mvn clean package'
            }
        }

        stage("Test Application") {
            steps {
                sh 'mvn test'
            }
        }

        stage("SonarQube Analysis") {
            steps {
                script {
                    withSonarQubeEnv(credentialsId: 'Jenkins-SonarQube-Token') {
                        sh 'mvn sonar:sonar'
                    }
                }
            }
        }

        stage("Quality Gate") {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'Jenkins-SonarQube-Token'
                }
            }
        }

        stage("Build & Push Docker Image") {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_PASS}", usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_PASS}") {
                            def docker_image = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                            docker_image.push()
                            docker_image.push('latest')
                        }
                    }
                }
            }
        }

        stage("Trivy Scan") {
            steps {
                script {
                    sh ('docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image jnhk/register-app-pipeline --no-progress --scanners vuln --exit-code 0 --severity HIGH,CRITICAL --format table')
                }
            }
        }
    }
}


//pipeline {
//    agent { label 'Jenkins-Agent' }

//    tools {
//        jdk 'Java17'
//        maven 'Maven3'
//    }
//    environment {
//			APP_NAME = "register-app-pipeline"
//			RELEASE = "1.0.0"
//			DOCKER_USER = "jnhk"
//			DOCKER_PASS = 'dockerhub'
//			IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
//			IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
//	}
//    stages {
//        stage("Cleanup Workspace") {
//            steps {
//                cleanWs()
//            }
//        }

//        stage("Checkout from SCM") {
//            steps {
//                git branch: 'main', credentialsId: 'github', url: 'https://github.com/nyanhtetkyaw/installers'
//            }
//        }

//        stage("Build Application") {
//            steps {
//                sh 'mvn clean package'
//            }
//        }
//
//        stage("Test Application") {
//            steps {
//                sh 'mvn test'
//            }
//        }

//        stage("SonarQube Analysis") {
//            steps {
//                script {
//                    withSonarQubeEnv(credentialsId: 'Jenkins-SonarQube-Token') {
//                        sh 'mvn sonar:sonar'
//                    }
//                }
//            }
//        }
//
//        stage("Quality Gate") {
//            steps {
//                script {
//                    waitForQualityGate abortPipeline: false, credentialsId: 'Jenkins-SonarQube-Token'
//                }
//            }
//        }
//
//	stage("Build & Push Docker Image") {
//	    steps {
//		script {
//		    docker.withRegistry('',DOCKER_PASS) {
//			docker_image = docker.build "${IMAGE_NAME}"
//		    }
//		    docker.withRegistry('',DOCKER_PASS) {
//			docker.image.push("${IMAGE_TAG}")
//			docker.image.push('latest')
//		    }
//		}
//	   }
//    }
//}
