# Aviv and Yarden's final project dockerfile


# Image of container
FROM ubuntu:22.04


# Copy the repository
COPY . /final
WORKDIR /final


# Run and install
RUN apt -y update \
    && apt install -y python3 python3-pip python3-venv python3-dev build-essential libxml2-dev libxslt1-dev libffi-dev libpq-dev libssl-dev zlib1g-dev \
    && pip install --no-cache-dir -r requirements.txt \
    && python3 /final/statuspage/generate_secret_key.py \
    && echo "SECRET_KEY = '$(python3 /final/statuspage/generate_secret_key.py)' " >> /final/statuspage/statuspage/configuration.py \
    && PYTHON=/usr/bin/python3.10 \ 
    && chmod +x /final/upgrade.sh \
    && /final/upgrade.sh

# Expose ports
EXPOSE 8000:8000


CMD ["python3", "/final/statuspage/manage.py", "runserver", "0.0.0.0:8000","--insecure"]
