### Print

```sql
SELECT password_hash, is_superuser FROM mqtt_user WHERE username = ${username} OR ip = ${peerhost} LIMIT 1
```

```sql
SELECT action, permission, topic FROM mqtt_acl WHERE username = ${username} OR ip = ${peerhost}
```
