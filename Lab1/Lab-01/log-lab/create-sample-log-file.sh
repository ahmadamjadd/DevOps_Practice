for i in {1..30}; do
  echo "$(date) INFO Request processed successfully - ID $i" >> app.log
done

echo "$(date) WARN Disk usage is above 80%" >> app.log
echo "$(date) ERROR Failed to connect to database" >> app.log

for i in {31..50}; do
  echo "$(date) INFO Request processed successfully - ID $i" >> app.log
done
