# Displays opened ports as a tab in host details
Deface::Override.new(
  :virtual_path => 'hosts/show',
  :name => 'open_ports_tab',
  :surround_contents => 'ul.nav.nav-tabs',
  :partial => 'foreman_probing/probing_facets/open_ports_tab_title',
)

Deface::Override.new(
  :virtual_path => 'hosts/show',
  :name => 'open_ports_content',
  :surround_contents => 'div.tab-content',
  :partial => 'foreman_probing/probing_facets/open_ports_tab_content',
)
