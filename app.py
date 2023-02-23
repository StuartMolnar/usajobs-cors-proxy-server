import requests
import connexion
import ssl
import yaml

app = connexion.App(__name__, specification_dir='.')

# Load variables from the configuration file
with open('app_conf.yml', 'r') as f:
    app_config = yaml.safe_load(f.read())

# Define the CORS proxy endpoint
@app.route('/proxy/<path:path>', methods=['GET'])
def proxy(path):
    print('debug status: path accessed')
    # Get the request method and data from the client
    method = connexion.request.method
    data = connexion.request.get_data()

    # Set the URL of the destination server
    url = f'https://data.usajobs.gov/api/{path}'

    # Set the headers for the request
    headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization'
    }

    # Make the request to the destination server
    response = requests.request(method, url, data=data, headers=headers)

    # Return the response from the destination server to the client
    print('debug status: request completed')
    return response.text, response.status_code, headers

if __name__ == '__main__':
    # Load the SSL certificate and key files
    ssl_context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
    ssl_context.load_cert_chain(
        f'/etc/letsencrypt/live/{app_config["hostname"]}/fullchain.pem', 
        f'/etc/letsencrypt/live/{app_config["hostname"]}/privkey.pem'
    )

    # Run the app with the SSL context
    app.run(host='0.0.0.0', port=8443, ssl_context=ssl_context)
