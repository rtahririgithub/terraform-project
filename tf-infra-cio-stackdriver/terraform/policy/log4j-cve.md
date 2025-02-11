# [Log4J CVE 2021-44228] - Exploit Detected 

## Summary

Custom log metrics have detected and attempt to exploit `cve-202104428` "Log4Shell" based on a shared GKE Cluster:

- The string `jndi` present in the HTTP(s) Request URL
- The string `jndi` present in the HTTP(s) Request User Agent

*This alert **does not** confirm that the exploit was executed successfully.*

## Next Steps

Use [GCP Cloud Logging](https://cloud.google.com/logging) to review the cluster logs for 

Sample Cloud Log Queries:

Environment | Cluster |
------------| ------- |
NP          | [public-yul-np-002](https://cloudlogging.app.goo.gl/DMFrYKjwyaFNTy9i6)        |
PR          | [public-yul-pr-002](https://cloudlogging.app.goo.gl/yL8i5ZXfYzX3uR9B6)        |




