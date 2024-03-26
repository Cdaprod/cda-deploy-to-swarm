FROM jupyter/datascience-notebook

# Install Edge TPU Python API library
#RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | sudo tee /etc/apt/sources.list.d/coral-edgetpu.list && \
    #curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
    #sudo apt-get update && \
    #sudo apt-get install libedgetpu1-std python3-edgetpu

# Install Clients
RUN pip install minio weaviate-client transformers  openai langchain

# Install requirements for OpenAI and LangChain integration
RUN pip install pydantic bs4 poetry fastapi uvicorn docker unstructured
