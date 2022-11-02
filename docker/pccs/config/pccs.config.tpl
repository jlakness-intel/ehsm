{
    "HTTPS_PORT" : "${PCCS_PORT}",
    "hosts" : "0.0.0.0",
    "uri": "https://api.trustedservices.intel.com/sgx/certification/v3/",
    "ApiKey": "${PCCS_API_KEY}",
    "proxy" : "",
    "RefreshSchedule": "0 0 1 * * *",
    "UserTokenHash" : "${PCCS_USER_HASH}",
    "AdminTokenHash" : "${PCCS_ADMIN_HASH}",
    "CachingFillMode" : "LAZY",
    "LogLevel" : "debug",
    "DB_CONFIG" : "sqlite",
    "sqlite" : {
        "database" : "database",
        "username" : "username",
        "password" : "password",
        "options" : {
            "host": "localhost",
            "dialect": "sqlite",
            "pool": {
                "max": 5,
                "min": 0,
                "acquire": 30000,
                "idle": 10000
            },
            "define": {
                "freezeTableName": true
            },
            "logging" : false,
            "storage": "/tmp/pckcache.db"
        }
    },
    "mysql" : {
        "database" : "pckcache",
        "username" : "root",
        "password" : "mypass",
        "options" : {
            "host": "localhost",
            "dialect": "mysql",
            "pool": {
                "max": 5,
                "min": 0,
                "acquire": 30000,
                "idle": 10000
            },
            "define": {
                "freezeTableName": true
            },
            "logging" : false
        }
    }
}
