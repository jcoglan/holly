module Holly
  PUBLIC_DIR = $holly_test_path || RAILS_ROOT.gsub(/\/$/, "") + "/public"
  SCRIPT_DIR = PUBLIC_DIR + "/javascripts"
end
