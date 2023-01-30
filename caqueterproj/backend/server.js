// ----------------- INITIALISATION DU SERVEUR ------------------- //

var express = require('express');
var cors = require('cors')
var fs = require('fs')
const path = require('path')
var formidable = require('formidable')
var bodyParser = require('body-parser')

var server = express();



server.use(bodyParser.urlencoded({ extended: true }));
server.use(bodyParser.json());
server.use(express.static('public'));
server.use(cors())

// ----------------------- BASE DE DONNEES ----------------------- //

var mysql = require('mysql');
var connection = mysql.createConnection({
	host: 'localhost',
	user: 'franxk_elsax',
	password: '',
	database: 'caqueter'
});
connection.connect();

// ------------------ GESTION DES LIENS APPELES ------------------- //
const router = express.Router();
server.use('/caqueter', router);

/* TODO: A utiliser pour toutes les pages 
router.use(function (req, res, next) {
	next()
});*/

// -------------------------- ACCUEIL --------------------------- //

server.post('/', function (req, res) {
});

server.post('/addCaque', (req, res) => {
	connection.query('INSERT INTO caque (id_user, caque) VALUES (' + req.body.id_user + ', "' + req.body.message + '")', (err, result) => {
		if(err) return res.json({ 'ok' : false, 'err': err})
		return res.json({'ok': true})
	})
});

server.post('/sendFollow', (req, res) => {
	connection.query("INSERT INTO abonnements (id_user, id_abonnement) VALUES (" + req.body.id_from + ", " + req.body.id_following + ") ON DUPLICATE KEY UPDATE do_delete = 1", (err) => {
		if(err) return res.json({'ok': false, 'err': err})
		connection.query("DELETE FROM abonnements WHERE do_delete = 1", (err2, result) => {
			if(err2) return res.json({'ok': false, 'err': err2})
			return res.json({'ok': true, 'res': result})
		})
	})
})

server.post('/getPfp', (req, res) => {
	connection.query("SELECT photo FROM user WHERE pseudo = '" + req.body.username + "'", (err, result) => {
		if(err) return res.json({'ok':false, 'err': err})
		return res.json({'ok': true, 'pp': result})
	})
})

server.all('/purgeDB', (req, res) => {
	connection.query("DELETE FROM reaction WHERE ronron = 0", (err, result) => {
		if(err) return res.json({'ok': false})
		return res.json({'ok': true, 'result': result})
	})
})

server.post('/likeCaque', (req, res) => {
	var sql = "INSERT INTO reaction (id_caque, id_user, ronron) VALUES (" + req.body.id_caque + ", " + req.body.id_user + ", " + req.body.ronronned + ") ON DUPLICATE KEY UPDATE ronron=" + req.body.ronronned;
	connection.query(sql, function(err, result){
		if (err) return res.json({'ok' : false, 'res' : [], 'err' : err})
		return res.json({'ok' : true, 'res' : result})
	})
})

server.all('/getCaques', (req, res) => {
	connection.query("SELECT * from full_caque WHERE id_caque > " + req.body.nb_caques + " ORDER BY date ASC", function (err, caques){
		if(req.body.id_user){
			connection.query("SELECT id_caque, ronron FROM reaction WHERE id_user = " + req.body.id_user + " AND id_caque > " + req.body.nb_caques, function(err, reacs){
				var result = {
					caques: caques,
					reactions: reacs,
				}
				if (err) return res.json({'ok' : false, 'res' : null, 'err' : err})
				return res.json({'ok' : true, 'res' : result})
			})
		} else {
			var result = {
				caques: caques
			}
		if (err) return res.json({'ok': false, 'res' : null, 'err' : err})
		return res.json({'ok' : true, 'res' : result})
		}
	})
})

server.all('/changePfp', (req, res) => {
	const form = new formidable.IncomingForm();
    form.parse(req, function(err, fields, files){
        var oldPath = files.newPP.path;
        var newPath = path.join(__dirname, '../public/pictures')
                + '/'+fields.id_user + ".png"
		fs.copyFile(oldPath, newPath, (err) => {
			if(err) throw err
		})
	})
})

server.post("/getFollows", (req, res) => {
	connection.query("SELECT (SELECT COUNT(*) FROM abonnements WHERE id_abonnement = " + req.body.id_user + ") as abonne FROM abonnements",  (err, nombre) => {
		if (err) return res.json({'ok': false, 'res' : [], 'err' : err})
		connection.query("SELECT id_abonnement FROM abonnements WHERE id_user = " + req.body.id_user, (err2, ids) => {
			if(err2) return res.json({'ok': false, 'res' : [], 'err' : err2})
			return res.json({'ok' : true, 'nombre': nombre, 'id_abonnements': ids})
		})
	})
})

server.all("/connexion", (req, res) => {
	connection.query("SELECT * FROM user WHERE pseudo=" + '"' + req.body.user + '"', function(err, result){
		if(err) 
			return res.json({'ok': false, 'res' : null, 'err' : err})
		else if(result.length != 1) 
			return res.json({'ok' : false, 'res' : null, 'err' : 'Utilisateur introuvable'})
		return res.json({'ok' : true, 'res' : result})
	});
})

server.listen(8000)