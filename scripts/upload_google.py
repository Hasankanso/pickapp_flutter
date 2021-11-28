#!/usr/bin/python
#
# Copyright 2014 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the 'License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Uploads an apk to the alpha track."""

import argparse
import httplib2
from oauth2client import client, service_account
from apiclient.discovery import build

TRACK = 'internal'  # Can be 'alpha', beta', 'production' or 'rollout' or 'internal'


def main(argparser, SERVICE_ACCOUNT_EMAIL):
    # Load the key in PKCS 12 format that you downloaded from the Google APIs
    # Console when you created your Service account.
    # private key password: notasecret

    # Create an httplib2.Http object to handle our HTTP requests and authorize it
    # with the Credentials. Note that the first parameter, service_account_name,
    # is the Email address created for the Service account. It must be the email
    # address associated with the key that was created.
    credentials = service_account.ServiceAccountCredentials.from_p12_keyfile(
        SERVICE_ACCOUNT_EMAIL,
        "key.p12",
        token_uri='https://www.googleapis.com/auth/androidpublisher')
    http = httplib2.Http()
    http = credentials.authorize(http)

    service = build('androidpublisher', 'v3', http=http)

    # Process flags and read their values.
    flags = argparser.parse_args()

    package_name = flags.package_name
    apk_file = flags.apk_file

    try:
        edit_request = service.edits().insert(body={}, packageName=package_name)
        result = edit_request.execute()
        edit_id = result['id']

        apk_response = service.edits().apks().upload(
            editId=edit_id,
            packageName=package_name,
            media_body=apk_file).execute()

        print('Version code %d has been uploaded' % apk_response['versionCode'])

        track_response = service.edits().tracks().update(
            editId=edit_id,
            track=TRACK,
            packageName=package_name,
            body={u'releases': [{
                u'name': u'My first API release',
                u'versionCodes': [str(apk_response['versionCode'])],
                u'status': u'completed',
            }]}).execute()

        print('Track %s is set with releases: %s' % (
            track_response['track'], str(track_response['releases'])))

        commit_request = service.edits().commit(
            editId=edit_id, packageName=package_name).execute()

        print('Edit "%s" has been committed' % (commit_request['id']))

    except client.AccessTokenRefreshError:
        print('The credentials have been revoked or expired, please re-run the '
              'application to re-authorize')


if __name__ == '__main__':
    # Declare command-line flags.
    argparser = argparse.ArgumentParser(add_help=False)
    argparser.add_argument('-p', '--package_name', type=str,
                           help='The package name. Example: com.android.sample')

    argparser.add_argument('-a', '--apk_file',
                           nargs='?',
                           default='test.aab',
                           help='The path to the aab file to upload.')

    SERVICE_ACCOUNT_EMAIL = (
        'app-publisher@pc-api-4658478593732844916-64.iam.gserviceaccount.com')
    main(argparser, SERVICE_ACCOUNT_EMAIL)
