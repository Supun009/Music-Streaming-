const express = require("express");
require('dotenv').config();
const mongoose = require("mongoose");
const authRouter = require("./router/auth");
const songRouter = require("./router/song");



const PORT = process.env.PORT || 3001;

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(authRouter);
app.use(songRouter);

app.get("/test", (req, res) => {
    res.send("Server is working!");
  });
  

const DB = `${process.env.DB}`

mongoose.connect(DB).then(()=> {
    console.log("DB connected");
}).catch((e)=> {
    console.log(e)
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`server connected in ${PORT}`);
})

