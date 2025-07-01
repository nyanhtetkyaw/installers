pipeline {
	agent { label 'Jenkins-Agent' }
	tools {
		jdk 'java17'
		maven 'Maven3'
	}
	stages{"Cleanup Workspace"){
			steps {
			cleanWs()
			}
		}
		
		stage("Checkout from SCM"){
				steps {
					git branch: 'main', credentialsId: 'github', url: 'https://github.com/nyanhtetkyaw/registration-app'
				}
		}
		
		stage("Build Application"){
			steps {
				sh "mvn clean package"
			}
		}
		
		stage("Test Application"){
			steps {
				sh "mvn test"
			}
		}
	}
}
