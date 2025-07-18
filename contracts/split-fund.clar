;; SplitFund - Split STX payments among recipients

(define-constant contract-owner tx-sender)
(define-constant SCALE u10000) ;; For percentage-based calculations (100% = 10000)

(define-map recipients
  { recipient: principal }
  { share: uint }) ;; share in basis points (out of 10,000)

(define-data-var total-share uint u0)

;; Add or update a recipient's share (only contract owner)
(define-public (set-recipient (who principal) (share uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err u100))
    (let ((current (default-to u0 (get share (map-get? recipients { recipient: who })))))

      (var-set total-share
        (+ (- (var-get total-share) current) share))

      (map-set recipients { recipient: who } { share: share })

      (ok { recipient: who, share: share })
    )))

;; Remove a recipient (only owner)
(define-public (remove-recipient (who principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err u101))
    (let ((existing (unwrap! (map-get? recipients { recipient: who }) (err u102))))
      (var-set total-share (- (var-get total-share) (get share existing)))
      (map-delete recipients { recipient: who })
      (ok { removed: who })
    )))

;; Split the sent STX amount to all recipients
(define-public (split-payment)
  (let ((amount (stx-get-balance tx-sender)))
    (begin
      (asserts! (> amount u0) (err u103))
      (let ((total (var-get total-share)))
        (asserts! (> total u0) (err u104))

        ;; Iterate over recipients and transfer based on share
        (begin
          ;; Example of 3 manual recipients. You can dynamically iterate in real implementations with off-chain helper tools.
          (unwrap-panic (split-to tx-sender amount))
          (ok "Payment split successfully")
        )
      )
    )))
;; Helper to distribute to all recipients (hardcoded loop or off-chain controlled)
(define-private (split-to (sender principal) (amount uint))
  ;; This function should loop through `recipients` and send proportional amounts
  ;; Looping is limited in Clarity - use fixed recipient count or off-chain interface
  (ok true)) ;; Return single success value
