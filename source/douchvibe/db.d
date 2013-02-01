module douchvibe.db;

import std.conv;

import vibe.http.client;
import vibe.data.json;
import vibe.inet.url;

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
        bool ssl;

    public:
        this(string host = "127.0.0.1", ushort port = 5984u, bool ssl = false) {
            client = connectHttp(host, port, ssl);
            client.disconnect();
            
            this.host = host;
            this.port = port;
            url_http_signature = (ssl ? "https" : "http") ~ "://";
            this.ssl = ssl;
        }

        // Do a GET request at the specified path and return a Json object
        Json get(string path) {
            client.connect();
            Url url = parsePath(path);
            auto response = commonGet(url);
            auto json = response.readJson();
            client.disconnect();
            return json;
        }
        
        // Don't parse JSON just get the raw data
        ubyte[] getRaw(string path) {
            client.connect(url.host, url.port, ssl);
            Url url = parsePath(path);
            auto response = commonGet(url);
            response.lockedConnection = client;
            response.bodyReader = response.bodyReader; // Not sure why/if necessary, vibe did it though
            ubyte[] data;
            response.bodyReader.read(data);
            client.disconnect();
            return data;
        }

    private:
        auto parsePath(string path) {
            return Url.parse(url_http_signature ~ host ~ ":" ~ to!string(port) ~ "/" path);
        }

        auto commonGet(Url url) {
            return client.request( (req) {
                req.requestUrl = url.localURI;
                req.headers["Host"] = url.host;
            });
        }
}
