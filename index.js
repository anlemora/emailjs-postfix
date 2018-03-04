const email = require('emailjs')

const server = email.server.connect({
  user: 'username@example1.com',
  password: 'password',
  host: 'localhost',
  ssl: true
})

server.send({
  text: 'First email sent from node with custom postfix mail server',
  from: 'you <contact@your-email.com>',
  to: 'receiver@mail.com',
  subject: 'emailjs test'
}, (err, message) => {
  console.log(err || message)
})

