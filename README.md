# README : The "points_backend" API

> This was a backend API I was asked to assemble for a prospective employer

### The highlights of this backend API are the following:

- You can run an index action to see every transaction (that's been logged so-far) in the Transactions database (https://points-payer-backend.herokuapp.com/api/transactions)
- Run an index action to see all payer point-totals in the Payers database (https://points-payer-backend.herokuapp.com/api/points_balance)
- And you can even run a user-expenditure route (https://points-payer-backend.herokuapp.com/api/spend_points)
  > Note:
- _A seed file is provided, should you wish to download & create these demo databases ($ rails db:seed will create a Payer database & a Transactions database)_

Please feel free to test these endpoints (baring in mind that calling the /spend_points endpoint will _alter_ the Payer database's _point totals_ each time it is run). If the /spend_points route is run more than once, **you will want to run** the /payers/reset route (https://points-payer-backend.herokuapp.com/api/payers/reset) in order to **reset their points totals** and return the outcomes expected in the original exercise

#

### ( For Refrence )

#### The original exercise stipulated the following:

#### Background

Users have points in their accounts. Users only see a single balance in their accounts. But for reporting purposes we actually track their points per payer/partner. In our system, each transaction record contains: ​payer​ (string), ​points​ (integer), ​timestamp​ (date).  
For earning points it is easy to assign a payer, we know which actions earned the points. And thus which partner should be paying for the points.

> The implication, here, is that when USERS add points to their account balance, PAYERS/PARTNERS will be billed/charged for them.
> Also, it is not clear what actions earned the user/will cost the payer these points … but we don't care for this exercise
> When a user spends points, they don't know or care which payer the points come from. But, our accounting team does care how the points are spent. There are two rules for determining what points to "spend" first:

- We want the oldest points to be spent first (oldest based on transaction timestamp, not the order they’re received)
- We want no payer's points to go negative.

We expect your web service to provide routes that:

- Add transactions for a specific payer and date.
- Spend points using the rules above and return a list of ​{ "payer": <string>, "points": <integer> }​ for each call.
- Return all payer point balances.

Note:

- We are not defining specific requests/responses. Defining these is part of the exercise.
- We don’t expect you to use any durable data store. Storing transactions in memory is acceptable for the exercise.

#### Example

Suppose you call your add transaction route with the following sequence of calls:

- { "payer": "DANNON", "points": 1000, "timestamp": "2020-11-02T14:00:00Z" }
- { "payer": "UNILEVER", "points": 200, "timestamp": "2020-10-31T11:00:00Z" }
- { "payer": "DANNON", "points": -200, "timestamp": "2020-10-31T15:00:00Z" }
- { "payer": "MILLER COORS", "points": 10000, "timestamp": "2020-11-01T14:00:00Z" }
- { "payer": "DANNON", "points": 300, "timestamp": "2020-10-31T10:00:00Z" }

Then you call your spend points route with the following request:  
{ "points": 5000 }
The expected response from the spend call would be:

[
{ "payer": "DANNON", "points": -100 },
{ "payer": "UNILEVER", "points": -200 },
{ "payer": "MILLER COORS", "points": -4,700 }
]

A subsequent call to the points balance route, after the spend, should returns the following results:

{
"DANNON": 1000,
"UNILEVER": 0,
"MILLER COORS": 5300
}
