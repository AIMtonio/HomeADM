package tesoreria.bean;

import java.util.List;

import general.bean.BaseBean;

public class CancelacionOrdPagoBean extends BaseBean{
	private String	folioDispersion;
	private String	claveDisMov;
	private String	solicitudCreditoID;
	private String	creditoID;
	private String	referencia;
	
	private String	clienteID;
	private String	nombreCliente;
	private String	estatus;
	private String	monto;
	private String	detalleAccesorios;

	private List lisSolicitudCreditoID;
	private List lisCreditoID;
	private List lisReferencia;
	private List lisClienteID;
	private List lisNombreCliente;
	private List lisEstatus;
	private List lisMonto;
	private List lisClaveDisMov;
	private List lisFolioDispersion;
	
	
	public List getLisSolicitudCreditoID() {
		return lisSolicitudCreditoID;
	}
	public void setLisSolicitudCreditoID(List lisSolicitudCreditoID) {
		this.lisSolicitudCreditoID = lisSolicitudCreditoID;
	}
	public List getLisCreditoID() {
		return lisCreditoID;
	}
	public void setLisCreditoID(List lisCreditoID) {
		this.lisCreditoID = lisCreditoID;
	}
	public List getLisReferencia() {
		return lisReferencia;
	}
	public void setLisReferencia(List lisReferencia) {
		this.lisReferencia = lisReferencia;
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
	public List getLisEstatus() {
		return lisEstatus;
	}
	public void setLisEstatus(List lisEstatus) {
		this.lisEstatus = lisEstatus;
	}
	public List getLisMonto() {
		return lisMonto;
	}
	public void setLisMonto(List lisMonto) {
		this.lisMonto = lisMonto;
	}
	public List getLisClaveDisMov() {
		return lisClaveDisMov;
	}
	public void setLisClaveDisMov(List lisClaveDisMov) {
		this.lisClaveDisMov = lisClaveDisMov;
	}
	public String getFolioDispersion() {
		return folioDispersion;
	}
	public void setFolioDispersion(String folioDispersion) {
		this.folioDispersion = folioDispersion;
	}

	public List getLisFolioDispersion() {
		return lisFolioDispersion;
	}
	public void setLisFolioDispersion(List lisFolioDispersion) {
		this.lisFolioDispersion = lisFolioDispersion;
	}
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getClaveDisMov() {
		return claveDisMov;
	}
	public void setClaveDisMov(String claveDisMov) {
		this.claveDisMov = claveDisMov;
	}
	public String getDetalleAccesorios() {
		return detalleAccesorios;
	}
	public void setDetalleAccesorios(String detalleAccesorios) {
		this.detalleAccesorios = detalleAccesorios;
	}


}
