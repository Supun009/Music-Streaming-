const mongoose = require("mongoose");

const songSchema = mongoose.Schema({
    name: {
        require: true,
        type: String,
        trim: true
    },
    songUrl: {
        require: true,
        type: String,
        trim: true
    },

    imageUrl: {
        require: true,
        type: String,
        trim: true
    }
}

);

const Song = mongoose.model("Song", songSchema);

module.exports = Song;