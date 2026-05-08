from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Jenkins CI/CD</title>
        <style>
            * { margin: 0; padding: 0; box-sizing: border-box; }
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #1a1a2e, #16213e, #0f3460);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
            }
            .container {
                text-align: center;
                padding: 40px;
                border: 1px solid rgba(255,255,255,0.1);
                border-radius: 16px;
                background: rgba(255,255,255,0.05);
                backdrop-filter: blur(10px);
                max-width: 600px;
                width: 90%;
            }
            h1 { font-size: 2.5rem; margin-bottom: 16px; color: #e94560; }
            p { font-size: 1.1rem; color: #a8b2d8; margin-bottom: 8px; }
            .badge {
                display: inline-block;
                margin-top: 24px;
                padding: 8px 20px;
                background: #e94560;
                border-radius: 20px;
                font-size: 0.9rem;
                font-weight: bold;
                letter-spacing: 1px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>👋 Hello from Jenkins CI/CD!</h1>
            <p>This app was built and deployed automatically.</p>
            <p>Pipeline: <strong>Jenkins</strong> → Docker → AWS EC2</p>
            <div class="badge">🚀 Deployed Successfully</div>
        </div>
    </body>
    </html>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
