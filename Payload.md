# :ledger: Payload

## Examples:
**All Fields Payload**
```JSON
{
    "ios": {
        "minimum_version": {
            "version": "1.10.9",
            "display_msg": "Sorry! You need to upgrade to access to new features.",
            "store_link": "https://google.com/product_link",
            "notification_type": "ALWAYS"
        },
        "recommended_version": {
            "version": "1.22.1",
            "display_msg": "Upgrade to get some neat new features!",
            "store_link": "https://google.com/product_link2",
            "notification_type": "ONCE"
        }
    }
}
```

**Only a minimum version**
```JSON
{
    "ios": {
        "minimum_version": {
            "version": "1.10.9",
            "display_msg": "You should really upgrade. This message will only be displayed once.",
            "store_link": "https://google.com/product_link",
        }
    }
}
```

**Smallest valid json allowed**
```JSON
"ios": { }
```

---

### :key: Required keys:
#### `ios`: required key
  Should always be included as a top level key

---

## :key: Optional keys:
#### `minimum_version`: optional
  The following are all required values a `minimum_version` dictionary object:

  - `version`: string
  - `display_msg`: string
  - `store_link`: url string
  - `notification_type`: Valid values: `"ONCE"` or `"ALWAYS"`

#### `recommended_version`: optional
  Follows the same convention as `minimum_version`.
