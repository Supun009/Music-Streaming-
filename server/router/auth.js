const express = require("express");
const bcrypt = require("bcryptjs");
const User = require("../models/user");
const authRouter = express.Router();
const jwt = require("jsonwebtoken");
const auth = require("../middleware/authMiddle");

//sign up
authRouter.post("/api/signup", async (req, res) => {
    try {
        const {name, email, password} = req.body;

        const existingUser = await User.findOne({email});

        if (existingUser) {
            return res.status(400).json({msg: "User with same email aledy exists"});
        }

        const hashedPassword = await bcrypt.hash(password, 8);

        let user = new User({
            email, 
            password: hashedPassword,
            name,
        })

        user = await user.save();
        console.log(user)
        res.json(user);
    } catch (error) {
        res.status(500).json({error: e.message});
    }
});

authRouter.post("/api/login", async (req, res)=> {

    try {
        const {email, password} = req.body;
      
       
        const user = await User.findOne({email});
     
        if (!user) {
            return res.status(400).json({msg: "User eith this email not exist!"});
        }

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({msg: "Incorrect password"});
        }
        const token= jwt.sign({id: user._id}, "passwordkey");
        res.json({token, ...user._doc});

     } catch (e) {
        return res.status(500).json({error: e.message});
    }
});

authRouter.post("/tokenIsValid", async(req, res)=> {
try {
    const token = req.header("x-auth-token");
    if (!token) 
        return res.json(false);
    const verified = jwt.verify(token, 'passwordkey');
    if(!verified) return res.json(false);    

    const user = await User.findById(verified.id);
    if(!user) return res.json(false);
    res.json(true);
    
} catch (e) {
    res.status(500).json({error: emessage});
}
}
);


//get user data
authRouter.get('/', auth, async (req, res)=> {
    const user =await User.findById(req.user);
    res.json({...user._doc, token: req.token});
})

module.exports = authRouter;

