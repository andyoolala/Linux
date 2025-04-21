#!/bin/bash
source "/home/andyj/job_utils.sh"

create_lock
log_info "Job started with Script path: $0 and Arguments: $@"
timer_start

# ---------- Usage ----------

print_usage() {
    cat <<EOF
Usage: $SCRIPT_NAME 

Options:
# ------------------------[ CUSTOM ARGS START ]------------------------
# 
# 
# 
# ------------------------[ CUSTOM ARGS END   ]------------------------
  -h    Show this help message
EOF
}


while getopts ":e:d:Dh" opt; do
    case "$opt" in
# ------------------------[ CUSTOM ARGS START ]------------------------
# 
# 
# 
# ------------------------[ CUSTOM ARGS END   ]------------------------
        h) print_usage; exit 0 ;;
        :) echo "Option -$OPTARG requires an argument." >&2; print_usage; exit 1 ;;
        \?) echo "Invalid option: -$OPTARG" >&2; print_usage; exit 1 ;;
    esac
done

# ------------------------[ MAIN CODE START ]------------------------
# 
# 
# 
# ------------------------[ MAIN CODE END   ]------------------------

timer_end
log_info "Job finished successfully"