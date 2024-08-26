import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';  

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './login.component.html',
  styleUrl: './login.component.css'
   
})
export class LoginComponent {
  isForgotPassword: boolean = false;

  isRegisterMode: boolean = false; 

  toggleMode() {
    this.isRegisterMode = !this.isRegisterMode;
  }
  toggleForgotPassword() {
    this.isForgotPassword = !this.isForgotPassword;
  }
 
}
