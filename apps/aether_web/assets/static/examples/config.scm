(add-to-load-path (getcwd))
(use-modules (momus-builtin scm-core))
(use-modules (momus-builtin c-core))
(use-modules (momus-builtin commandline))

(run-json (test-sequence "t" 2 15))
