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
   auto dog_db = client["dogs"]; // Fetches the dogs database, if it doesn't exist it's initialized automatically
}
