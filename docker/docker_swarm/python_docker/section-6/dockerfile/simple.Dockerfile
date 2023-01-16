# define base image
FROM python:3

# define Image Label
LABEL maintainer kris@opencloudconsulting.net

# set working directory
WORKDIR /app

# copy 'app' subfolder content to current directory, i.e. '/app'
COPY ./app .

# run command at build time
RUN pip install -r requirements.txt

# set Environment Variable
ENV FLASK_ENV development

# Declare Container Ports
EXPOSE 5000

# define Start-up Command, Entrypoint is null
CMD ["python", "color_boxes.py"]
