pipeline{
    agent none
    tools {
        maven 'maven'
    }

    environment {
        dockerTag = "001285825849.dkr.ecr.us-east-1.amazonaws.com/petclinic:${env.BUILD_ID}"
        dockerRegistry = "https://001285825849.dkr.ecr.us-east-1.amazonaws.com"
        // dockerCredentialsId = "Docker_Hub"
    }

    stages{

        stage('Checkout'){
            agent any
            steps{
                git branch: 'main', url: 'https://github.com/gkiran04/spring-petclinic.git'
            }
        }

        

        stage('Build'){
            agent any
            steps{
                sh 'mvn clean package'
            }
        }

        

        stage('Image Build & Push') {
            agent any
            steps {
                // Checkout source code from your repository if needed

                // Build Docker image
                script {
                    docker.withRegistry(dockerRegistry, 'ecr:us-east-1:AWScred') {
                        def dockerImage = docker.build(env.dockerTag,'-f Dockerfile .')
                        dockerImage.push()
                    }    
                }
            }
            post {
                always {
                    sh " docker rmi ${dockerTag}"
                }
            }
        }
        stage('Deploy'){
            agent any
            environment {
                GIT_REPO_NAME = "spring-petclinic"
                GIT_USER_NAME = "gkiran04"
            }
            steps{
                withCredentials([string(credentialsId: 'GIT_TOKEN', variable: 'GITHUB_TOKEN')]){
                    sh '''
                        git config user.email "kiran@gmail.com"
                        git config user.name "kiran kumar"
                        BUILD_NUMBER=${BUILD_NUMBER}
                        sed -i "s/petclinic:.*/petclinic:${BUILD_NUMBER}/g" kube-manifest/app-deployment.yaml
                        git add kube-manifest/app-deployment.yaml
                        git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                        git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
                    '''
                
                }
            }
        }
        

        

        
    } // END Stages
} // END Pipeline


/* 
-Dsonar.host.url=http://34.93.14.143:9000 
-Dsonar.login=admin \
                        -Dsonar.login=squ_9e86adbee33e1e4fdf333170161d330fc83a7629
                        
docker.withRegistry(dockerRegistry, dockerCredentialsId) {
                        def dockerImage = docker.build(env.dockerImage, '-f Dockerfile .')
                        dockerImage.push()
                    }                         */
