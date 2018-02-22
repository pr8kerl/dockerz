.PHONY: publish login                                                                   
 
REPO := pr8kerl/k8s-toolbox

ifdef DOCKERHUB_PASSWORD
login:
	@docker login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD}
endif

publish:
	docker build -t ${REPO}:latest .
	docker push ${REPO}:latest

ifdef BUILDKITE_TAG
	docker build --build-arg VERSION=${BUILDKITE_TAG} -t ${REPO}:${BUILDKITE_TAG} .
	docker push ${REPO}:${BUILDKITE_TAG}
endif
