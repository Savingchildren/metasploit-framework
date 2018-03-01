#
# $Id$
#
# This plugin provides integration with Rapid7 Komand
#
# $Revision$
#

require 'uri'
require 'net/http'


module Msf

class Plugin::Komand < Msf::Plugin

    ###
    #
    # This class implements a Komand command dispatcher.
    #
    ###
    class KomandCommandDispatcher
        include Msf::Ui::Console::CommandDispatcher

        #
        # The dispatcher's name.
        #
        def name
            "Komand"
        end

        #
        # Returns the hash of commands supported by this dispatcher.
        #
        def commands 
            {
                'send_asset' => "Send an asset to komand"
            }
        end

        #
        # This method handles sending assets to Komand
        #
        def cmd_send_asset(*args)
            
            if args.length < 3 || args.length > 3
                print_line("Invalid arguments passed, format is \'send_asset <url> <api_key> <asset>\'")
            else
                url_trigger = args[0]
                api_key = args[1]
                asset = args[2]
    
                url = URI(url_trigger)
    
                http = Net::HTTP.new(url.host, url.port)
    
                request = Net::HTTP::Post.new(url)
                request["authorization"] = api_key
                request.body = asset
    
                response = http.request(request)
                puts response.read_body
            end
        end
    end

    #
    # Plugin initialization
    #

    def initialize(framework, opts)
        super

        add_console_dispatcher(KomandCommandDispatcher)
        banner = ["202f24242020202f24242020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202f24240a7c20242420202f24242f20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020207c2024240a7c202424202f24242f2020202f24242424242420202f2424242424242f242424242020202f24242424242420202f242424242424242020202f242424242424240a7c2024242424242f2020202f24245f5f202024247c2024245f202024245f20202424207c5f5f5f5f202024247c2024245f5f20202424202f24245f5f202024240a7c2024242020242420207c20242420205c2024247c202424205c202424205c20242420202f242424242424247c20242420205c2024247c20242420207c2024240a7c2024245c20202424207c20242420207c2024247c202424207c202424207c202424202f24245f5f202024247c20242420207c2024247c20242420207c2024240a7c202424205c202024247c20202424242424242f7c202424207c202424207c2024247c2020242424242424247c20242420207c2024247c2020242424242424240a7c5f5f2f20205c5f5f2f205c5f5f5f5f5f5f2f207c5f5f2f207c5f5f2f207c5f5f2f205c5f5f5f5f5f5f5f2f7c5f5f2f20207c5f5f2f205c5f5f5f5f5f5f5f2f0a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020"].pack("H*")

        # Do not use this UTF-8 encoded high-ascii art for non-UTF-8 or windows consoles
        lang = Rex::Compat.getenv("LANG")
        if (lang and lang =~ /UTF-8/)
        # Cygwin/Windows should not be reporting UTF-8 either...
        # (! (Rex::Compat.is_windows or Rex::Compat.is_cygwin))
        banner = ["202f24242020202f24242020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202f24240a7c20242420202f24242f20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020207c2024240a7c202424202f24242f2020202f24242424242420202f2424242424242f242424242020202f24242424242420202f242424242424242020202f242424242424240a7c2024242424242f2020202f24245f5f202024247c2024245f202024245f20202424207c5f5f5f5f202024247c2024245f5f20202424202f24245f5f202024240a7c2024242020242420207c20242420205c2024247c202424205c202424205c20242420202f242424242424247c20242420205c2024247c20242420207c2024240a7c2024245c20202424207c20242420207c2024247c202424207c202424207c202424202f24245f5f202024247c20242420207c2024247c20242420207c2024240a7c202424205c202024247c20202424242424242f7c202424207c202424207c2024247c2020242424242424247c20242420207c2024247c2020242424242424240a7c5f5f2f20205c5f5f2f205c5f5f5f5f5f5f2f207c5f5f2f207c5f5f2f207c5f5f2f205c5f5f5f5f5f5f5f2f7c5f5f2f20207c5f5f2f205c5f5f5f5f5f5f5f2f0a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020"].pack("H*")
        end
        print("\n" + banner + "\n")
        print_status("Komand integration has been activated")
    end

    def cleanup
        remove_console_dispatcher('Komand')
    end

    def name
        "komand"
    end

    def desc
        "Integrates with the Rapid7 Komand product"
    end
end
end
