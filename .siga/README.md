# .siga

Repository-visible coordination state for concurrent sessions.

Session claims live here as append-only or explicitly closed coordination records.

Naming:

~~~text
session-claim-<task-key>-<session-id>.md
~~~

Claims are operational coordination, not product truth. Constitution/specs and live repository state remain authoritative.
