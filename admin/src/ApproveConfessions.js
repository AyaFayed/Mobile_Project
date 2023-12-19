import { useEffect, useState } from "react";
import React from "react";
import { getFirestore, addDoc, collection, getDocs, updateDoc, doc, deleteDoc } from "firebase/firestore";
import Button from '@mui/material/Button';

const ApproveConfessions = () => {

    const [confessions, SetConfessions] = useState([])
    const db = getFirestore();

    const fetchDataFromFirestore = async () => {
        const querySnapshot = await getDocs(collection(db, "posts"));
        const queryUsers = await getDocs(collection(db, "users"));
        const users = []
        const res = []
        queryUsers.forEach((d) => {
            users.push({ doc_id: d.id, ...d.data() });
        });
        querySnapshot.forEach((d) => {
            const tmpUsers = users
            var userHandle = ""
            if (tmpUsers.filter(u => u.doc_id == d.data().authorId).length > 0)
                userHandle = tmpUsers.filter(u => u.doc_id == d.data().authorId)[0].handle;
            console.log(userHandle)
            console.log(users)
            res.push({ doc_id: d.id, userHandle: userHandle, ...d.data() });
        });
        console.log(res)
        SetConfessions(res.filter(post => post.category == 'confession' && !post.approved));
        console.log(confessions)
    };
    useEffect(() => {
        fetchDataFromFirestore()
    }, [])

    function HandleApprove(doc_id) {
        console.log(doc_id)
        const postsCollection = doc(db, 'posts', doc_id)
        updateDoc(postsCollection, {
            approved: true
        }).then(response => {
            fetchDataFromFirestore()
            alert("Confession Approved Successfully")
        }).catch(error => {
            console.log(error.message)
        })
    }

    function HandleDelete(doc_id) {
        console.log(doc_id)
        const docRef = doc(db, "posts", doc_id);
        console.log(docRef)
        deleteDoc(docRef)
            .then(res => {
                fetchDataFromFirestore()
                alert("Confession Deleted Successfully")
            }).catch(error => {
                console.log(error.message)
            })
    }

    return (
        <div className="container">
            <h2>Review Confessions</h2>
            {confessions && confessions.map((c) => (
                <div className="card">
                    <p>{c.anonymous ? "Anonymous User" : "User Handle: " + c.userHandle}</p>
                    <p>content: {c.content}</p>
                    <Button variant="contained" color="success" type="submit" onClick={() => HandleApprove(c.doc_id)}>Approve Confession</Button>
                    <Button variant="contained" color="error" type="submit" onClick={() => HandleDelete(c.doc_id)}>Delete Confession</Button>
                </div>
            ))}
        </div >
    );
};

export default ApproveConfessions;