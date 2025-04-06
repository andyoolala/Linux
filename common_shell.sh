#!/bin/bash

# ===============================
# Environment Setup
# ===============================
SCRIPT_NAME=$(basename "$0")
LOG_FILE="./${SCRIPT_NAME%.*}.log"
START_TIME=$(date '+%Y-%m-%d %H:%M:%S')
MAIL_TO="you@example.com"

# ===============================
# Logging Functions
# ===============================
log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$LOG_FILE" >&2
}

# ===============================
# Error Notification
# ===============================
send_error_mail() {
    local subject="Script ${SCRIPT_NAME} Failed"
    local message="Script failed at $(date '+%Y-%m-%d %H:%M:%S')\nError: $1"
    echo -e "$message" | mail -s "$subject" "$MAIL_TO"
}

# ===============================
# Usage Instructions
# ===============================
usage() {
    cat <<EOF
Usage: $SCRIPT_NAME [options]

Options:
  -e    Environment (dev/test/prod)
  -d    Run date (format: YYYY-MM-DD)
  -h    Show this help message
EOF
    exit 1
}

# ===============================
# Argument Parsing
# ===============================
ENV=""
RUN_DATE=""

while getopts ":e:d:h" opt; do
    case $opt in
        e)
            ENV=$OPTARG
            ;;
        d)
            RUN_DATE=$OPTARG
            ;;
        h)
            usage
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
    esac
done

if [[ -z "$ENV" ]]; then
    log_error "Missing required parameter: environment (-e)"
    usage
fi

# ===============================
# Main Logic
# ===============================
main() {
    log_info "Script started"
    log_info "Environment: $ENV"
    log_info "Run date: ${RUN_DATE:-today}"

    # ======= Your main logic here =======
    # Example: simulate an error
    if ! ls /some/nonexistent/path >/dev/null 2>&1; then
        log_error "Directory not found"
        send_error_mail "Directory not found"
        exit 1
    fi

    # Other logic...

    # ======= End of main logic ==========
    log_info "Script completed successfully"
}

# ===============================
# Run Main Function
# ===============================
main "$@"