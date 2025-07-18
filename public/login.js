// login.js
// Manages Sign In / Sign Up and integrates with donation_db users table

// Redirect logic for login.html (moved from redirect.js)
document.addEventListener('DOMContentLoaded', () => {
    const userId = localStorage.getItem('userId');
    if (userId) {
        window.location.href = 'app.html';
        return;
    }
    const signInTab     = document.getElementById('signInTab');
    const signUpTab     = document.getElementById('signUpTab');
    const signInForm    = document.getElementById('signInForm');
    const signUpForm    = document.getElementById('signUpForm');
    showTab('signin');
    signInTab.addEventListener('click', ()  => showTab('signin'));
    signUpTab.addEventListener('click', ()  => showTab('signup'));
    signInForm.addEventListener('submit', handleSignIn);
    signUpForm.addEventListener('submit', handleSignUp);
});

function showTab(tab) {
    const signinForm = document.getElementById('signin');
    const signupForm = document.getElementById('signup');
    const signinTab  = document.getElementById('signInTab');
    const signupTab  = document.getElementById('signUpTab');
    if (tab === 'signin') {
        signinForm.classList.remove('hidden');
        signupForm.classList.add('hidden');
        signinTab.classList.add('active');
        signupTab.classList.remove('active');
    } else {
        signupForm.classList.remove('hidden');
        signinForm.classList.add('hidden');
        signupTab.classList.add('active');
        signinTab.classList.remove('active');
    }
}

async function handleSignIn(event) {
    event.preventDefault();
    const email = document.getElementById('signin-email').value.trim();
    const password = document.getElementById('signin-password').value;
    const status = document.getElementById('statusMessage');
    if (!email || !password) {
        status.textContent = 'Please fill in all fields';
        status.style.color = 'red';
        return;
    }
    status.textContent = 'Signing in...';
    status.style.color = 'blue';
    try {
        const res = await fetch('/api/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, password })
        });
        if (!res.ok) {
            const error = await res.json();
            throw new Error(error.error || 'Invalid email/password');
        }
        const data = await res.json();
        localStorage.setItem('userId', data.id);
        localStorage.setItem('username', data.username);
        localStorage.setItem('fullName', data.full_name);
        localStorage.setItem('email', data.email);
        localStorage.setItem('phone', data.phone || '');
        localStorage.setItem('role', data.role);
        localStorage.setItem('loginTime', new Date().toISOString());
        window.location.href = 'app.html';
    } catch (err) {
        status.textContent = err.message;
        status.style.color = 'red';
    }
}

async function handleSignUp(event) {
    event.preventDefault();
    const username = document.getElementById('signup-username').value.trim();
    const fullName = document.getElementById('signup-name').value.trim();
    const phone    = document.getElementById('signup-phone').value.trim();
    const email    = document.getElementById('signup-email').value.trim();
    const password = document.getElementById('signup-password').value;
    const status   = document.getElementById('statusMessage');
    if (!username || !fullName || !email || !password) {
        status.textContent = 'Please fill in all required fields';
        status.style.color = 'red';
        return;
    }
    const usernameRegex = /^[a-zA-Z0-9_]+$/;
    if (!usernameRegex.test(username)) {
        status.textContent = 'Username can only contain letters, numbers, and underscores';
        status.style.color = 'red';
        return;
    }
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        status.textContent = 'Please enter a valid email address';
        status.style.color = 'red';
        return;
    }
    if (password.length < 6) {
        status.textContent = 'Password must be at least 6 characters long';
        status.style.color = 'red';
        return;
    }
    status.textContent = 'Registering...';
    status.style.color = 'blue';
    try {
        const res = await fetch('/api/register', {
            method:  'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                username,
                email,
                password,
                full_name: fullName,
                phone: phone || null,
                address: null
            })
        });
        const data = await res.json();
        if (data.id && data.email === email) {
            document.getElementById('signup-username').value = '';
            document.getElementById('signup-name').value = '';
            document.getElementById('signup-phone').value = '';
            document.getElementById('signup-email').value = '';
            document.getElementById('signup-password').value = '';
            status.textContent = 'Registration successful! Please sign in.';
            status.style.color = 'green';
            setTimeout(() => { showTab('signin'); }, 2000);
        } else if (data.error) {
            throw new Error(data.error);
        } else {
            throw new Error('Registration failed. Please try again.');
        }
    } catch (err) {
        status.textContent = err.message;
        status.style.color = 'red';
    }
}

async function handleDemoLogin() {
    try {
        const res = await fetch('/api/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                email: 'john@example.com',
                password: 'john123'
            })
        });
        if (!res.ok) {
            const error = await res.json();
            throw new Error(error.error || 'Demo login failed');
        }
        const data = await res.json();
        localStorage.setItem('userId', data.id);
        localStorage.setItem('username', data.username);
        localStorage.setItem('fullName', data.full_name);
        localStorage.setItem('email', data.email);
        localStorage.setItem('phone', data.phone || '');
        localStorage.setItem('role', data.role);
        localStorage.setItem('loginTime', new Date().toISOString());
        window.location.href = 'app.html';
    } catch (err) {
        const status = document.getElementById('statusMessage');
        status.textContent = err.message;
        status.style.color = 'red';
    }
}
  