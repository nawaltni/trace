extract-db:
    @echo "Extracting database..."
    @adb -d shell "run-as com.nawalt.trace cat /data/data/com.nawalt.trace/databases/trace_survey.db" > data.sqlite
