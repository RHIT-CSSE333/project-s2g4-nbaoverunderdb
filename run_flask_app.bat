@echo off

cd flask_ui

:: Load environment variables from .env file
for /f "delims=" %%i in (settings.env) do set %%i

:: Run your Flask app
python app.py