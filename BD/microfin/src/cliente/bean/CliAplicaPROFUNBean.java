package cliente.bean;

import general.bean.*;

import org.springframework.web.multipart.MultipartFile;
public class CliAplicaPROFUNBean extends BaseBean {
	
	public static int LONGITUD_ID = 10;
	
	//Parámetros de la Tabla
	private String clienteID; //id del cliente
	private String cuentaAhoID; //cuenta de ahorro del cliente
	private String usuarioReg; //usuario que registra
	private String fechaRegistro; //fecha deregistro
	private String fechaAplica; //fecha que aplica
	private String monto; //monto aplicado
	private String comentario;
	private String usuarioAuto; //usuario que autoriza
	private String fechaAutoriza; // fecha de autorizacion
	private String estatus; // estatus
	private String transaccion; // numero de transaccion

	private String usuarioRechaza;
	private String fechaRechaza;
	private String motivoRechazo;
	private String aplicadoSocios;
	
	private MultipartFile tipoDocumento; // documentos que sre adjuntaran
	private String contrasenia; //contraseña al loguearse
	private String nombreCompleto; // nombre completo
	private String recurso; // recurso
	private String nombreBene; // Nombre de beneficiado que se mostrara en ventanilla
	private String parentesco;	//Parentesco del beneficiado que se mostrara en ventanilla
	private String saldoDisponProfun;	//Saldo disponible del beneficiadoa que se mostrara en ventanilla
	private String porcentaje;	//Porcentaje que le corresponde al beneficiario que se mostrara en ventanilla 
	private String clientePROFUN; // Numero de cliente PROFUN usado en ventanilla
	private String personaID; // ID del beneficiado que recibirá el pago PROFUN
	private String altaPoliza; // alta de la poliza
	private String altaDetPol; // detalle de la poliza
	private String recibePago; // saber si recibe elpago
	private	String personaRetiraPagoPROFUN; // Persona que recibe el dinero 
	private String montoTotalPROFUN; // monto total de PROFUN
	
	private String fechaInicioPROFUN; //fecha de inicio profun
	private String fechaFinalPROFUN; // fecha final profun
	private String pdfPROFUN; 
	private String excelPROFUN;
	private String poliza; // poliza
	private String actaDefuncionProfun;// Acta de defuncion
	private String fechaDefuncionProfun; // Fechade defuncion
	private String montoParamCaja;// monto parametro caja
				
