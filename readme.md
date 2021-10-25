
# Biplane

![logo](https://user-images.githubusercontent.com/64656684/138736117-82b5a4cb-b1b2-418b-9dd6-f2e39c76852a.png)

Biplane is a stripped down HTTP/1.1 framework for [Janet](https://janet-lang.org). Biplane is great for small projects or when you want to mix and match libraries. Biplane aims to give you just enough to get off the ground, but leaves the rest to you.

* **PEG Router**: The optional router lets you use Janet [PEG](https://janet-lang.org/docs/peg.html) expressions, giving you fine control over URL matching and what values get captured.
* **Just a Function**: The main loop is just a function that takes an HTTP request and returns an HTTP response. There is no middleware complexity to learn, just data to read and modify as you see fit.

See the [Wiki](https://github.com/m7andrew/biplane/wiki) for the documentation.

## Install

```
jpm install https://github.com/m7andrew/biplane
```

## Examples

Hello world:

```clojure
(use biplane)

(defn app [req]
  (res/text "Hello World!"))

(serve app)
```

Simple routing:

```clojure
(use biplane)
(use biplane/router)

(defn hello [req name]
  (res/text (string "Hello " name)))

(defn not-found [req]
  (res/text "Not Found" 404))

(def routes
  [(GET '("/hello/" :string) hello)
   (GET '(:any) not-found)])

(defn app [req]
  (route req routes))

(serve app)
```