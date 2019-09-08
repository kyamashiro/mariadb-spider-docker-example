docker/start: docker-compose.yml
	docker-compose up -d spider_node data_node1 data_node2

docker/stop:
	docker-compose stop

docker/build:
	docker-compose -f "docker-compose.yml" up -d --build

docker/remove:
	docker-compose stop
	docker-compose rm

bash:
	docker exec -it spider_node bash

bash/node1:
	docker exec -it data_node1 bash

bash/node2:
	docker exec -it data_node2 bash