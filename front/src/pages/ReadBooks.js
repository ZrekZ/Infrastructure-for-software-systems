import React from "react";
import { useEffect, useState } from 'react';
import './Styles.css';
import axios from 'axios';
import { DataGrid } from '@mui/x-data-grid';
import KeyboardDoubleArrowRightIcon from '@mui/icons-material/KeyboardDoubleArrowRight';
import { IconButton} from '@mui/material';

const Height = 80 + 'vh'

const readBooksPath ="http://localhost:5000/api/v1/book/readBooks";
const toPlanned= "http://localhost:5000/api/v1/book/readBooks/moveToPlannedBooks"

function Title() {
    useEffect(() => {
      document.title = 'Прочитанные книги';
    }, []);
  }

export default function ReadBooks() {
  Title();
  let idx = 0;
  const columns = [
    { field: 'id', headerName: 'ID' },
    { field: 'name', headerName: 'Название книги', width: 400 },
    { field: 'author', headerName: 'Автор', width: 300 },
    { field: 'published', headerName: 'Год публикации', width: 200 },
    { field: 'lang', headerName: 'Язык', width: 200 },
    {
      field: "move",
      width: 75,
      sortable: false,
      disableColumnMenu: true,
      renderHeader: () => {
        return (
          <IconButton
            onClick={() => {
              MoveBook();
            }}
          >
            <KeyboardDoubleArrowRightIcon />
          </IconButton>
        );
      }
    }
  ]
  function MoveBook(){
    if (idx[0] !== undefined)
      axios.post(toPlanned+"/"+`${idx[0]}`)
  }
  function ReadBookData(){
    let path = "";
    const [book, setBook] = useState([]);
    console.log(path);
    useEffect(() => {
      axios.get(readBooksPath).then(data => setBook(data.data));
    }, []);
    console.log(book);
    if (book[0] !== undefined){
      return(
      <DataGrid
         rows={book}
         columns={columns}
         pageSize={12}
         style={{height: Height}}
         checkboxSelection
         onSelectionModelChange={(ids) => {
          idx=ids;
          console.log(idx)
        }}
       />
       )
    }
  }
  
  return (
      <div>
        <form action="" method="get">
        </form>
        <br/><ReadBookData/>
        <p/>
      </div>
  );
}