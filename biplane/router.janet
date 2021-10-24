
# Grammers ------------------------------------------------

(put default-peg-grammar :any
  '(any 1))

(put default-peg-grammar :string
  '(capture (some (sequence (not "/") 1))))

(put default-peg-grammar :name
  '(capture (some (choice (set "-_") :w))))

(put default-peg-grammar :path
  '(capture (drop (some (sequence "/" :string)))))

(put default-peg-grammar :date
  '(capture (sequence :d :d :d :d "-" :d :d "-" :d :d)))

# Router --------------------------------------------------

(defn- new-route [method path func]
  [method (peg/compile ~(sequence ,;path (opt "/") -1)) func])

(def GET    (partial new-route "GET"))
(def POST   (partial new-route "POST"))
(def PUT    (partial new-route "PUT"))
(def DELETE (partial new-route "DELETE"))
(def HEAD   (partial new-route "HEAD"))
(def TRACE  (partial new-route "TRACE"))
(def PATCH  (partial new-route "PATCH"))

(defn route [request routes]
  (def {:method method :path path} request)
  (var response nil)
  (defn active-route? [[kind pattern func]]
    (if-let [method (= kind method)
             params (peg/match pattern path)
             result (func request ;params)]
      (set response result)))
  (when (find active-route? routes) response))
