# README

Almost all actions in the app run in jobs. Almost all jobs are triggered by a schedue, or by other jobs, to make work more atomic.

## Jobs

Documentation is still under development.

## ProcessLedgersJob
- walk through ledgers, starting from latest local ledger or the first ledger, until hard-coded limit
- create ledgers for each ledger, and enqueue ProcessLedgerOperationsJob if needed

## ProcessLedgerOperationsJob
- fetch operations of ledger
- per operation, if exists in db, do nothing
- else create in db, Per existing ward, and pass ward ID and op ID to a ProcessWardOperationJob

## ProcessWardOperationJob
- if ward wants to be notified of operation AND hasn't been notified (no Report record for the op AND ward), create report and delegate to SendReportJob
- if ward doesn't want to be notified, do nothing

## SendReportJob
- Send promised JSON to the callback_url (in ward), including hmac with secret
- success response - create report_response recording response and body. mark report as `complete`
- error response - create report_response recording response and body. keep `pending`

## ProcessPendingReportsJob
- run every 5 seconds
- select reports that are `pending`, compute fibo sequence to add (fibo N of report_responses) to add to created_at

## WardAfterCreateJob
- Search all operations that this ward wants to know about, and pass op ID and ward ID to ProcessWardOperationJob
