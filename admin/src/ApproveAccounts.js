import { useState, useEffect } from "react";
import React from "react";
import { getFirestore, addDoc, collection, getDocs, updateDoc, doc } from "firebase/firestore";
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';

const ApproveAccounts = () => {

    const [handle, setHandle] = useState('');
    const [name, setName] = useState('');
    const [users, SetUsers] = useState([])
    const [selected, SetSelected] = useState('')
    const [selectedId, SetSelectedId] = useState('')

    const fetchDataFromFirestore = async () => {
        const querySnapshot = await getDocs(collection(db, "users"));
        const res = [];
        querySnapshot.forEach((doc) => {
            res.push({ doc_id: doc.id, ...doc.data() });
        });
        SetUsers(res.filter(user => !user.blocked));
        console.log(users)
    };
    useEffect(() => {
        fetchDataFromFirestore()
    }, [])

    const db = getFirestore();

    function HandleSubmit() {

        console.log(selectedId)
        const docRef = doc(db, "users", selectedId);
        console.log(docRef)
        updateDoc(docRef, {
            handle: handle,
            name: name,
            type: 'club'
        }).then(response => {
            fetchDataFromFirestore()
            SetSelected('')
            SetSelectedId('')
            setName('')
            setHandle('')
            alert("Approved Account added successfully")
        }).catch(error => {
            console.log(error.message)
        })
    };


    return (
        <div className="container">
            <h2>Approve Account</h2>
            <h4>This account will be marked as a club with a changed name and handle</h4>
            <TextField
                required
                name="handle"
                label="New Handle"
                type="text"
                value={handle}
                onChange={(e) => setHandle(e.target.value)}
            />
            <TextField
                required
                name="name"
                label="New Name"
                type="text"
                value={name}
                onChange={(e) => setName(e.target.value)}
            />
            {users && users.map((u) => (
                <div>
                    {u.type != 'club' && <div className="card">
                        <p>Handle: {u.handle}</p>
                        <p>Name: {u.name}</p>
                        <p>Type: {u.type}</p>
                        <Button variant="contained" onClick={() => { SetSelected(u.handle); SetSelectedId(u.doc_id) }}>Select User</Button>
                    </div>}
                </div>


            ))}
            {selected != "" && <p>Selected User: {selected}</p>}
            <Button variant="contained" type="submit" onClick={HandleSubmit}>Approve Account</Button>
        </div >
    );
};

export default ApproveAccounts;