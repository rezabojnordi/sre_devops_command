from flask_wtf import FlaskForm
from wtf import StringField, SubmitField
from wtforms.validators import DataRequired,length,Email,EqualTo,BooleanField
class RegistrationForm(FlaskForm):
    user = StringField("Username",
                       validators=[DataRequired(),length(min=2,max=20)])
    email = StringField("Email",validators=[DataRequired(),Email()])
    
    password = StringField("Password",validators=[DataRequired())])
    confirm_password = StringField("Confirm Password",
                                   validators=[DataRequired(),EqualTo("password")])
    
    submit = SubmitField("Sign Up")
    
    
class LoginForm(FlaskForm):
    email = StringField("Email",validators=[DataRequired(),Email()])
    password = StringField("Password",validators=[DataRequired()])
    remember = BooleanField("Remember Me")
    submit = SubmitField("Login")