module Learn
  class CLI < Thor
    desc '[test] [options]', "Run a lesson's test suite"
    long_desc <<-LONGDESC
      `learn [test] [options]` will run your lesson's test suite.

      You can supply the following options when running Jasmine tests:

      --no-color            # Turn off color output
      \x5 -l, --local       # Don't push results to Learn
      \x5 -b, --browser     # Run tests in browser
      \x5 -o, --out FILE    # Specify an output file
      \x5 -s, --skip        # Don't run dependency checks

      You can supply the following options when running Rspec tests:

      --fail-fast           # Stop running rspec test suite on first failed test
    LONGDESC
    def test(*opts)
      exec("learn-test #{opts.join(' ')}")
    end

    desc 'version, -v, --version', 'Display the current version of the Learn gem'
    def version
      puts Learn::VERSION
    end

    desc 'submit [-m|--message "message"] [-t|--team @username @username2]', 'Submit your completed lesson'
    option :message, required: false, type: :string, aliases: ['m']
    option :team,    required: false, type: :string, aliases: ['t']
    long_desc <<-LONGDESC
      `learn submit [-m|--message "message"] [-t|--team @username, @username2]` will submit your lesson to Learn.

      If you provide the -t|--team flag, specified team memebers will also get credit.

      It will add your changes, commit them, push to GitHub, and issue a pull request.
    LONGDESC
    def submit(*opts)
      commit_message = if options['team']
        Learn::TeamMembers::Parser.new(ARGV).execute
      else
        options['message']
      end

      exec("learn-submit #{commit_message}")
    end

    desc "open [lesson-name] [--editor=editor-binary]", "Open your current lesson [or the given lesson] [with your editor]"
    long_desc <<-LONGDESC
      `learn open [lesson-name] [--editor=editor-binary]` will open a Learn lesson locally.

      If given no lesson name, it will open your current lesson. By default, it will open
      using the editor specified in ~/.learn-config.

      If the lesson is an iOS lab, it will open in Xcode. If it is a README, it will open the lesson
      in your browser.
    LONGDESC
    option :editor, required: false, type: :string, aliases: ['e']
    option :"clone-only", required: false, type: :boolean
    def open(*lab_name)
      lab_name = Learn::Lab::Parser.new(lab_name.join(' ')).parse!
      editor = options[:editor]
      clone_only = options[:"clone-only"]

      command = "learn-open #{lab_name} --editor=#{editor}"
      command << " --clone-only" if clone_only

      exec(command)
    end

    desc "next [--editor=editor-binary]", "Open your next lesson [with your editor]"
    option :editor, required: false, type: :string, aliases: ['e']
    option :"clone-only", required: false, type: :string
    def next
      editor = options[:editor]
      clone_only = options[:"clone-only"]

      command = "learn-open --next --editor=#{editor}"
      command << " --clone-only" if clone_only

      exec(command)
    end

    desc 'whoami', 'Display your Learn gem configuration information'
    def whoami
      exec('learn-config --whoami')
    end

    desc 'reset', 'Reset your Learn gem configuration'
    def reset
      exec('learn-config --reset')
    end

    desc 'directory', 'Set your local Learn directory. Defaults to ~/Development/code'
    def directory
      exec('learn-config --set-directory')
    end

    desc 'new lab-name -t|--template template-name', 'Generate a new lesson repo using a Learn.co template', hide: true
    option :template, required: false, type: :string, aliases: ['t']
    option :list, required: false, type: :boolean
    def new(*lab_name)
      has_internet = Learn::InternetConnection.internet_connection?
      template = options[:template]
      list = options[:list]

      if list
        exec("learn-generate --list #{has_internet ? '--internet' : ''}")
      else
        if template && template != 'template'
          exec("learn-generate #{template} #{lab_name.join} #{has_internet ? '--internet' : ''}")
        else
          puts "You must specify a template with -t or --template"
          exit
        end
      end
    end

    desc 'status', 'Get the status of your current lesson'
    def status
      exec('learn-status')
    end

    desc 'hello', 'Verify your connection to Learn.co'
    def hello
      exec('learn-hello')
    end

    desc 'lint', 'Lint a directory for correct content', hide: true
    def lint(dir=nil, quiet=nil)
      if dir && !quiet
        exec("learn-lint #{dir}")
      elsif dir && quiet
        exec("learn-lint #{dir} #{quiet}")
      elsif !dir && quiet
        exec("learn-lint #{quiet}")
      else
        current_dir = Dir.pwd
        exec("learn-lint #{current_dir}")
      end
    end

    desc 'save', 'Save your work and push it to GitHub'
    def save
      if !system('learn-submit --save-only')
        exit 1
      end
    end
  end
end
