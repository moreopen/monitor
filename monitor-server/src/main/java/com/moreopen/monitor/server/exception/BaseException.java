package com.moreopen.monitor.server.exception;

public abstract class BaseException extends Exception {
	
	protected static final long serialVersionUID = 1L;
	protected String msgCode;
	protected String msg;
	protected String exception;
	
	public void setError(String msgCode,String msg,String exception){
		this.msgCode = msgCode;
		this.msg = msg;
		this.exception = exception;
	}

	public String getMsgCode() {
		return msgCode;
	}

	public void setMsgCode(String msgCode) {
		this.msgCode = msgCode;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public String getException() {
		return exception;
	}

	public void setException(String exception) {
		this.exception = exception;
	}
	@Override
	public String toString(){
		StringBuilder sb=new StringBuilder();
		sb.append("msgCode:").append(msgCode);
		sb.append("msg:").append(msg);
		sb.append("exception:").append(exception);
		return sb.toString();
	}

}
