pidfile=/tmp/keep_alive_pid

if [ -f "$pidfile" ] && kill -0 `cat $pidfile` 2>/dev/null; then
    exit 0
fi

while true; do
  touch /workspaces/.codespaces/shared/active-clients-monitor.json
  sleep 1
done

echo $$ > $pidfile
