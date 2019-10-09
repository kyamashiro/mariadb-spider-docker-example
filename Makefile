start: docker-compose.yml
	docker-compose up -d

stop:
	docker-compose stop

build:
	docker-compose -f "docker-compose.yml" up -d --build

remove:
	docker-compose stop
	docker-compose rm

bash:
	docker exec -it spider_node bash

bash/node1:
	docker exec -it data_node1 bash

bash/node2:
	docker exec -it data_node2 bash
