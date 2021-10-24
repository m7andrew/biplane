(use http)

# HTTP Actions --------------------------------------------

(defn serve [handler &opt host port]
  (default host "localhost")
  (default port 8000)
  (defn handle [stream]
    (defer (net/close stream)
    (def response (-?> (read/request stream) handler))
    (write/response stream (or response {:status 404}))))
  (net/server host port handle)
  (print (string "listening at " host ":" port "...")))

(defn send [request]
  (def host (get-in request [:headers "Host"]))
  (def stream (net/connect host 80))
  (write/request stream request)
  (defer (net/close stream)
  (read/response stream)))

# Response Shortcuts --------------------------------------

(def- mime-types
  {"txt"  "text/plain"
   "css"  "text/css"
   "xml"  "text/xml"
   "htm"  "text/html"
   "html" "text/html"
   "js"   "application/javascript"
   "json" "application/json"
   "jpg"  "image/jpeg"
   "jpeg" "image/jpeg"
   "png"  "image/png"
   "gif"  "image/gif"
   "svg"  "image/svg+xml"})

(defn- file-exists? [path]
  (= (os/stat path :mode) :file))

(defn- file-type [path]
  (get mime-types (last (string/split "." path))))

(defn res/file [path &opt content-type]
  (default content-type (file-type path))
  (when (and (file-exists? path) content-type)
    {:headers  {"Content-Type" content-type}
     :body     (string (slurp path))}))

(defn res/text [body &opt status]
  {:status   status
   :headers  {"Content-Type" "text/plain"}
   :body     body})

(defn res/html [body &opt status]
  {:status   status
   :headers  {"Content-Type" "text/html"}
   :body     body})

(defn res/json [body &opt status]
  {:status   status
   :headers  {"Content-Type" "application/json"}
   :body     body})

(defn res/redirect [location]
  {:status   302
   :headers  {"Location" location}})
