# jaguar_resty

Build fluent functional Restful clients

# Features

+ Fluent API to set:
    + Hierarchical paths  
        + `get('http://localhost:8080/api/book/${id}').go()`
        + `get('http://localhost:8080/api').path('book').path(id).go()`
    + Query parameters
        + `get('/books').query('page', '2').go()`
    + Headers
        + `get('/book').header('page', '2').go()`
    + Body
        + `post('/book').json(Book('1', 'Harry potter')).go()`
+ JSON request encoding  
    + `post('/book').json(Book('1', 'Harry potter')).go()`
+ JSON request decoding
    + `get('/book/1').readOne(Book.fromMap)`
+ URL encoded forms
+ Multipart form
+ Cookie jar
    + `get('/data').before(jar).go()`
+ Interceptors
    + `get('/data').before(jar).go()`
+ Authenticators

# TODO

+ Connection pool
+ Per host connection pool