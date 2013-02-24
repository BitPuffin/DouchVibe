module douchvibe.db;

import std.conv;
import vibe.vibe;

class Server {
    
}

class Database {
}

class Document {
}

class RestAPI {
    
    alias StrMapCI Headers; // Because fuck that

    private:
        HttpClient client;
        string host;
        ushort port;
        string url_http_signature;
        bool ssl;
        Headers headers;

    public:
        this(string host = "127.0.0.1", ushort port = 5984u, bool ssl = false, Headers headers = ["Content-Type" : "application/json"]) {
            client = new HttpClient; // Only allocate a client once, efficiency++
            
            this.host = host;
            this.port = port;
            url_http_signature = (ssl ? "https" : "http") ~ "://";
            this.ssl = ssl;
            this.headers = headers;
        }

        auto getResponse(string path, Headers headers = this.headers) {
            return request(path, headers);
        }

        // Do a GET request at the specified path and return a Json object
        Json get(string path, Headers headers = this.headers) {
            return request(path, headers).readJson();
        }
        
        // Don't parse JSON just get the raw data
        ubyte[] getRaw(string path, Headers headers = this.headers) {
            auto response = request(path, headers);
            response.lockedConnection = client;
            response.bodyReader = response.bodyReader; // Not sure why/if necessary, vibe did it though

            ubyte[] data;
            response.bodyReader.read(data);

            return data;
        }

        HttpResponse postResponse(string path, Json data, Headers headers = this.headers) {
            return request(path, headers, HttpMethod.POST, cast(ubyte[])data.toString());
        }

        HttpResponse postResponse(string path, ubyte[] data, headers headers = this.headers) {
            return request(path, headers, HttpMethod.POST, data);

        Json post(string path, Json data, Headers headers = this.headers) {
            return request(path, headers, HttpMethod.POST, cast(ubyte[])data.toString()).readJson();
        }

        Json post(string path, ubyte[] data, Headers headers = this.headers) {
            return request(path, headers, HttpMethod.POST, data).readJson();
        }

        HttpResponse putResponse(string path, Json data, Headers headers = this.headers) {
            return request(path, headers, HttpMethod.PUT, cast(ubyte[])data.toString());
        }

        HttpResponse putResponse(string path, ubyte[] data, Headers headers = this.headers) {
            return request(path, headers, HttpMethod.PUT, data);
        }

        Json put(string path, Json data, Headers headers = this.headers) {
            return request(path, headers, HttpMethod.PUT, cast(ubyte[])data.toString()).readJson();
        }

        Json put(string path, ubyte[] data, Headers headers = this.headers) {
            return request(path, headers, HttpMethod.PUT, data).readJson;
        }

        HttpResponse deleteResponse(string path, Headers headers = this.headers) {
            return request(path, headers, HttpMethod.DELETE);
        }

        Json delete(string path, Headers headers = this.headers) {
            return request(path, headers, HttpMethod.DELETE).readJson();

        HttpResponse copy(string path, Headers headers = this.headers) {
            return request(path, headers, HttpMethod.COPY);
        }

        Json copy(string path, Headers headers = this.headers) {
            return request(path, headers, HttpMethod.COPY).readJson();
        }

        auto request(string path, Headers headers = this.headers, HttpMethod meth /*dundudrugs*/ = HttpMethod.GET, ubyte[] data = null) {
            Url url = parsePath(path);
            
            client.connect(url.host, url.port, ssl);

            auto res = client.request( (req) {
                req.requestUrl = url.localURI;
                req.headers["Host"] = url.host;
                req.headers ~= headers;
                req.method = meth;

                if (data) {
                    req.writeBody(data, req.contentType);
                }
            });

            client.disconnect();
            return res;
        }

    private:
        auto parsePath(string path) {
            return Url.parse(url_http_signature ~ host ~ ":" ~ to!string(port) ~ "/" ~ path);
        }
}
