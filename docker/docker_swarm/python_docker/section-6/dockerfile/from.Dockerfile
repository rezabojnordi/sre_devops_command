# Dockerfile arguments,
# use --build-arg base=... --build-arg tag=... to overrride
ARG base=python
ARG tag=3
FROM $base:$tag

# Record Base Image name:
ARG base
ARG tag
LABEL baseimage=$base:$tag
ENV BASE_IMAGE=$base:$tag
RUN echo $base:$tag > /tmp/base_img

LABEL maintainer=kris@opencloudconsulting.net
WORKDIR /app
COPY ./app .
RUN pip install -r requirements.txt
ENV FLASK_ENV development
EXPOSE 5000
CMD ["python", "color_boxes.py"]
