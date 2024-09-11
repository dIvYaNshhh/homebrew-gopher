class GopherSecurity < Formula
    desc "Gopher Security application"
    homepage "https://www.gopher.security"
    url "https://s3.amazonaws.com/public.gopher.security/apps/release/darwin/GopherSecurity-darwin-0.0.2-15-amd64-release.pkg"
    sha256 "e0e640d5f8077f6af8026ee7bef9fc90df8b6aabc78164f3713eae70532dc213"
    version "0.0.2-15"
  
    def install
      ENV["HOMEBREW_USER"] = Shell.current_user  # Avoid prompting for password
  
      system "/usr/sbin/installer", "-pkg", "#{cached_download}", "-target", "/"
  
      bin.install_symlink "/Applications/GopherSecurity/GopherSecurity.app/Contents/MacOS/gopher_security" => "gopher-security" if File.exist?("/Applications/GopherSecurity/GopherSecurity.app/Contents/MacOS/gopher_security")
  
      # Check for and symlink any additional executables
      Dir.glob("/Applications/GopherSecurity/GopherSecurity.app/Contents/MacOS/*").each do |file|
        if File.executable?(file) && !File.directory?(file)
          bin.install_symlink file => File.basename(file).downcase.gsub("_", "-")
        else
          # Optional: Log a message if an expected executable is missing
          ohai "Executable not found: #{file}"
        end
      end
    end
  
    def post_install
      ohai "Installation complete. You can start GopherSecurity by running 'gopher-security' or opening the application from /Applications/GopherSecurity/GopherSecurity.app"
    end
  
    def uninstall
      system "rm", "-rf", "/Applications/GopherSecurity"
      system "pkgutil", "--forget", "gopher.security.app"
    end
  
    def caveats
      <<~EOS
        GopherSecurity has been installed:
  
        - The main application is located at:
          /Applications/GopherSecurity/GopherSecurity.app
  
        - The main executable has been symlinked to #{HOMEBREW_PREFIX}/bin as:
          gopher-security
  
        To start GopherSecurity, you can:
        1. Open /Applications/GopherSecurity/GopherSecurity.app
        2. Run 'gopher-security' in your terminal
  
        To uninstall, run:
          brew uninstall gopher-security
  
        Note: This formula requires sudo access for uninstallation.
      EOS
    end
  end