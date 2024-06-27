const express = require("express");
require('dotenv').config();
const songRouter = express.Router();
const { v2: cloudinary } = require('cloudinary');
const multer = require('multer');
const Song = require("../models/songs");
const auth = require("../middleware/authMiddle");


// Multer configuration
const storage = multer.diskStorage({});
const upload = multer({ storage });


 // Configuration
 cloudinary.config({ 
    cloud_name: 'dom13qzxw', 
    api_key: '685273119724126', 
    api_secret: `bBsb3pNEiNaWsojP216fMAACHgo` // Click 'View Credentials' below to copy your API secret
});



// Route to handle file upload
songRouter.post('/upload', upload.single('song'), async (req, res) => {
    try {
      if (!req.file) {
        return res.status(400).send('No file uploaded.');
      }
      console.log(req.file);
  
      // Upload file to Cloudinary
      cloudinary.uploader.upload(req.file.path, { folder: 'uploads', resource_type: 'auto' }, async(error, result) => {
        if (error) {
          console.error('Cloudinary upload error:', error);
          return res.status(500).json({ error: 'Cloudinary upload error' });
        }

        const songUrl = result.secure_url;

        let song = new Song({
           name : "pemwanthi",
           songUrl : songUrl,
           imageUrl : 'https://res.cloudinary.com/dom13qzxw/image/upload/v1719317124/uploads/ws7dcxzq27b7id8pxefm.jpg',
            
        })

        // Save song object to MongoDB
      try {
        const savedSong = await song.save();
        console.log('Song saved:', savedSong);
        res.status(200).json({ url: songUrl });
      } catch (saveError) {
        console.error('MongoDB save error:', saveError);
        res.status(500).json({ error: 'Failed to save song to MongoDB' });
      }
      
    });   
    //     // Respond with the URL of the uploaded image
    //     res.status(200).json({ url: result.secure_url });
    //   });
    } catch (err) {
      console.error('Server error:', err);
      res.status(500).json({ error: 'Server error' });
    }
  });

  songRouter.get('/list', auth, async(req, res)=> {
    try {
      const songs = await Song.find({});
    res.status(200).json(songs);
    } catch (error) {
      console.error(error);
    res.status(500).send('Error fetching songs');
    }
    
  })



module.exports = songRouter;