# d4py
Example files

# step1 for learning docker for python code
```
docker container run -it --name myflask1 -p 5000:5000 -v ${PWD}:/app python3.7 bash

# pip install flask==1.1.1
# cd /app
# ls
# more flask_example.py
# export FLASK_APP=flask_example.py
# export FLASK_DEBUG=1
# flask run --host=0.0.0.0
# exit
```

## jupyter 

```
docker container run -it --name jupyter-data -p 8888:8888 -v ${PWD}:/home/jovyan/work -e JUPYTER_ENABLE_LAB=yes jupyter/datascience-notebook

```
