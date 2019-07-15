org=multipl
name=judge

image:
	docker build -t ${org}/${name}:latest .

shell:
	docker run --rm -it --privileged ${org}/${name}:latest /bin/bash

run:
	./RUN.sh busybox
