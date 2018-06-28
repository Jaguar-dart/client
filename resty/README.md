# jaguar_resty

Build fluent functional Restful clients

# Features

+ Fluent API to set:
    + Hierarchical paths  
        + `get('http://localhost:8080', '/api/book/${id}').go()`
        + `get('api').path('book').path(id).go()`
    + Query parameters
        + `get('/books').query('page', '2').list()`
    + Headers
        + `get('/book').header('page', '2').list()`
    + Body
        + `post('/book').json(Book('1', 'Harry potter')).one()`
+ JSON request encoding  
    + `post('/book').json(Book('1', 'Harry potter')).one()`
+ JSON request decoding
    + `get('/book/1').one(Book.map)`
+ URL encoded forms
+ Multipart form
+ Cookie jar
    + `get('/data').interceptBefore(jar.intercept).go()`
+ Interceptors
    + `get('/data').interceptBefore(jar.intercept).go()`
+ Authenticators