import 'babel-polyfill'
import React from 'react'
import { render } from 'react-dom'
import Bookslist from './containers/Booklist'

import { Router, Route, IndexRoute, browserHistory } from 'react-router'

render(
  <Router history={browserHistory}>
    <Route path='/' component={Bookslist}>
    </Route>
  </Router>,
  document.getElementById('root')
)