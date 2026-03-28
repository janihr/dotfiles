{ pkgs, ... }: {

  # 1. CUPS Druckdienst aktivieren
  services.printing = {
    enable = true;
    # Optionale Standard-Treiberpakete für bessere Kompatibilität
    drivers = with pkgs; [ cups-filters ]; 
  };

  # 2. Avahi für die automatische Druckererkennung (mDNS/Zeroconf) aktivieren
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    # Wichtig: Port 5353 für Discovery öffnen
    openFirewall = true;
  };
}
