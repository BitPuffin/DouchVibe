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

    public:
        this(string host="127.0.0.1", ushort port = 5984u, bool ssl=false) {
            client = connectHttp(host, port, ssl);
        }

        ~this() {
            client.disconnect();
        }
}
