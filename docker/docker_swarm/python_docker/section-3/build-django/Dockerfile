FROM python:3
WORKDIR /app
COPY bookmarks .
RUN pip install -r requirements.txt
VOLUME /data
RUN python manage.py collectstatic
CMD ["uwsgi", "bookmarks_uwsgi.ini"]
