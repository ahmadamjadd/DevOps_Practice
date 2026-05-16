#! /usr/bin/bash

curr_date="$(date +"%A, %b %Y")"
echo -e "$curr_date\n"

# Memory summary: total, used %, and available % for RAM and swap.
total_mem=$(free -h | awk 'NR==2 { print $2 }')
swap_mem=$(free -h | awk '/Swap:/ { print $2 }')
echo -e "Total Memory: $total_mem, Swap Memory: $swap_mem\n"

per_mem=$(free | awk '/Mem:/ { printf("%.2f", ($3/$2)*100) }')
per_swap=$(free | awk '/Swap:/ { printf("%.2f", ($3/$2)*100) }')
echo -e "Percentage Mem: ${per_mem}%, Percentage Swap: ${per_swap}%"

avai_mem=$(free | awk '/Mem:/ { printf("%.2f", ($4/$2)*100) }')
avai_swap=$(free | awk '/Swap:/ { printf("%.2f", ($4/$2)*100) }')
echo -e "Available Mem: ${avai_mem}%, Available Swap: ${avai_swap}%"

t_disk=$(df -h --total | awk '/total/ { printf($2) }')
t_disk_used=$(df -h --total | awk '/total/ { printf($3) }')
t_disk_avail=$(df -h --total | awk '/total/ { printf($4) }')

df -h --exclude="tmpfs" | tail -n +2 | while read -r line; do
    disk_name=$(echo "$line" | awk '{print $1}')
    space_used=$(echo "$line" | awk '{print $3}')
    space_avail=$(echo "$line" | awk '{print $4}')

    echo "Disk Name: $disk_name"
    echo "Space Used: $space_used"
    echo "Space Available: $space_avail"
    echo "--------------------------"
done

cat <<EOF > system_health.html
<!DOCTYPE html>
<html>
<head>
    <title>System Health Report</title>
    <style>
        table, th, td { border: 1px solid black; border-collapse: collapse; padding: 5px; }
    </style>
</head>
<body>
    <h1>System Health Report</h1>
    <p>Generated on: $curr_date</p>

    <h3>Memory Usage - Last 5 Minutes</h3>
    <table>
        <tr><th>Total</th><th>Used</th><th>Available</th></tr>
        <tr><td>$total_mem</td><td>$per_mem%</td><td>$avai_mem%</td></tr>
    </table>

    <h3>Swap Memory - Last 5 Minutes</h3>
    <table>
        <tr><th>Total</th><th>Used</th><th>Available</th></tr>
        <tr><td>$swap_mem</td><td>$per_swap%</td><td>$avai_swap%</td></tr>
    </table>

    <h3>Disk Usage - Last 5 Minutes</h3>
    <table>
        <tr><th>Total</th><th>Used</th><th>Available</th></tr>
        <tr><td>$t_disk</td><td>$t_disk_used</td><td>$t_disk_avail</td></tr>
    </table>

    <h3>Disk Partition Details - Last 5 Minutes</h3>
    <table>
        <tr><th>Disk</th><th>Used</th><th>Available</th></tr>
$(df -h --exclude="tmpfs" | tail -n +2 | awk '{print "        <tr><td>"$1"</td><td>"$3"</td><td>"$4"</td></tr>"}')
    </table>

    <p style="text-align: right;">Designed by: u2023361</p>
</body>
</html>
EOF

sudo cp system_health.html /var/www/html/index.html

if [ $? -eq 0 ]; then
    echo "Success: System health report hosted successfully."
else
    echo "Error: Failed to host the system health report."
    exit 1
fi




