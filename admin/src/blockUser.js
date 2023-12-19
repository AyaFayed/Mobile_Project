import { useState, useEffect } from "react";
import React from "react";
import { getFirestore, addDoc, collection, getDocs, updateDoc, doc, deleteDoc } from "firebase/firestore";
import Button from '@mui/material/Button';

const BlockUser = () => {

    const [users, SetUsers] = useState([])
    const db = getFirestore();

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

    function HandleBlock(doc_id) {
        console.log(doc_id)
        const docRef = doc(db, "users", doc_id);
        console.log(docRef)
        updateDoc(docRef, {
            blocked: true
        }).then(response => {
            fetchDataFromFirestore()
            alert("User Blocked Successfully")
        }).catch(error => {
            console.log(error.message)
        })
        // deleteDoc(docRef)
        //     .then(res => {
        //         fetchDataFromFirestore()
        //         alert("User Blocked Successfully")
        //     }).catch(error => {
        //         console.log(error.message)
        //     })
    }

    return (
        <div className="container">
            <h2>Block Users</h2>
            <h4>Blocked User can't write posts or comments but can view them</h4>
            {users && users.map((u) => (
                <div className="card">
                    <p>Handle: {u.handle}</p>
                    <p>Name: {u.name}</p>
                    <p>Type: {u.type}</p>
                    <Button variant="contained" color="error" type="submit" onClick={() => HandleBlock(u.doc_id)}>Block User</Button>
                </div>
            ))}
        </div >
    );
};

export default BlockUser;