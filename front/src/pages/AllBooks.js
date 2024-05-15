import React from "react";
import { useEffect, useState } from 'react';
import './Styles.css';
import axios from 'axios';
import DeleteOutlinedIcon from '@mui/icons-material/DeleteOutlined';
import { DataGrid, GridRowEditStopReasons} from '@mui/x-data-grid';
import { IconButton} from '@mui/material';

const Height = 80 + 'vh'

const allBookPath = "http://localhost:5000/api/v1/book/books";

let idx=0;

let find="";


function Title() {
  useEffect(() => {
    document.title = 'Книги';
  }, []);
}

export default function Books() {
  Title();
  let idx=0;

const columns = [
  { field: 'id', headerName: 'ID' },
    { field: 'name', headerName: 'Название книги', width: 400, editable: true },
    { field: 'author', headerName: 'Автор', width: 300, editable: true },
    { field: 'published', headerName: 'Год публикации', width: 200, editable: true },
    { field: 'lang', headerName: 'Язык', width: 200, editable: true },
    
  {
    field: "delete",
    width: 75,
    sortable: false,
    disableColumnMenu: true,
    renderHeader: () => {
      return (
        <IconButton
          onClick={() => {
            DeleteRow();
          }}
        >
          <DeleteOutlinedIcon />
        </IconButton>
      );
    }
  }
]

function DeleteRow(){
  let err;
  axios.delete(allBookPath+`/${idx[0]}/delete`).catch(function (error) { err = error;})
  console.log(idx)
  window.location.reload()
}

function BookData(){
  const [book, setBook] = useState([]);
  useEffect(() => {
    axios.get(allBookPath).then(data => setBook(data.data));
  }, []);
  console.log(book);

  function processRowUpdate(newRow, oldRow){
    SetData(newRow, oldRow)
    return(newRow)
  }

  function SetData(newRow, oldRow){
    console.log(newRow.author)
    console.log(allBookPath+`/${oldRow.id}`)
        axios.put(allBookPath+`/${oldRow.id}`, {
        name: newRow.name,
        lang_name: newRow.lang,
        year: newRow.published,
        author_spec: newRow.author,
    })
    window.location.reload()
  }

  if (book[0] !== undefined){
    return(
      <DataGrid 
        rows={book}
        columns={columns}
        pageSize={12}
        style={{height: Height}}
        checkboxSelection
        editMode="cell"
        experimentalFeatures={{ newEditingApi: true }}
        processRowUpdate={processRowUpdate}
        disableSelectionOnClick
        onCellEditStop={(params, event) => {
          if (params.reason === GridRowEditStopReasons.rowFocusOut) {
            event.defaultMuiPrevented = true;
          } 
        }}
        onSelectionModelChange={(ids) => {
          idx=ids;
          console.log(idx)
        }}
      >
      </DataGrid>
     )
  }
}

function GetRequest(){
  const [book, setBook] = useState([]);
  useEffect(() => {
    axios.get(allBookPath+`/${document.getElementById('search-in')}`).then(data => setBook(data.data));
  }, []);
}

  return (
      <div>
        <p/>
        <BookData/>
      </div>
  );
}
