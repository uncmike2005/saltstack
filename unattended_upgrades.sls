install_unattended_upgrade:
  pkg.installed:
    - pkgs:
      - unattended-upgrades
      - update-notifier-common
  debconf.set:
    - name: unattended-upgrades
    - data:
        'unattended-upgrades/enable_auto_updates': {'type': 'boolean', 'value': 'true'}
  cmd.run:
    - name: sudo dpkg-reconfigure -f noninteractive --priority=low unattended-upgrades

enable_reboots:
  file.replace:
    - name: '/etc/apt/apt.conf.d/50unattended-upgrades'
    - pattern: '//Unattended-Upgrade::Automatic-Reboot "false";'
    - repl: 'Unattended-Upgrade::Automatic-Reboot "true"'
