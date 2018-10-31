#!/bin/ash

source /alertmanager.secrets
cat > /etc/alertmanager/config.yml <<EOF
global:
  slack_api_url: $ALERTMANAGER_SLACK_API_URL

route:
  receiver: 'default'

receivers:
- name: 'default'
  slack_configs:
  - channel: '#aleksandr_loktionov'
  email_configs:
  - to: $ALERTMANGER_EMAIL_TO
    smarthost: smtp.mailgun.org:2525
    from: $ALERTMANGER_EMAIL_FROM
    auth_username: $ALERTMANGER_EMAIL_AUTH_USERNAME
    auth_password: $ALERTMANGER_EMAIL_AUTH_PASSWORD
  webhook_configs:
  - url: http://mgmt-host-default-001:9099/alerts
EOF

exec "$@"
