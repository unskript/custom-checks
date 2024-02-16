FROM unskript/awesome-runbooks:minimal-1.5.18 as base
COPY custom/actions/. /tmp/custom/actions/
COPY custom/runbooks/. /tmp/custom/runbooks/

COPY lb_pvc.sh /usr/local/bin/lb_pvc.sh
RUN chmod +x /usr/local/bin/lb_pvc.sh

# Copy the unskript_ctl_config.yaml file.
# Uncomment the below line to copy it to the docker.
COPY unskript_ctl_config_custom.yaml /etc/unskript/unskript_ctl_config.yaml
#COPY unskript_ctl_config_custom.yaml /etc/unskript/unskript_ctl_config.yaml
#COPY unskript_ctl_config_parser.py /usr/local/bin/unskript_ctl_config_parser.py
#COPY unskript_ctl.py /usr/local/bin/unskript_ctl.py
#COPY unskript_ctl_gen_report.py /usr/local/bin/unskript_ctl_gen_report.py
#COPY utils.py /usr/local/bin/utils.py
#COPY bash_completion_unskript_ctl.bash /usr/local/bin/bash_completion_unskript_ctl.bash
#COPY start.sh . 
#RUN chmod +x ./start.sh
CMD ["./start.sh"]
