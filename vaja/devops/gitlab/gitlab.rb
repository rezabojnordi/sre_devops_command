external_url 'https://git2.vajab.ir'

gitlab_rails['initial_root_password'] = File.read('/run/secrets/gitlab_root_password')
gitlab_rails['gitlab_ssh_host'] = 'git2.vajab.ir'

nginx['listen_https'] = false
nginx['listen_port'] = 80

letsencrypt['enable'] = false

grafana['enable'] = false
prometheus['enable'] = false
prometheus_monitoring['enable'] = false