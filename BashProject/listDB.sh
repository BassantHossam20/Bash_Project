# Check for directories (databases) inside ./DATABASES
if ls -F ./DATABASES | grep '/$' > /dev/null; then
    ls -F ./DATABASES | grep '/$'
else
    echo "No databases available"
fi