module douchvibe.db;

import vibe.http.client;
import vibe.data.json;

class Server {
    
}

class Database {

}

class RestClient {
    private:
        HttpClient client;
        string host;
        ushort port;
        string url_http_signature;

    public:
        this(string host = "127.0.0.1", ushort port = 5984u, bool ssl = false) {
            client = connectHttp(host, port, ssl);
            client.disconnect();
            
            this.host = host;
            this.port = port;
            url_http_signature = (ssl ? "https" : "http") ~ "://";
        }

        // Do a GET request at the specified path and return a Json object
        Json get(string path) {

        }
        
        // Don't parse JSON
        HttpResponse getRaw(string path) {
            
        }

}
