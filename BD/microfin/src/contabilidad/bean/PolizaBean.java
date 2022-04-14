package contabilidad.bean;

import general.bean.BaseBean;

public class PolizaBean extends BaseBean{
	
	public static int numIntentosGeneraPoliza = 3;
	
	public static String polizaAutomatica="A";
	public static String polizaManual="M";
	private String polizaID; 
	private String empresaID; 
	private String fecha;
	private String tipo;
	private String conceptoID; 
	private String concepto; 
	private String salida;
	private String desPlantilla;//descripcion de la plantilla
	private String usuario;
	private String fechaActual;
	private String direccionIP; 
	private String programaID;
	private String sucursal; 
	private String numTransaccion;

	private String numeroPoliza;
	private String numErrPol;
	private String errMenPol;
	private String descProceso;
	
	private String movimiento;
	private String institucionID;
	private String nomInstitucion;
	private String numCtaBancaria;
	private String cuentaClabe;
	
	private String tipoDoc;
	private String numCheque;
	
	private String pagadorID;
	private String nomPagador;
	private String importe;
	private String referenciaDoc;
	
	private String metodoPago;
	private String instOrigenID;
	private String nomInstOrigen;
	private String ctaClabeOrigen;
	private String monedaIDDoc;	
	private String descMoneda;
	private String tipoCambio;
	
 
	
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getConceptoID() {
		return conceptoID;
	}
	public void setConceptoID(String conceptoID) {
		this.conceptoID = conceptoID;
	}
	public String getConcepto() {
		return concepto;
	}
	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}
	public String getSalida() {
		return salida;
	}
	public void setSalida(String salida) {
		this.salida = salida;
	}
	public String getDesPlantilla() {
		return desPlantilla;
	}
	public void setDesPlantilla(String desPlantilla) {
		this.desPlantilla = desPlantilla;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getNumeroPoliza() {
		return numeroPoliza;
	}
	public void setNumeroPoliza(String numeroPoliza) {
		this.numeroPoliza = numeroPoliza;
	}
	public String getNumErrPol() {
		return numErrPol;
	}
	public void setNumErrPol(String numErrPol) {
		this.numErrPol = numErrPol;
	}
	public String getErrMenPol() {
		return errMenPol;
	}
	public void setErrMenPol(String errMenPol) {
		this.errMenPol = errMenPol;
	}
	public String getDescProceso() {
		return descProceso;
	}
	public void setDescProceso(String descProceso) {
		this.descProceso = descProceso;
	}
	public String getMovimiento() {
		return movimiento;
	}
	public void setMovimiento(String movimiento) {
		this.movimiento = movimiento;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getNomInstitucion() {
		return nomInstitucion;
	}
	public void setNomInstitucion(String nomInstitucion) {
		this.nomInstitucion = nomInstitucion;
	}
	public String getNumCtaBancaria() {
		return numCtaBancaria;
	}
	public void setNumCtaBancaria(String numCtaBancaria) {
		this.numCtaBancaria = numCtaBancaria;
	}
	
	public String getTipoDoc() {
		return tipoDoc;
	}
	public void setTipoDoc(String tipoDoc) {
		this.tipoDoc = tipoDoc;
	}
	
	public String getPagadorID() {
		return pagadorID;
	}
	public void setPagadorID(String pagadorID) {
		this.pagadorID = pagadorID;
	}
	public String getNomPagador() {
		return nomPagador;
	}
	public void setNomPagador(String nomPagador) {
		this.nomPagador = nomPagador;
	}
	public String getImporte() {
		return importe;
	}
	public void setImporte(String importe) {
		this.importe = importe;
	}
	public String getMetodoPago() {
		return metodoPago;
	}
	public void setMetodoPago(String metodoPago) {
		this.metodoPago = metodoPago;
	}
	public String getInstOrigenID() {
		return instOrigenID;
	}
	public void setInstOrigenID(String instOrigenID) {
		this.instOrigenID = instOrigenID;
	}
	public String getNomInstOrigen() {
		return nomInstOrigen;
	}
	public void setNomInstOrigen(String nomInstOrigen) {
		this.nomInstOrigen = nomInstOrigen;
	}
	public String getCtaClabeOrigen() {
		return ctaClabeOrigen;
	}
	public void setCtaClabeOrigen(String ctaClabeOrigen) {
		this.ctaClabeOrigen = ctaClabeOrigen;
	}
	public String getMonedaIDDoc() {
		return monedaIDDoc;
	}
	public void setMonedaIDDoc(String monedaIDDoc) {
		this.monedaIDDoc = monedaIDDoc;
	}
	public String getDescMoneda() {
		return descMoneda;
	}
	public void setDescMoneda(String descMoneda) {
		this.descMoneda = descMoneda;
	}
	public String getTipoCambio() {
		return tipoCambio;
	}
	public void setTipoCambio(String tipoCambio) {
		this.tipoCambio = tipoCambio;
	}
	public String getNumCheque() {
		return numCheque;
	}
	public void setNumCheque(String numCheque) {
		this.numCheque = numCheque;
	}
	public String getCuentaClabe() {
		return cuentaClabe;
	}
	public void setCuentaClabe(String cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
	}
	public String getReferenciaDoc() {
		return referenciaDoc;
	}
	public void setReferenciaDoc(String referenciaDoc) {
		this.referenciaDoc = referenciaDoc;
	}
	
}
