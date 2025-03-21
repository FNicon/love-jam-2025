local audio = require("assets/audio")

local audio_manager = {}

function audio_manager.load_bgm(bgm_name, is_play_bgm)
  audio.bgm[bgm_name]:setLooping(true)
  if (is_play_bgm) then
    audio.bgm[bgm_name]:play()
  end
end

function audio_manager.play_sfx(sfx_name)
  audio.sfx[sfx_name]:play()
end

return audio_manager
