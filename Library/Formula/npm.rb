require 'formula'

class Npm <Formula
  url 'http://github.com/isaacs/npm/tarball/v0.1.19'
  head 'git://github.com/isaacs/npm.git'
  homepage 'http://github.com/isaacs/npm'
  md5 '7a32ae417e4814442332524c66f923a9'

  depends_on 'node'

  def executable
    <<-EOS
#!/bin/sh
exec "#{libexec}/cli.js" "$@"
    EOS
  end

  def install
    doc.install Dir["doc/*"]
    prefix.install ["LICENSE", "README.md"]

    # install all the required libs in libexec so `npm help` will work
    libexec.install Dir["*"]

    # add "npm-" prefix to man pages link them into the libexec man pages
    man1.mkpath
    Dir.chdir libexec+"man" do
      Dir["*"].each do |file|
        if file == "npm.1"
          ln_s "#{libexec}/man/#{file}", man1
        else
          ln_s "#{libexec}/man/#{file}", "#{man1}/npm-#{file}"
        end
      end
    end

    # install the wrapper executable
    (bin+"npm").write executable
  end
end
