package originacion.bean;

import general.bean.BaseBean;

public class InstruccionDispersionBean  extends BaseBean{
	
	private String solicitudCreditoID;
	private String tipoDispersion;
	private String beneficiario;
	private String cuenta;
	private String montoDispersion;
	private String permiteModificar;
	private String ClienteID;
	private String nombreCompleto;
	private String estatus;
	
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getTipoDispersion() {
		return tipoDispersion;
	}
	public void setTipoDispersion(String tipoDispersion) {
		this.tipoDispersion = tipoDispersion;
	}
	public String getBeneficiario() {
		return beneficiario;
	}
	public void setBeneficiario(String beneficiario) {
		this.beneficiario = beneficiario;
	}
	public String getCuenta() {
		return cuenta;
	}
	public void setCuenta(String cuenta) {
		this.cuenta = cuenta;
	}
	public String getMontoDispersion() {
		return montoDispersion;
	}
	public void setMontoDispersion(String montoDispersion) {
		this.montoDispersion = montoDispersion;
	}
	public String getPermiteModificar() {
		return permiteModificar;
	}
	public void setPermiteModificar(String permiteModificar) {
		this.permiteModificar = permiteModificar;
	}
	public String getClienteID() {
		return ClienteID;
	}
	public void setClienteID(String clienteID) {
		ClienteID = clienteID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}

	

}
