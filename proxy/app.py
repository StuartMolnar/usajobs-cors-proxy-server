import requests
import connexion

app = connexion.App(__name__, specification_dir='.')

# Define the CORS proxy endpoint
@app.route('/proxy/<path:path>', methods=['GET'])
def proxy(path):
    print('path accessed')
    # Get the request method and data from the client
    method = connexion.request.method
    data = connexion.request.get_data()
    print('method = ', method)
    print('data = ', data)

    # Set the URL of the destination server
    url = f'https://data.usajobs.gov/api/{path}'
    print('url = ', url)

    # Set the headers for the request
    headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization'
    }

    # Make the request to the destination server
    response = requests.request(method, url, data=data, headers=headers)
    print('response = ', response)
    print('response.text = ', response.text)

    # Return the response from the destination server to the client
    return response.text, response.status_code, headers

if __name__ == '__main__':
    app.run(host='localhost', port=8080)
