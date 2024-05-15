import React from "react";
import './App.css';
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Link,
  Navigate
} from 'react-router-dom';
import AllBooks from './pages/AllBooks';
import Authors from './pages/Authors';
import AddBookInfo from './pages/AddBookInfo';
import ReadBooks from './pages/ReadBooks'
import PlanedBooks from './pages/PlannedBooks'
import AddAuthorInfo from './pages/AddAuthorInfo'
import {MapBookProvider} from './pages/useDataBook';

function App() {
  return (
    <div className='grid'>
      <Main />
    </div>
  );
}

class Main extends React.Component {
  render(){
    return(
      <MapBookProvider>
        <Router>
          <div className="grid">
            <div>
            <Link to="/allbooks">
              <button className='menu' id="book-icon">
                MyBooks
              </button>
              </Link>
              <br/>
              <Link to="/allbooks">
                <button className='menu' id="book-list">
                  Все книги
                </button>
              </Link>
              <br/>
              <Link to="/readbooks">
              <button className='menu' id="book-read">
                Прочитанные книги
              </button>
              </Link>
              <br/>
              <Link to="/plannedbooks">
              <button className='menu' id="book-plan">
                Запланированные книги
              </button>
              </Link>
              <br/>
              <Link to="/authors">
                <button className='menu' id="authors-list">
                Список авторов
                </button>
              </Link>
              <br/>
              <Link to="/add-info-book">
                <button className='menu' id="add-data">
                  Добавить информацию о книге
                </button>
              </Link>
              <br/>
              <Link to="/add-info-author">
                <button className='menu' id="add-data">
                  Добавить информацию об авторе
                </button>
              </Link>
            </div>
          <Routes>
            <Route path="/" element={<Navigate to="/allbooks" />} />
            <Route exact path = '/allbooks' element={<AllBooks/>}/>
            <Route exact path = '/readbooks' element={<ReadBooks/>}/>
            <Route exact path = '/plannedbooks' element={<PlanedBooks/>}/>
            <Route exact path = '/authors' element={<Authors/>}/>
            <Route exact path = '/add-info-book' element={<AddBookInfo/>}/>
            <Route exact path = '/add-info-author' element={<AddAuthorInfo/>}/>
          </Routes>
          </div>
        </Router>
      </MapBookProvider>
    )
  }
}
export default App;