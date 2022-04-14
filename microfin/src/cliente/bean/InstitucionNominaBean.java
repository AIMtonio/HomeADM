package cliente.bean;

import general.bean.BaseBean;

public class InstitucionNominaBean extends BaseBean{
	private String institNominaID;
	private String nombreInstit;
	private String clienteID;
	private String contactoRH;
	private String telContactoRH;
	private String bancoDeposito;
	private String promotorID;
	private String nombrePromotor;
	private String telefono;
	private String numErr;
	private String msjErr;
	
	
	public String getInstitNominaID() {
		return institNominaID;
	}
	public String getNombreInstit() {
		return nombreInstit;
	}
	public String getClienteID() {
		return clienteID;
	}
	public String getContactoRH() {
		return contactoRH;
	}
	public String getTelContactoRH() {
		return telContactoRH;
	}
	public String getBancoDeposito() {
		return bancoDeposito;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public void setNombreInstit(String nombreInstit) {
		this.nombreInstit = nombreInstit;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public void setContactoRH(String contactoRH) {
		this.contactoRH = contactoRH;
	}
	public void setTelContactoRH(String telContactoRH) {
		this.telContactoRH = telContactoRH;
	}
	public void setBancoDeposito(String bancoDeposito) {
		this.bancoDeposito = bancoDeposito;
	}
	public String getNumErr() {
		return numErr;
	}
	public String getMsjErr() {
		return msjErr;
	}
	public void setNumErr(String numErr) {
		this.numErr = numErr;
	}
	public void setMsjErr(String msjErr) {
		this.msjErr = msjErr;
	}
	public String getPromotorID() {
		return promotorID;
	}
	public void setPromotorID(String promotorID) {
		this.promotorID = promotorID;
	}
	public String getNombrePromotor() {
		return nombrePromotor;
	}
	public void setNombrePromotor(String nombrePromotor) {
		this.nombrePromotor = nombrePromotor;
	}
	public String getTelefono() {
		return telefono;
	}
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}

}
