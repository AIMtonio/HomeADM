package originacion.bean;

import general.bean.BaseBean;
import herramientas.Utileria;

public class AutorizaSolicitudGrupoBean extends BaseBean{
	private String grupoID;
	private String ciclo;
	private String fechaAutoriza;
	private String comentarioEjecutivo;
	private String comentarioMesaControl;
	
	private String solEstatus;
	private String fechaVencimiento;
	private String prospectoID;
	private String solicitudCreditoID; 
	private String clienteID;
	private String nombre;
	
	private String productoCreditoID;
	private String montoAu;
	private String montoSol;
	private String nombrePromotor;
	private String nombreSucursal;
	
	private String plazoID;
	private String aporte;
	private String montoAutorizado;
	private String usuarioAutoriza;
	private String numTransaccion;
	
	private String detalleFirmasAutoriza;
	private String esquemaID;
	private String numFirma;
	private String organoID;
	
	private String esquemaGrid;
	
	
	public String getEsquemaGrid() {
		return esquemaGrid;
	}
	public void setEsquemaGrid(String esquemaGrid) {
		this.esquemaGrid = esquemaGrid;
	}
	private String listaIntegrantes;
	private String detalleFirmasAutor;
	
	public String getGrupoID() {
		return grupoID;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public String getCiclo() {
		return ciclo;
	}
	public void setCiclo(String ciclo) {
		this.ciclo = ciclo;
	}
	public String getFechaAutoriza() {
		return fechaAutoriza;
	}
	public void setFechaAutoriza(String fechaAutoriza) {
		this.fechaAutoriza = fechaAutoriza;
	}
	public String getComentarioEjecutivo() {
		return comentarioEjecutivo;
	}
	public void setComentarioEjecutivo(String comentarioEjecutivo) {
		this.comentarioEjecutivo = comentarioEjecutivo;
	}
	public String getComentarioMesaControl() {
		return comentarioMesaControl;
	}
	public void setComentarioMesaControl(String comentarioMesaControl) {
		this.comentarioMesaControl = comentarioMesaControl;
	}
	public String getSolEstatus() {
		return solEstatus;
	}
	public void setSolEstatus(String solEstatus) {
		this.solEstatus = solEstatus;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public String getMontoAu() {
		return montoAu;
	}
	public void setMontoAu(String montoAu) {
		this.montoAu = montoAu;
	}
	public String getMontoSol() {
		return montoSol;
	}
	public void setMontoSol(String montoSol) {
		this.montoSol = montoSol;
	}
	public String getNombrePromotor() {
		return nombrePromotor;
	}
	public void setNombrePromotor(String nombrePromotor) {
		this.nombrePromotor = nombrePromotor;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getPlazoID() {
		return plazoID;
	}
	public void setPlazoID(String plazoID) {
		this.plazoID = plazoID;
	}
	public String getAporte() {
		return aporte;
	}
	public void setAporte(String aporte) {
		this.aporte = aporte;
	}
	public String getMontoAutorizado() {
		return montoAutorizado;
	}
	public void setMontoAutorizado(String montoAutorizado) {
		this.montoAutorizado = montoAutorizado;
	}
	public String getUsuarioAutoriza() {
		return usuarioAutoriza;
	}
	public void setUsuarioAutoriza(String usuarioAutoriza) {
		this.usuarioAutoriza = usuarioAutoriza;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getEsquemaID() {
		return esquemaID;
	}
	public void setEsquemaID(String esquemaID) {
		this.esquemaID = esquemaID;
	}
	public String getNumFirma() {
		return numFirma;
	}
	public void setNumFirma(String numFirma) {
		this.numFirma = numFirma;
	}
	public String getOrganoID() {
		return organoID;
	}
	public void setOrganoID(String organoID) {
		this.organoID = organoID;
	}
	public String getDetalleFirmasAutoriza() {
		return detalleFirmasAutoriza;
	}
	public void setDetalleFirmasAutoriza(String detalleFirmasAutoriza) {
		this.detalleFirmasAutoriza = detalleFirmasAutoriza;
	}
	public String getListaIntegrantes() {
		return listaIntegrantes;
	}
	public void setListaIntegrantes(String listaIntegrantes) {
		this.listaIntegrantes = listaIntegrantes;
	}
	public String getDetalleFirmasAutor() {
		return detalleFirmasAutor;
	}
	public void setDetalleFirmasAutor(String detalleFirmasAutor) {
		this.detalleFirmasAutor = detalleFirmasAutor;
	}
	
}
