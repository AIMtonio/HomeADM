package credito.bean;

 
import general.bean.BaseBean;

public class IntegraGruposDetalleBean extends BaseBean{
	
	private String solicitudCreditoID;
	private String nombre;
	private String clienteID;
	private String prospectoID;
	private String productoCreditoID;
	private String montoSol;
	private String montoAu;
	private String interes;
	private String montoGarantia;
	private String montoComApertura;
	private String IVAComisionApert;
	private String cargo;
	private String fechaVencimiento; // auxiliar en pantalla de alta de credito Grupal
	private String sexo;
	private String estadoCivil;
	private String ciclo;
	private String montoSeguroVida;
	private String forCobroSegVida;

	private String montoOriginal;
	private String forCobroComAper;
	private String montoComIva;
	
	//auxiliares en pantalla mesa de control
	private String credCheckComp;  //Para saber si tiene la documentacion completa
	private String estatus;			// estatus del credito
	private String cuentaID;
	private String creditoID;          
	private String productoDescri;
	private String fechaRegistro;     
	private String solEstatus;         
	private String integEstatus; 
	private String comentarioEjecutivo;
	private String requiereGarantia;
	private String requiereAvales;
	private String perAvaCruzados;
	private String perGarCruzadas;
	private String fechaInicio;
	private String comentarioMesaControl;//Auxiliar para la lista(5) de integrantes(pantalla mesa de control)
	private String tipoPrepago;  // utilizado en grid 
	private String mostrarTipoPrepago;
	private String calificaCredito;
	private String pagaIVA;
	
	private String descuentoSeguro;
	private String montoSegOriginal;

