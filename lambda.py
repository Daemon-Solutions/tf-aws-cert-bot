
import socket
import ssl
import json
import re,sys,os,datetime
from botocore.vendored import requests

def ssl_expiry_date(domainname):
    ssl_date_fmt = r'%b %d %H:%M:%S %Y %Z'
    context = ssl.create_default_context()
    conn = context.wrap_socket(
        socket.socket(socket.AF_INET),
        server_hostname=domainname,
    )
    # 3 second timeout because Lambda has runtime limitations
    conn.settimeout(3.0)
    conn.connect((domainname, 443))
    ssl_info = conn.getpeercert()
    return datetime.datetime.strptime(ssl_info['notAfter'], ssl_date_fmt).date()

def slack(alert, expires, days):
    data = {
        "username": "Cert Bot",
        "icon_emoji": ":shield:",
        "text": os.environ['CHECK_URL'] + " SSL Certificate Due To Expire",
        "attachments": [
            {
                "color": "#c0392b" if alert else '#d35400',
                "fields": [
                    {
                      "title": "Expiry Date",
                      "value": expires.strftime('%A %B %-d %Y at %H:%M:%S'),
                      "short": "true"
                    },
                    {
                      "title": "Days Remaining",
                      "value": days,
                      "short": "true"
                    }
                ]
            }
        ]
    }

    post_data = json.dumps(data).encode('utf-8')

    req = requests.post(os.environ['SLACK_URL'], post_data)

    print(req.status_code, req.reason)

#####Main Section
def handler(event, context):
    expires = ssl_expiry_date(os.environ['CHECK_URL'])
    remains = int((expires - datetime.datetime.utcnow().date()).days)

    print('Expires: ', expires)
    print('Remains: ', remains)

    if remains <= int(os.environ['ALERT_DAYS']):
        slack(True, expires, remains)
    elif remains <= int(os.environ['WARN_DAYS']):
        slack(False, expires, remains)