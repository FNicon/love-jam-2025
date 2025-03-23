return {
  bgm = {
    dungeon = love.audio.newSource("assets/audio/bgm/dungeon.mp3", "stream"),

  },
  sfx = {
    door = love.audio.newSource("assets/audio/sfx/door.wav", "static"),
    next_level = love.audio.newSource("assets/audio/sfx/next_level.wav", "static"),
    progress = love.audio.newSource("assets/audio/sfx/progress.wav", "static"),
    connect = love.audio.newSource("assets/audio/sfx/connect.wav", "static"),
    death = love.audio.newSource("assets/audio/sfx/death.wav", "static"),
    hurt = love.audio.newSource("assets/audio/sfx/hurt.wav", "static"),
  }
}
