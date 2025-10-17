USERID="${1:-1}"
TESTNUM=$USERID
if ! [[ "${USERID}" =~ ^[0-9]+$ ]] ; then
   echo "error: Not a number" >&2; 
   exit 1
fi

USERNAME="${TESTNUM}.boss"

curl -X POST 'http://localhost:8000/api/user/' -H "Content-Type: application/json" --data-binary "{\"id\":${USERID},\"name\":\"USERNAME\"}"
echo ""


transact() {
    tp="$1"
    txid="$2"
    date="$3"
    amount="$4"
    http_status=$(curl -s -o /dev/null -w "%{http_code}" -X POST 'http://localhost:8000/api/transaction/' -H "Content-Type: application/json" \
        --data-binary "{\"uid\": \"${txid}\",\"user_id\":${USERID},\"amount\":\"${amount}\",\"created_at\":\"${date} 01:00:00\",\"type\":\"${tp}\"}")
    printf "POST http://localhost:8000/api/transaction/ ${http_status}\n"
}

get_request() {
    url="$1"
    http_status=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    printf "GET ${url} ${http_status}\n"
}

transact DEPOSIT "txid-${USERID}-0" 2023-01-01 1000.0
transact DEPOSIT "txid-${USERID}-0" 2023-01-01 1000.0

get_request "http://localhost:8000/api/user/${USERID}/balance/"

transact DEPOSIT 1 2023-02-01 500.0


get_request "http://localhost:8000/api/user/${USERID}/balance/"

get_request "http://localhost:8000/api/user/${USERID}/balance/?ts=2023-01-02"


transact WITHDRAW 2 2023-03-01 700.0 &
transact WITHDRAW 3 2023-03-01 700.0 &
transact WITHDRAW 4 2023-03-01 700.0 &
transact WITHDRAW 5 2023-03-01 700.0 &
transact WITHDRAW 6 2023-03-01 700.0

sleep 2
echo ""

get_request "http://localhost:8000/api/user/${USERID}/balance/"
