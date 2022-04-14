package originacion.bean;

import java.util.List;

import general.bean.BaseBean;

public class OtrosAccesoriosBean extends BaseBean{
	private String accesorioID;
	private String descripcion;
	private String abreviatura;
	private String prelacion;
	
	private String detalleAccesorios;
	
	
	private String creditoID;
	private String clienteID;
	private String nombreCliente;
	private String clienteIDRel;
	private String nombreClienteRel;
	private String motivo;
	private String esRiesgo;
	private String comentarios;
	private String procesado;
	private String comentariosMonitor;
	private String consecutivoID;
	private String comentario;
	private String estatus;
	private String parentescoID;
	private String descParen;
	private String clave;
	private String montoAcumulado;
	private String clienteIDDesc;
	private String saldoInsolutoCartera;
	private String sumatoriaCreditos;
	
	private String aplicaCalCAT;
	
	
	private List lisSolicitudCreditoID;
	private List lisCreditoID;
	private List lisClienteID;
	private List lisNombreCliente;
	private List lisClienteIDRel;
	private List lisNombreClienteRel;
	private List lisMotivo;
	private List lisEsRiesgo;
	private List lisComentarios;
	private List lisProcesado;
	private List lisComentariosMonitor;
	private List lisComentario;
	private List lisConsecutivoID;
	private List lisEstatus;
	private List lisParentescoID;
	private List lisDescParen;
	private List lisClave;
	private List lisMontoAcumulado;
	
	
	public String getAccesorioID() {
		return accesorioID;
	}
	public void setAccesorioID(String accesorioID) {
		this.accesorioID = accesorioID;
	}
	
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getAbreviatura() {
		return abreviatura;
	}
	public void setAbreviatura(String abreviatura) {
		this.abreviatura = abreviatura;
	}
	public String getPrelacion() {
		return prelacion;
	}
	public void setPrelacion(String prelacion) {
		this.prelacion = prelacion;
	}
	public String getDetalleAccesorios() {
		return detalleAccesorios;
	}
	public void setDetalleAccesorios(String detalleAccesorios) {
		this.detalleAccesorios = detalleAccesorios;
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
	public List getLisSolicitudCreditoID() {
		return lisSolicitudCreditoID;
	}
	public void setLisSolicitudCreditoID(List lisSolicitudCreditoID) {
		this.lisSolicitudCreditoID = lisSolicitudCreditoID;
	}
	public String getClienteIDRel() {
		return clienteIDRel;
	}
	public void setClienteIDRel(String clienteIDRel) {
		this.clienteIDRel = clienteIDRel;
	}
	public String getNombreClienteRel() {
		return nombreClienteRel;
	}
	public void setNombreClienteRel(String nombreClienteRel) {
		this.nombreClienteRel = nombreClienteRel;
	}
	public List getLisClienteIDRel() {
		return lisClienteIDRel;
	}
	public void setLisClienteIDRel(List lisClienteIDRel) {
		this.lisClienteIDRel = lisClienteIDRel;
	}
	public List getLisNombreClienteRel() {
		return lisNombreClienteRel;
	}
	public void setLisNombreClienteRel(List lisNombreClienteRel) {
		this.lisNombreClienteRel = lisNombreClienteRel;
	}
	public String getProcesado() {
		return procesado;
	}
	public void setProcesado(String procesado) {
		this.procesado = procesado;
	}
	public List getLisProcesado() {
		return lisProcesado;
	}
	public void setLisProcesado(List lisProcesado) {
		this.lisProcesado = lisProcesado;
	}
	public String getComentariosMonitor() {
		return comentariosMonitor;
	}
	public void setComentariosMonitor(String comentariosMonitor) {
		this.comentariosMonitor = comentariosMonitor;
	}
	public List getLisComentariosMonitor() {
		return lisComentariosMonitor;
	}
	public void setLisComentariosMonitor(List lisComentariosMonitor) {
		this.lisComentariosMonitor = lisComentariosMonitor;
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
	public String getComentario() {
		return comentario;
	}
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}
	public List getLisComentario() {
		return lisComentario;
	}
	public void setLisComentario(List lisComentario) {
		this.lisComentario = lisComentario;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getParentescoID() {
		return parentescoID;
	}
	public void setParentescoID(String parentescoID) {
		this.parentescoID = parentescoID;
	}
	public String getDescParen() {
		return descParen;
	}
	public void setDescParen(String descParen) {
		this.descParen = descParen;
	}
	public String getClave() {
		return clave;
	}
	public void setClave(String clave) {
		this.clave = clave;
	}
	public List getLisEstatus() {
		return lisEstatus;
	}
	public void setLisEstatus(List lisEstatus) {
		this.lisEstatus = lisEstatus;
	}
	public List getLisParentescoID() {
		return lisParentescoID;
	}
	public void setLisParentescoID(List lisParentescoID) {
		this.lisParentescoID = lisParentescoID;
	}
	public List getLisDescParen() {
		return lisDescParen;
	}
	public void setLisDescParen(List lisDescParen) {
		this.lisDescParen = lisDescParen;
	}
	public List getLisClave() {
		return lisClave;
	}
	public void setLisClave(List lisClave) {
		this.lisClave = lisClave;
	}	
	public String getMontoAcumulado() {
		return montoAcumulado;
	}
	public void setMontoAcumulado(String montoAcumulado) {
		this.montoAcumulado = montoAcumulado;
	}
	public List getLisMontoAcumulado() {
		return lisMontoAcumulado;
	}
	public void setLisMontoAcumulado(List lisMontoAcumulado) {
		this.lisMontoAcumulado = lisMontoAcumulado;
	}
	public String getClienteIDDesc() {
		return clienteIDDesc;
	}
	public void setClienteIDDesc(String clienteIDDesc) {
		this.clienteIDDesc = clienteIDDesc;
	}
	public String getSaldoInsolutoCartera() {
		return saldoInsolutoCartera;
	}
	public void setSaldoInsolutoCartera(String saldoInsolutoCartera) {
		this.saldoInsolutoCartera = saldoInsolutoCartera;
	}
	public String getSumatoriaCreditos() {
		return sumatoriaCreditos;
	}
	public void setSumatoriaCreditos(String sumatoriaCreditos) {
		this.sumatoriaCreditos = sumatoriaCreditos;
	}
	public String getAplicaCalCAT() {
		return aplicaCalCAT;
	}
	public void setAplicaCalCAT(String aplicaCalCAT) {
		this.aplicaCalCAT = aplicaCalCAT;
	}	
	
}
