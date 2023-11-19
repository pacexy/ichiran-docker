(in-package #:ichiran/conn)

(defparameter *connection* '("ichiran-db" "postgres" "postgres" "db.railway.internal"))

(defparameter *connections* '((:old "jmdict_old" "postgres" "password" "db.railway.internal")
                              (:test "jmdict_test" "postgres" "password" "db.railway.internal")))

(in-package #:ichiran/dict)

(defparameter *jmdict-path* #p"/home/ubuntu/dump/JMdict_e")

(defparameter *jmdict-data* #p"/jmdictdb/jmdictdb/data/")

(in-package #:ichiran/kanji)

(defparameter *kanjidic-path* #P"/home/ubuntu/dump/kanjidic2.xml")
