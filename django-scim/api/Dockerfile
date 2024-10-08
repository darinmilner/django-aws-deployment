ARG PYTHON_VERSION=3.12.5-slim-bullseye

FROM python:${PYTHON_VERSION} as python

FROM python as python-build-stage
ARG BUILD_ENVIRONMENT=production

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev

COPY ./requirements.txt .

RUN pip wheel --wheel-dir /usr/src/app/wheels \
    -r requirements.txt

FROM python as python-run-stage

ARG BUILD_ENVIRONMENT=production
ARG APP_HOME=/app

ENV PORT=8000
ENV PYTHONDONTWRITEBYTECODE  1
ENV PYTHONUNBUFFERED 1

ENV BUILD_ENV ${BUILD_ENVIRONMENT}

WORKDIR ${APP_HOME}

RUN addgroup --system django \
    && adduser --system --ingroup django django

COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.8.4 /lambda-adapter /opt/extensions/lambda-adapter

RUN apt-get update && apt-get install --no-install-recommends -y \
    libpq-dev \
    gettext netcat \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*

COPY --from=python-build-stage /usr/src/app/wheels /wheels/

RUN pip install --no-cache-dir --no-index --find-links=/wheels/ /wheels/* \
    && rm -rf /wheels/

# COPY --chown=django:django Start /Start
# RUN sed -i "s/\r$//g"  /Start
# RUN chmod +x /Start

COPY --chown=django:django . ${APP_HOME}

RUN chown django:django ${APP_HOME}

USER django

# ENTRYPOINT [ "/Start" ]
RUN python manage.py collectstatic --noinput 

EXPOSE 8000 

CMD ["gunicorn", "scimapi.wsgi:application", "-w=1", "-b=0.0.0.0:8000"]