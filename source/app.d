/**
    Small test application

    Copyright: (c) 2013 Isak Andersson
    License: Zlib/libpng
    Authors: Isak Andersson
*/

import vibe.d;

import douchvibe.douchvibe.db;

static this() {
    auto db = Database.get("foo");  // Gets the foo db and initializes it if it doesn't exist, using default port and host

    auto json_data = Json.EmptyObject;
    json_data.name = "Bar";
    json_data.age = 34;

    auto doc = new Document(json_data);
    db.put(doc);

    auto doc_id = doc["_id"];
    auto doc_rev = doc["_rev"];

    // alternatively..
    auto server = new Server(); // Gets a reference to the server using default port and host
    auto db1 = new Database(server, "faa");
    assert(db == db1);  // They are the same object
    auto db2 = new Database(server, "bar");
}
