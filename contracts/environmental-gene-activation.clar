(define-constant ERR-INVALID-EXPRESSION-LEVEL (err u1000))
(define-constant ERR-GENE-NOT-FOUND (err u1001))
(define-constant ERR-NOT-AUTHORIZED (err u1002))

;; Data Maps
(define-map gene-expression-levels
  { gene-id: uint, environmental-factor: principal }
  { expression-level: uint }
)

;; Private function to validate expression level (0-100)
(define-private (is-valid-expression-level (level uint))
  (and (>= level u0) (<= level u100))
)

;; Public function to register an environmental factor for a gene
(define-public (register-environmental-factor
  (gene-id uint)
  (environmental-factor principal)
  (initial-expression-level uint)
)
  (begin
    (asserts! (is-valid-expression-level initial-expression-level) ERR-INVALID-EXPRESSION-LEVEL)
    (map-insert gene-expression-levels
      { gene-id: gene-id, environmental-factor: environmental-factor }
      { expression-level: initial-expression-level }
    )
    (ok true)
  )
)

;; Public function to update the expression level of a gene based on an environmental factor
(define-public (update-expression-level
  (gene-id uint)
  (environmental-factor principal)
  (new-expression-level uint)
)
  (begin
    (asserts! (is-valid-expression-level new-expression-level) ERR-INVALID-EXPRESSION-LEVEL)
    (map-set gene-expression-levels
      { gene-id: gene-id, environmental-factor: environmental-factor }
      { expression-level: new-expression-level }
    )
    (ok true)
  )
)

;; Read-only function to get the expression level of a gene for a specific environmental factor
(define-read-only (get-expression-level
  (gene-id uint)
  (environmental-factor principal)
)
  (map-get? gene-expression-levels { gene-id: gene-id, environmental-factor: environmental-factor })
)

;; Example usage (for testing purposes)
(define-public (example-usage)
  (begin
    ;; Register an environmental factor for gene ID 1
    (try! (register-environmental-factor u1 tx-sender u50))

    ;; Update the expression level of gene ID 1 for the same environmental factor
    (try! (update-expression-level u1 tx-sender u75))

    ;; Get the expression level of gene ID 1 for the same environmental factor
    (print (get-expression-level u1 tx-sender))

    (ok true)
  )
)
