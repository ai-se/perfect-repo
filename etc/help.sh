grep -E '^[a-zA-Z][^:]*:.*?## .*$' $* |
sort | 
awk 'BEGIN {FS = ":.*?## "}; \
           {printf "\033[36m%-30s\033[0m %s\n", $1, $2}'

