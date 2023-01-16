ARG base=python
ARG tag=3
FROM $base:$tag
ARG base
ARG tag
LABEL baseimage=$base:$tag
LABEL maintainer=kris@opencloudconsulting.net
WORKDIR /app
COPY ./app .
RUN pip install -r requirements.txt
# Install Gunicorn Module
RUN pip install gunicorn
EXPOSE 5000
CMD ["gunicorn", "-b", "0.0.0.0:5000", "color_boxes:APP"]
