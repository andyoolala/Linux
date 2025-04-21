#!/bin/bash

# ---------- Global Variables ----------
SCRIPT_NAME=$(basename "$0")
SCRIPT_BASE="${SCRIPT_NAME%.*}"
LOG_PATH="."
LOG_FILE="$LOG_PATH/${SCRIPT_BASE}_$(date +%Y%m%d).log"
LOCK_FILE="/tmp/${SCRIPT_BASE}.lock"
MAIL_TO="you@example.com"
START_TIME=0

# ---------- Logging ----------
log_info()  { echo "[INFO ] $(date '+%F %T') $*" | tee -a "$LOG_FILE"; }
log_warn()  { echo "[WARN ] $(date '+%F %T') $*" | tee -a "$LOG_FILE"; }
log_error() { echo "[ERROR] $(date '+%F %T') $*" | tee -a "$LOG_FILE" >&2; }
log_debug() { [[ "$DEBUG" == "true" ]] && echo "[DEBUG] $(date '+%F %T') $*" | tee -a "$LOG_FILE"; }

# ---------- Timer ----------
timer_start() {
    START_TIME=$(date +%s)
}

timer_end() {
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    log_info "Elapsed time: ${DURATION} seconds"
}

# ---------- Error Handling ----------
exit_with_error() {
    local msg="$1"
    log_error "$msg"
    send_error_mail "$msg"
    remove_lock
    exit 1
}

# ---------- Email Notification ----------
send_error_mail() {
    local msg="$1"
    echo -e "Subject: [ERROR] $SCRIPT_NAME\n\n$msg\n\nSee log: $LOG_FILE" | sendmail "$MAIL_TO"
}

# ---------- Lockfile ----------
create_lock() {
    if [[ -f "$LOCK_FILE" ]]; then
        log_error "Script is already running (lock file exists: $LOCK_FILE)"
        exit 1
    fi
    echo $$ > "$LOCK_FILE"
    log_debug "Created lock file: $LOCK_FILE"
}

remove_lock() {
    [[ -f "$LOCK_FILE" ]] && rm -f "$LOCK_FILE"
    log_debug "Removed lock file"
}

# Trap to always cleanup lock file on exit
trap remove_lock EXIT
