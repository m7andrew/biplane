(import url)

(def- $form
  (peg/compile
    ~{:main  (sequence :pair (any (sequence "&" :pair)))
      :pair  (sequence (cmt (capture :key) ,url/unescape) "=" (cmt (capture :value) ,url/unescape))
      :key   (some (sequence (not "=") 1))
      :value (some (sequence (not "&") 1))}))

(defn decode [str]
  (struct ;(peg/match $form str)))

(defn encode [dict]
  (defn pair [[k v]] (string/format "%s=%s" (url/escape k) (url/escape v)))
  (string/join (map pair (pairs dict)) "&"))
