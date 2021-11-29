import React, { useRef, useState } from 'react';
import Axios from 'axios'
import './App.css';

function App() {

  return (
    <div className="App">
      <header>
        <h1>Vibezz ⚡⚡</h1>
      </header>

      <section>
        <ChatRoom />
      </section>
    </div>
  );
}

function ChatRoom() {
  const dummy = useRef();

  const [formValue, setFormValue] = useState('');
  const [messages, setMessages] = useState([]);

  const sendMessage = async (e) => {
    e.preventDefault();
    setMessages(prevProps => [...prevProps, { message: formValue, role: 'user' }])

    Axios.post('http://127.0.0.1:5000/', { message: formValue })
      .then(({ data }) => {
        setTimeout(() => {
          setMessages(prevProps => [...prevProps, data])
        }, 1500)
      })

    setFormValue('');
    dummy.current.scrollIntoView({ behavior: 'smooth' });
  }

  return (
    <React.Fragment>
      <main>
        {messages && messages.map(msg => <ChatMessage key={msg.message} message={msg} />)}
        <span ref={dummy} />
      </main>
      <form onSubmit={sendMessage}>
        <input value={formValue} onChange={(e) => setFormValue(e.target.value)} placeholder="Type something here..." />
        <button type="submit" disabled={!formValue}>
          Sent
        </button>
      </form>
    </React.Fragment>
  )
}


function ChatMessage({ message: { message, role } }) {
  const messageClass = role === 'bot' ? 'user' : 'bot';

  return (
    <React.Fragment>
      <div className={`message ${messageClass}`}>
        <img alt='icon' src={`https://avatars.dicebear.com/api/bottts/${message.substr(0, 5)}.svg`} />
        <p dangerouslySetInnerHTML={{ __html: message }}></p>
      </div>
    </React.Fragment>
  )
}

export default App;
