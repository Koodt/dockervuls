# dockervuls
Dockerfile for VULS at cron without root permissions

# needed crontab file and scripts directory
docker run -it --rm --name vuls -v /vuls/:/vuls/:rw -v /tmp/scripts/:/tmp/crontab/scripts/:rw -v /tmp/crontab:/tmp/crontab/crontab:rw vuls
