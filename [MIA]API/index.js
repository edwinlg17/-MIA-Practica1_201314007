const express = require('express');
const app = express();
const morgan = require('morgan');

// middlewares
app.use(morgan('dev'));
app.use(express.urlencoded({extended:false}));
app.use(express.json());

//setings
app.set('port', process.env.PORT || 3000);
app.set('json spaces', 2);

// routes
app.use(require('./routes/index'));

// server
app.listen(app.get('port'),() => {
    console.log('SERVIDOR INICIADO');
});

