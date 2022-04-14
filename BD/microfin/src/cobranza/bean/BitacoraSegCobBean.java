package cobranza.bean;

import general.bean.BaseBean;
import java.util.List;

public class BitacoraSegCobBean extends BaseBean {
	private String fechaSis;
	private String usuarioID;
	private String sucursalID;
	private String creditoID;
	private String clienteID;

	private String accionID;
	private String respuestaID;
	private String etapaCobranza;
	private String fechaEntregaDoc;
	private String comentario;
	
	//campos grid promesa 
	private List lisNumPromesa;
	private List lisFechaPromPago;
	private List lisMontoPromPago;
	private List lisComentarioProm;
	
	private String numPromesa;
	private String fechaPromPago;
	private String montoPromPago;
	private String comentarioProm;
	private String bitSegCobID;
	
	public String getFechaSis() {
		return fechaSis;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public String getAccionID() {
		return accionID;
	}
	public String getRespuestaID() {
		return respuestaID;
	}
	public String getEtapaCobranza() {
		return etapaCobranza;
	}
	public String getFechaEntregaDoc() {
		return fechaEntregaDoc;
	}
	public String getComentario() {
		return comentario;
	}
	public List getLisNumPromesa() {
		return lisNumPromesa;
	}
	public List getLisFechaPromPago() {
		return lisFechaPromPago;
	}
	public List getLisMontoPromPago() {
		return lisMontoPromPago;
	}
	public List getLisComentarioProm() {
		return lisComentarioProm;
	}
	public String getNumPromesa() {
		return numPromesa;
	}
	public String getFechaPromPago() {
		return fechaPromPago;
	}
	public String getMontoPromPago() {
		return montoPromPago;
	}
	public String getComentarioProm() {
		return comentarioProm;
	}
	public void setFechaSis(String fechaSis) {
		this.fechaSis = fechaSis;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public void setAccionID(String accionID) {
		this.accionID = accionID;
	}
	public void setRespuestaID(String respuestaID) {
		this.respuestaID = respuestaID;
	}
	public void setEtapaCobranza(String etapaCobranza) {
		this.etapaCobranza = etapaCobranza;
	}
	public void setFechaEntregaDoc(String fechaEntregaDoc) {
		this.fechaEntregaDoc = fechaEntregaDoc;
	}
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}
	public void setLisNumPromesa(List lisNumPromesa) {
		this.lisNumPromesa = lisNumPromesa;
	}
	public void setLisFechaPromPago(List lisFechaPromPago) {
		this.lisFechaPromPago = lisFechaPromPago;
	}
	public void setLisMontoPromPago(List lisMontoPromPago) {
		this.lisMontoPromPago = lisMontoPromPago;
	}
	public void setLisComentarioProm(List lisComentarioProm) {
		this.lisComentarioProm = lisComentarioProm;
	}
	public void setNumPromesa(String numPromesa) {
		this.numPromesa = numPromesa;
	}
	public void setFechaPromPago(String fechaPromPago) {
		this.fechaPromPago = fechaPromPago;
	}
	public void setMontoPromPago(String montoPromPago) {
		this.montoPromPago = montoPromPago;
	}
	public void setComentarioProm(String comentarioProm) {
		this.comentarioProm = comentarioProm;
	}
	public String getBitSegCobID() {
		return bitSegCobID;
	}
	public void setBitSegCobID(String bitSegCobID) {
		this.bitSegCobID = bitSegCobID;
	}	
}
