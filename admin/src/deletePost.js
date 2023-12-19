import { useState, useEffect } from "react";
import React from "react";
import { getFirestore, addDoc, collection, getDocs, updateDoc, doc, deleteDoc } from "firebase/firestore";
import Button from '@mui/material/Button';
import {
    getDownloadURL,
    getStorage,
    ref
} from "firebase/storage";

const DeletePost = () => {

    const [posts, SetPosts] = useState([])
    const db = getFirestore();
    const storage = getStorage();
    const fetchDataFromFirestore = async () => {
        const querySnapshot = await getDocs(collection(db, "posts"));
        const queryUsers = await getDocs(collection(db, "users"));
        const users = []
        const res = []
        queryUsers.forEach((d) => {
            users.push({ doc_id: d.id, ...d.data() });
        });
        // console.log(storage)
        console.log(querySnapshot)

        querySnapshot.forEach(async (d) => {
            // console.log('data', d)
            const tmpUsers = users
            var userHandle = ""
            var imageUrl = ""
            if (tmpUsers.filter(u => u.doc_id == d.data().authorId).length > 0)
                userHandle = tmpUsers.filter(u => u.doc_id == d.data().authorId)[0].handle;
            // if (d.data().file)
            //     imageUrl = await getDownloadURL(ref(storage, d.data().file));
            res.push({ doc_id: d.id, userHandle: userHandle, ...d.data() });
        })
        // console.log(res)
        const reported = res.filter(post => post.reporters.length > 0)
        const reportedWithImage = []
        console.log(reported)
        for (let index = 0; index < reported.length; index++) {
            const d = reported[index]
            console.log(d)
            var imageUrl = ""
            if (d.file)
                imageUrl = await getDownloadURL(ref(storage, d.file));
            // console.log(imageUrl)
            d.imageUrl = imageUrl
            // console.log('res before: ', res);
            reportedWithImage.push(d);
            // console.log('res after: ', res);
        }
        console.log(reportedWithImage)
        SetPosts(reportedWithImage.sort((a, b) => b.reporters.length - a.reporters.length));
        // console.log(reported)

    };
    useEffect(() => {
        fetchDataFromFirestore()
    }, [])

    function HandleDelete(doc_id) {
        console.log(doc_id)
        const docRef = doc(db, "posts", doc_id);
        deleteDoc(docRef)
            .then(res => {
                fetchDataFromFirestore()
                alert("Post Deleted Successfully")
            }).catch(error => {
                console.log(error.message)
            })
    }

    return (
        <div className="container">
            <h2>Delete Repoted Posts</h2>
            {posts && posts.map((p) => (
                <div className="card">
                    <p>Number of reports: {p.reporters.length}</p>
                    <p>{p.anonymous ? "Anonymous User" : "User Handle: " + p.userHandle}</p>
                    <p>Category: {p.category}</p>
                    <p>content: {p.content}</p>
                    <p>Number of upvotes: {p.upVoters.length}, Number of downvotes: {p.downVoters.length}</p>
                    {p.imageUrl != "" && <img src={p.imageUrl} />}
                    <Button variant="contained" color="error" type="submit" onClick={() => HandleDelete(p.doc_id)}>Delete Post</Button>
                </div>
            ))}
        </div >
    );
};

export default DeletePost;