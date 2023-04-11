# API Service

| Category     | SLI | SLO                                                                                                         |
|--------------|-----|-------------------------------------------------------------------------------------------------------------|
| Availability | (Total number of successful requests) / (total number of requests)   | 99%                                                                                                         |
| Latency      | 90 percent of requests complete at or below 100ms    | 90% of requests below 100ms                                                                                 |
| Error Budget | (The number of error requests) / (Total number of requests)  | Error budget is defined at 20%. This means that 20% of the requests can fail and still be within the budget |
| Throughput   | Toal number of (2xx) success requests over time (Seconds)      | 5 RPS indicates the application is functioning                                                              |
