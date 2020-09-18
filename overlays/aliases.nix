self: super: {
  # This is already in the upstream pkgconf map, but is also needed in
  # the system packages map.
  odbc = self.unixODBC;
}
