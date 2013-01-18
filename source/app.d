/**
    Small test application

    Copyright: (c) 2013 Isak Andersson
    License: Zlib/libpng
    Authors: Isak Andersson
*/

import vibe.d;

import douchvibe.client;

static this() {
   auto client = new CouchClient(); // Automatically fetches default localhost settings
   auto test_db = client.getDB("dogs"); // Gets the database, creates it if it doesn't exist
   auto test_document = test_db.createDocument();
   test_document.setValue("Larry", "Sausage dog");
   test_document.setValue("Murray", "Huskys");
   test_db.save(test_document);
}
