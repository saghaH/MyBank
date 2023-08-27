package com.mybank.payload.response;

import com.mybank.models.UserDTO;

public class JwtResponse {
  private String token;
  private String type = "Bearer";
  private UserDTO user;

  public JwtResponse(String accessToken, UserDTO user) {
    this.token = accessToken;
    this.user = user;
  }

  public String getAccessToken() {
    return token;
  }

  public void setAccessToken(String accessToken) {
    this.token = accessToken;
  }

  public String getTokenType() {
    return type;
  }

  public void setTokenType(String tokenType) {
    this.type = tokenType;
  }

  public UserDTO getUser() {
    return user;
  }

  public void setUser(UserDTO user) {
    this.user = user;
  }
}
