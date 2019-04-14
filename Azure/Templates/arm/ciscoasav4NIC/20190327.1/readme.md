ssh into public IP of firewall copy base config.

Configure the ASA with a config like:

      Interface Management0/0
        nameif outside
        security-level 99
        http server enable
http 0.0.0.0 0.0.0.0 outside

      same-security-traffic permit intra-interface
      Interface GigabitEthernet0/0
        no shutdown
        nameif CoreToSpokes
        ip address dhcp 
      dhcp-client client-id interface CoreToSpokes
      Interface GigabitEthernet0/0
        security-level 0
        http server enable
http 0.0.0.0 0.0.0.0 CoreToSpokes

      access-list CoreToSpokes_access_in line 1 extended permit ip any any 
      nat (CoreToSpokes,outside) 1 source dynamic any interface
      access-group CoreToSpokes_access_in in interface CoreToSpokes

      object network jumpbox01
        host 10.10.10.5
      object service RDP33891
        service tcp destination eq 33891
      object service RDP
        service tcp destination eq 3389
      access-list outside_access_in line 1 extended permit object RDP any object jumpbox01 
      nat (outside,CoreToSpokes) 2 source static any any destination static interface jumpbox01 service RDP33891 RDP net-to-net no-proxy-arp
      access-group outside_access_in in interface outside