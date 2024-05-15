import React from "react";
import { useEffect, useState, useRef } from 'react';
import './Styles.css';
import axios from 'axios';
import { DataGrid, GridRowEditStopReasons} from '@mui/x-data-grid';
import { IconButton} from '@mui/material';
import DeleteOutlinedIcon from '@mui/icons-material/DeleteOutlined';
import Button from 'react-bootstrap/Button';
import Modal from 'react-bootstrap/Modal';
import {render} from 'react-dom';

const Height = 80 + 'vh'

const authorPath = "http://localhost:5000/api/v1/book/authors";


function Title() {
  useEffect(() => {
    document.title = 'Авторы';
  }, []);
}

export default function Authors() {
  Title();
  let idx=0;

const columns = [
  { field: 'id', headerName: 'ID' },
  { field: 'name', headerName: 'ФИО', width: 400, editable: true},
  { field: 'bio', headerName: 'Биография', width: 300, wordWrapEnabled: true, editable: true,},
  { field: 'birthday', headerName: 'Дата рождения', width: 200, editable: true},
  { field: 'langs', headerName: 'Языки', width: 200, editable: true},
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
  },
]

function StaticExample() {
  const [show, setShow] = useState(false);

  const handleClose = () => setShow(false);
  const handleShow = () => setShow(true);

  return (
    <>
      <Button variant="primary" onClick={handleShow}>
        Launch demo modal
      </Button>

      <Modal show={show} onHide={handleClose}>
        <Modal.Header closeButton>
          <Modal.Title>Modal heading</Modal.Title>
        </Modal.Header>
        <Modal.Body>Woohoo, you're reading this text in a modal!</Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={handleClose}>
            Close
          </Button>
          <Button variant="primary" onClick={handleClose}>
            Save Changes
          </Button>
        </Modal.Footer>
      </Modal>
    </>
  );
}

function DeleteRow(){
  let err;
  axios.delete(authorPath+`/${idx[0]}/delete`).catch(function (error) { err = error;})
  console.log(idx)
  window.location.reload()
}

function AuthorData(){
  const [author, setAuthor] = useState([]);
  useEffect(() => {
    axios.get(authorPath).then(data => setAuthor(data.data));
  }, []);
  console.log(author);

  function processRowUpdate(newRow, oldRow){
    SetData(newRow, oldRow)
    return(newRow)
  }
  //передача из другого места
  function SetData(newRow, oldRow){
      axios.put(authorPath+`/${oldRow.id}`, {
      name: newRow.name,
      bio: newRow.bio,
      birthday: newRow.birthday,
      lang_spec: (newRow.langs).join(' ')
    })
    window.location.reload()
    console.log(newRow)
  }

  if (author[0] !== undefined){
    return(
      <DataGrid 
        rows={author}
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

  return (
      <div>
        <p/>
        <AuthorData/>
      </div>
  );
}