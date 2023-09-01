package com.mybank.payload.request;

public class ModifyPasswordRequest {
    private String oldPwd;
    private String newPwd;
    private String confirmPwd;

    public ModifyPasswordRequest() {
    }

    public ModifyPasswordRequest(String oldPwd, String newPwd, String confirmPwd) {
        this.oldPwd = oldPwd;
        this.newPwd = newPwd;
        this.confirmPwd = confirmPwd;
    }

    public String getOldPwd() {
        return oldPwd;
    }

    public void setOldPwd(String oldPwd) {
        this.oldPwd = oldPwd;
    }

    public String getNewPwd() {
        return newPwd;
    }

    public void setNewPwd(String newPwd) {
        this.newPwd = newPwd;
    }

    public String getConfirmPwd() {
        return confirmPwd;
    }

    public void setConfirmPwd(String confirmPwd) {
        this.confirmPwd = confirmPwd;
    }
}
