FROM python:3
LABEL maintainer kris@opencloudconsulting.net
WORKDIR /app
COPY ./app .
RUN pip install -r requirements.txt

# Install Debian Linux System Packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends htop && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV FLASK_ENV development
EXPOSE 5000
CMD ["python", "color_boxes.py"]
