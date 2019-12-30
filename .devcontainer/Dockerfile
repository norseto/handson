FROM debian:buster-slim

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Terraform and tflint versions
ARG TERRAFORM_VERSION=0.12.12
ARG TFLINT_VERSION=0.10.1

# Or your actual UID, GID on Linux if not the default 1000
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    #
    # Install git, required tools installed
    && apt-get install -y \
        git \
        curl \
		iproute2 \
        procps \
        unzip \
        apt-transport-https \
        ca-certificates \
        gnupg-agent \
        software-properties-common \
        lsb-release 2>&1 \
    #
    # [Optional] Install Node.js for Azure Cloud Shell support 
    # Change the "lts/*" in the two lines below to pick a different version
    && curl -so- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash 2>&1 \
    && /bin/bash -c "source $HOME/.nvm/nvm.sh \
        && nvm install lts/* \
        && nvm alias default lts/*" 2>&1 \
    #
    # [Optional] For local testing instead of cloud shell
    # Install Docker CE CLI. 
    && curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    #
    # [Optional] For local testing instead of cloud shell
    # Install the Azure CLI
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/azure-cli.list \
    && curl -sL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - 2>/dev/null \
    && apt-get update \
    && apt-get install -y azure-cli \
    #
    # Install Terraform, tflint, and graphviz
    && mkdir -p /tmp/docker-downloads \
    && curl -sSL -o /tmp/docker-downloads/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip /tmp/docker-downloads/terraform.zip \
    && mv terraform /usr/local/bin \
    && curl -sSL -o /tmp/docker-downloads/tflint.zip https://github.com/wata727/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip \
    && unzip /tmp/docker-downloads/tflint.zip \
    && mv tflint /usr/local/bin \
    && cd ~ \ 
    && rm -rf /tmp/docker-downloads \
    && apt-get install -y graphviz \
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Uncomment the next three lines to add sudo support
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    ## Add kkubectl and gcp sdk
    && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && echo "deb http://packages.cloud.google.com/apt cloud-sdk-$(lsb_release -cs) main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" |  tee -a /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update \
    && apt-get install -y kubectl \
        bash-completion \
        vim jq \
        # python3-pip \
        google-cloud-sdk \
    && echo 'source /etc/profile.d/bash_completion.sh' >> /root/.bashrc \
    && echo 'source <(kubectl completion bash)' >> /root/.bashrc \
	&& yes | gcloud auth configure-docker \
    && curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases |\
        grep browser_download |\
        grep linux |\
        cut -d '"' -f 4 |\
        grep /kustomize/v |\
        sort | tail -n 1 |\
        xargs curl -O -L \
    && tar xzf ./kustomize_v*_linux_amd64.tar.gz \
    && mv ./kustomize /usr/bin/kustomize \
    && rm -f ./kustomize_v*_linux_amd64.tar.gz \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    ## Install helm
    && curl -L https://git.io/get_helm.sh | bash \
    # ## Install AWS SDK
    # && pip3 install awscli --upgrade --user \
    # ## Install IBM Cloud CLI
    # && curl -fsSL https://clis.cloud.ibm.com/install/linux | sh \
    # && ibmcloud plugin install kubernetes-service \
    ;

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=