	//Parámetros de auditoria
	private String empresaID;
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getUsuarioReg() {
		return usuarioReg;
	}
	public void setUsuarioReg(String usuarioReg) {
		this.usuarioReg = usuarioReg;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getFechaAplica() {
		return fechaAplica;
	}
	public void setFechaAplica(String fechaAplica) {
		this.fechaAplica = fechaAplica;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getComentario() {
		return comentario;
	}
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}
	public String getUsuarioAuto() {
		return usuarioAuto;
	}
	public void setUsuarioAuto(String usuarioAuto) {
		this.usuarioAuto = usuarioAuto;
	}
	public String getFechaAutoriza() {
		return fechaAutoriza;
	}
	public void setFechaAutoriza(String fechaAutoriza) {
		this.fechaAutoriza = fechaAutoriza;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getTransaccion() {
		return transaccion;
	}
	public void setTransaccion(String transaccion) {
		this.transaccion = transaccion;
	}
	public String getUsuarioRechaza() {
		return usuarioRechaza;
	}
	public void setUsuarioRechaza(String usuarioRechaza) {
		this.usuarioRechaza = usuarioRechaza;
	}
	public String getFechaRechaza() {
		return fechaRechaza;
	}
	public void setFechaRechaza(String fechaRechaza) {
		this.fechaRechaza = fechaRechaza;
	}
	public String getMotivoRechazo() {
		return motivoRechazo;
	}
	public void setMotivoRechazo(String motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}
	public String getAplicadoSocios() {
		return aplicadoSocios;
	}
	public void setAplicadoSocios(String aplicadoSocios) {
		this.aplicadoSocios = aplicadoSocios;
	}
	public MultipartFile getTipoDocumento() {
		return tipoDocumento;
	}
	public void setTipoDocumento(MultipartFile tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}
	public String getContrasenia() {
		return contrasenia;
	}
	public void setContrasenia(String contrasenia) {
		this.contrasenia = contrasenia;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getRecurso() {
		return recurso;
	}
	public void setRecurso(String recurso) {
		this.recurso = recurso;
	}
	public String getNombreBene() {
		return nombreBene;
	}
	public void setNombreBene(String nombreBene) {
		this.nombreBene = nombreBene;
	}
	public String getParentesco() {
		return parentesco;
	}
	public void setParentesco(String parentesco) {
		this.parentesco = parentesco;
	}
	public String getSaldoDisponProfun() {
		return saldoDisponProfun;
	}
	public void setSaldoDisponProfun(String saldoDisponProfun) {
		this.saldoDisponProfun = saldoDisponProfun;
	}
	public String getPorcentaje() {
		return porcentaje;
	}
	public void setPorcentaje(String porcentaje) {
		this.porcentaje = porcentaje;
	}
	public String getClientePROFUN() {
		return clientePROFUN;
	}
	public void setClientePROFUN(String clientePROFUN) {
		this.clientePROFUN = clientePROFUN;
	}
	public String getPersonaID() {
		return personaID;
	}
	public void setPersonaID(String personaID) {
		this.personaID = personaID;
	}
	public String getAltaPoliza() {
		return altaPoliza;
	}
	public void setAltaPoliza(String altaPoliza) {
		this.altaPoliza = altaPoliza;
	}
	public String getAltaDetPol() {
		return altaDetPol;
	}
	public void setAltaDetPol(String altaDetPol) {
		this.altaDetPol = altaDetPol;
	}
	public String getRecibePago() {
		return recibePago;
	}
	public void setRecibePago(String recibePago) {
		this.recibePago = recibePago;
	}
	public String getPersonaRetiraPagoPROFUN() {
		return personaRetiraPagoPROFUN;
	}
	public void setPersonaRetiraPagoPROFUN(String personaRetiraPagoPROFUN) {
		this.personaRetiraPagoPROFUN = personaRetiraPagoPROFUN;
	}
	public String getMontoTotalPROFUN() {
		return montoTotalPROFUN;
	}
	public void setMontoTotalPROFUN(String montoTotalPROFUN) {
		this.montoTotalPROFUN = montoTotalPROFUN;
	}
	public String getFechaInicioPROFUN() {
		return fechaInicioPROFUN;
	}
	public void setFechaInicioPROFUN(String fechaInicioPROFUN) {
		this.fechaInicioPROFUN = fechaInicioPROFUN;
	}
	public String getFechaFinalPROFUN() {
		return fechaFinalPROFUN;
	}
	public void setFechaFinalPROFUN(String fechaFinalPROFUN) {
		this.fechaFinalPROFUN = fechaFinalPROFUN;
	}
	public String getPdfPROFUN() {
		return pdfPROFUN;
	}
	public void setPdfPROFUN(String pdfPROFUN) {
		this.pdfPROFUN = pdfPROFUN;
	}
	public String getExcelPROFUN() {
		return excelPROFUN;
	}
	public void setExcelPROFUN(String excelPROFUN) {
		this.excelPROFUN = excelPROFUN;
	}
	public String getPoliza() {
		return poliza;
	}
	public void setPoliza(String poliza) {
		this.poliza = poliza;
	}
	public String getActaDefuncionProfun() {
		return actaDefuncionProfun;
	}
	public void setActaDefuncionProfun(String actaDefuncionProfun) {
		this.actaDefuncionProfun = actaDefuncionProfun;
	}
	public String getFechaDefuncionProfun() {
		return fechaDefuncionProfun;
	}
	public void setFechaDefuncionProfun(String fechaDefuncionProfun) {
		this.fechaDefuncionProfun = fechaDefuncionProfun;
	}
	public String getMontoParamCaja() {
		return montoParamCaja;
	}
	public void setMontoParamCaja(String montoParamCaja) {
		this.montoParamCaja = montoParamCaja;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
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
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}					
}