	// Propiedades agregadas para usarse en el contrato
	private String destinoCredito; // Descripción del destino de credito
	private String RFC;
	private String domicilio;
	private String folioIdentificacion;

	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getProductoDescri() {
		return productoDescri;
	}
	public void setProductoDescri(String productoDescri) {
		this.productoDescri = productoDescri;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getSolEstatus() {
		return solEstatus;
	}
	public void setSolEstatus(String solEstatus) {
		this.solEstatus = solEstatus;
	}
	public String getIntegEstatus() {
		return integEstatus;
	}
	public void setIntegEstatus(String integEstatus) {
		this.integEstatus = integEstatus;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public String getMontoSol() {
		return montoSol;
	}
	public void setMontoSol(String montoSol) {
		this.montoSol = montoSol;
	}
	public String getMontoAu() {
		return montoAu;
	}
	public void setMontoAu(String montoAu) {
		this.montoAu = montoAu;
	}
	public String getCargo() {
		return cargo;
	}
	public void setCargo(String cargo) {
		this.cargo = cargo;
	}
	
	public String getCredCheckComp() {
		return credCheckComp;
	}
	public void setCredCheckComp(String credCheckComp) {
		this.credCheckComp = credCheckComp;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getCuentaID() {
		return cuentaID;
	}
	public void setCuentaID(String cuentaID) {
		this.cuentaID = cuentaID;
	}
	public String getComentarioEjecutivo() {
		return comentarioEjecutivo;
	}
	public void setComentarioEjecutivo(String comentarioEjecutivo) {
		this.comentarioEjecutivo = comentarioEjecutivo;
	}
	
	public String getRequiereGarantia() {
		return requiereGarantia;
	}
	public void setRequiereGarantia(String requiereGarantia) {
		this.requiereGarantia = requiereGarantia;
	}
	public String getRequiereAvales() {
		return requiereAvales;
	}
	public void setRequiereAvales(String requiereAvales) {
		this.requiereAvales = requiereAvales;
	}
	public String getPerAvaCruzados() {
		return perAvaCruzados;
	}
	public void setPerAvaCruzados(String perAvaCruzados) {
		this.perAvaCruzados = perAvaCruzados;
	}
	public String getPerGarCruzadas() {
		return perGarCruzadas;
	}
	public void setPerGarCruzadas(String perGarCruzadas) {
		this.perGarCruzadas = perGarCruzadas;
	}
	public String getComentarioMesaControl() {
		return comentarioMesaControl;
	}
	public void setComentarioMesaControl(String comentarioMesaControl) {
		this.comentarioMesaControl = comentarioMesaControl;
	}
	public String getSexo() {
		return sexo;
	}
	public void setSexo(String sexo) {
		this.sexo = sexo;
	}
	public String getEstadoCivil() {
		return estadoCivil;
	}
	public void setEstadoCivil(String estadoCivil) {
		this.estadoCivil = estadoCivil;
	}
	public String getCiclo() {
		return ciclo;
	}
	public void setCiclo(String ciclo) {
		this.ciclo = ciclo;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getMontoSeguroVida() {
		return montoSeguroVida;
	}
	public void setMontoSeguroVida(String montoSeguroVida) {
		this.montoSeguroVida = montoSeguroVida;
	}
	public String getForCobroSegVida() {
		return forCobroSegVida;
	}
	public void setForCobroSegVida(String forCobroSegVida) {
		this.forCobroSegVida = forCobroSegVida;
	}
	public String getMontoOriginal() {
		return montoOriginal;
	}
	public void setMontoOriginal(String montoOriginal) {
		this.montoOriginal = montoOriginal;
	}
	public String getForCobroComAper() {
		return forCobroComAper;
	}
	public void setForCobroComAper(String forCobroComAper) {
		this.forCobroComAper = forCobroComAper;
	}
	public String getMontoComIva() {
		return montoComIva;
	}
	public void setMontoComIva(String montoComIva) {
		this.montoComIva = montoComIva;
	}
	public String getTipoPrepago() {
		return tipoPrepago;
	}
	public void setTipoPrepago(String tipoPrepago) {
		this.tipoPrepago = tipoPrepago;
	}
	public String getMostrarTipoPrepago() {
		return mostrarTipoPrepago;
	}
	public void setMostrarTipoPrepago(String mostrarTipoPrepago) {
		this.mostrarTipoPrepago = mostrarTipoPrepago;
	}
	public String getCalificaCredito() {
		return calificaCredito;
	}
	public void setCalificaCredito(String calificaCredito) {
		this.calificaCredito = calificaCredito;
	}
	public String getPagaIVA() {
		return pagaIVA;
	}
	public void setPagaIVA(String pagaIVA) {
		this.pagaIVA = pagaIVA;
	}
	public String getDescuentoSeguro() {
		return descuentoSeguro;
	}
	public void setDescuentoSeguro(String descuentoSeguro) {
		this.descuentoSeguro = descuentoSeguro;
	}
	public String getMontoSegOriginal() {
		return montoSegOriginal;
	}
	public void setMontoSegOriginal(String montoSegOriginal) {
		this.montoSegOriginal = montoSegOriginal;
	}
	public String getInteres() {
		return interes;
	}
	public void setInteres(String interes) {
		this.interes = interes;
	}
	public String getMontoGarantia() {
		return montoGarantia;
	}
	public void setMontoGarantia(String montoGarantia) {
		this.montoGarantia = montoGarantia;
	}
	public String getMontoComApertura() {
		return montoComApertura;
	}
	public void setMontoComApertura(String montoComApertura) {
		this.montoComApertura = montoComApertura;
	}
	public String getIVAComisionApert() {
		return IVAComisionApert;
	}
	public void setIVAComisionApert(String iVAComisionApert) {
		IVAComisionApert = iVAComisionApert;
	}
	public String getDestinoCredito(){
		return destinoCredito;
	}
	public void setDestinoCredito(String destinoCredito){
		this.destinoCredito = destinoCredito;
	}
	public String getRFC(){
		return RFC;
	}
	public void setRFC(String RFC){
		this.RFC = RFC;
	}
	public String getDomicilio(){
		return domicilio;
	}
	public void setDomicilio(String domicilio){
		this.domicilio = domicilio;
	}
	public String getFolioIdentificacion(){
		return folioIdentificacion;
	}
	public void setFolioIdentificacion(String folioIdentificacion){
		this.folioIdentificacion = folioIdentificacion;
	}
}
