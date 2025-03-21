local audio_manager = require("src.audio.audiomanager")


return function(args)
  audio_manager.play_sfx(args.sound)
end
