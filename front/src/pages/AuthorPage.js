import {
    BrowserRouter as Router,
    Link,
    Route,
    Routes,
    useParams,
  } from "react-router-dom";

export default function AuthorPage(){
    const { id } = useParams();
    return(
        <div>
        <input readOnly>{id}</input>
        </div>
    )
}