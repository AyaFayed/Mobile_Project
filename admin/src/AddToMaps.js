import { useState } from "react";
import React from "react";
import { getFirestore, addDoc, collection, getDocs } from "firebase/firestore";
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';

const AddToMaps = () => {

    const [name, setName] = useState('');
    const [directions, setDirections] = useState('');
    const [mapUrl, setMapUrl] = useState('');

    const db = getFirestore();

    const saveDataToFirestore = async () => {
        const docRef = await addDoc(collection(db, "locations"), {
            directions: directions,
            mapUrl: mapUrl,
            name: name
        });
        alert("Location added to maps successfully");
    };

    return (
        <div className="container">
            <h2>Add Location to Maps</h2>
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
                name="directions"
                label="Directions"
                type="text"
                value={directions}
                onChange={(e) => setDirections(e.target.value)}
            />
            <TextField
                required
                name="mapUrl"
                label="Map Url"
                type="url"
                value={mapUrl}
                onChange={(e) => setMapUrl(e.target.value)}
            />
            <Button variant="contained" type="submit" onClick={saveDataToFirestore}>Add Location to Maps</Button>
        </div >
    );
};

export default AddToMaps;