package originacion.bean;

import java.util.List;

import general.bean.BaseBean;

public class RiesgoComunBean extends BaseBean{
	private String solicitudCreditoID;
	private String prospectoID;
	private String nombreCliente;
	
	private String creditoID;
	private String clienteID;
	private String motivo;
	private String esRiesgo;
	private String comentarios;
	private String consecutivoID;
	

	private List lisCreditoID;
	private List lisClienteID;
	private List lisNombreCliente;
	private List lisMotivo;
	private List lisEsRiesgo;
	private List lisComentarios;
	private List lisConsecutivoID;
	
	
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getMotivo() {
		return motivo;
	}
	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}
	public String getEsRiesgo() {
		return esRiesgo;
	}
	public void setEsRiesgo(String esRiesgo) {
		this.esRiesgo = esRiesgo;
	}
	public String getComentarios() {
		return comentarios;
	}
	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
	}
	public List getLisCreditoID() {
		return lisCreditoID;
	}
	public void setLisCreditoID(List lisCreditoID) {
		this.lisCreditoID = lisCreditoID;
	}
	public List getLisClienteID() {
		return lisClienteID;
	}
	public void setLisClienteID(List lisClienteID) {
		this.lisClienteID = lisClienteID;
	}
	public List getLisNombreCliente() {
		return lisNombreCliente;
	}
	public void setLisNombreCliente(List lisNombreCliente) {
		this.lisNombreCliente = lisNombreCliente;
	}
	public List getLisMotivo() {
		return lisMotivo;
	}
	public void setLisMotivo(List lisMotivo) {
		this.lisMotivo = lisMotivo;
	}
	public List getLisEsRiesgo() {
		return lisEsRiesgo;
	}
	public void setLisEsRiesgo(List lisEsRiesgo) {
		this.lisEsRiesgo = lisEsRiesgo;
	}
	public List getLisComentarios() {
		return lisComentarios;
	}
	public void setLisComentarios(List lisComentarios) {
		this.lisComentarios = lisComentarios;
	}
	public String getConsecutivoID() {
		return consecutivoID;
	}
	public void setConsecutivoID(String consecutivoID) {
		this.consecutivoID = consecutivoID;
	}
	public List getLisConsecutivoID() {
		return lisConsecutivoID;
	}
	public void setLisConsecutivoID(List lisConsecutivoID) {
		this.lisConsecutivoID = lisConsecutivoID;
	}
	
	
	
	
	
	
	
}
