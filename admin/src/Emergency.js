import { useState } from "react";
import React from "react";
import { getFirestore, addDoc, collection, getDocs } from "firebase/firestore";
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';

const Emergency = () => {

    const [name, setName] = useState('');
    const [phone, setPhone] = useState('');

    const db = getFirestore();

    const saveDataToFirestore = async () => {
        const docRef = await addDoc(collection(db, "emegencyNumbers"), {
            name: name,
            phone: phone,
        });
        alert("Emergency contact added successfully");
    };

    return (
        <div className="container">
            <h2>Add Emergency Contacts</h2>
            <TextField
                required
                name="name"
                label="Name"
                type="text"
                value={name}
                onChange={(e) => setName(e.target.value)}
            />
            <TextField
                required
                name="Phone"
                label="Phone Number"
                type="text"
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
            />
            <Button variant="contained" type="submit" onClick={saveDataToFirestore}>Add Emergency Contact</Button>
        </div >
    );
};

export default Emergency;