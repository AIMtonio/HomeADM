package cliente.bean;

import general.bean.BaseBean;

public class CuentasBCAMovilBean extends BaseBean{
	
	private String cuentasBcaMovID;
	private String clienteID;
	private String cuentaAhoID;
	private String telefono;		
	private String usuarioPDMID;
	private String estatus;
	private String fechaRegistro;
	
	//auxiliar para la alta en pademobile
	
	private String nombreCompleto;
	private String fechaInicial;
	private String fechaFinal;
	private String nip;
	private String admin;
	private String nipadmin;
	private String idusuario;
	private String idsesion;
	private	String telefonoBD1;
	
	// Auxiliar Preguntas de Seguridad
	private String preguntaID;
	private String descripcion;
	private String respuestas;
	private String numPreguntas;
	
	// Auxiliar Contrato Medios Electronicos
	private String nombreInstitucion ; 
	private String fechaEmision;
	private String dirInst;
	private String RFCInst;
	private String telInst;
	private String representanteLegal;
	private String sucursalID;
	private String nombreSucursal;
	
	//variable para indicar que se requiere o no registro en pademovil
	private String registroPDM;
	
	public String getCuentasBcaMovID() {
		return cuentasBcaMovID;
	}
	public void setCuentasBcaMovID(String cuentasBcaMovID) {
		this.cuentasBcaMovID = cuentasBcaMovID;
	}
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
	public String getTelefono() {
		return telefono;
	}
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	public String getUsuarioPDMID() {
		return usuarioPDMID;
	}
	public void setUsuarioPDMID(String usuarioPDMID) {
		this.usuarioPDMID = usuarioPDMID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getFechaInicial() {
		return fechaInicial;
	}
	public void setFechaInicial(String fechaInicial) {
		this.fechaInicial = fechaInicial;
	}
	public String getFechaFinal() {
		return fechaFinal;
	}
	public void setFechaFinal(String fechaFinal) {
		this.fechaFinal = fechaFinal;
	}
	public String getNip() {
		return nip;
	}
	public void setNip(String nip) {
		this.nip = nip;
	}
	public String getAdmin() {
		return admin;
	}
	public void setAdmin(String admin) {
		this.admin = admin;
	}
	public String getNipadmin() {
		return nipadmin;
	}
	public void setNipadmin(String nipadmin) {
		this.nipadmin = nipadmin;
	}
	public String getIdusuario() {
		return idusuario;
	}
	public void setIdusuario(String idusuario) {
		this.idusuario = idusuario;
	}
	public String getIdsesion() {
		return idsesion;
	}
	public void setIdsesion(String idsesion) {
		this.idsesion = idsesion;
	}
	public String getTelefonoBD1() {
		return telefonoBD1;
	}
	public void setTelefonoBD1(String telefonoBD1) {
		this.telefonoBD1 = telefonoBD1;
	}
	public String getPreguntaID() {
		return preguntaID;
	}
	public void setPreguntaID(String preguntaID) {
		this.preguntaID = preguntaID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getRespuestas() {
		return respuestas;
	}
	public void setRespuestas(String respuestas) {
		this.respuestas = respuestas;
	}
	public String getNumPreguntas() {
		return numPreguntas;
	}
	public void setNumPreguntas(String numPreguntas) {
		this.numPreguntas = numPreguntas;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getDirInst() {
		return dirInst;
	}
	public void setDirInst(String dirInst) {
		this.dirInst = dirInst;
	}
	public String getRFCInst() {
		return RFCInst;
	}
	public void setRFCInst(String rFCInst) {
		RFCInst = rFCInst;
	}
	public String getTelInst() {
		return telInst;
	}
	public void setTelInst(String telInst) {
		this.telInst = telInst;
	}
	public String getRepresentanteLegal() {
		return representanteLegal;
	}
	public void setRepresentanteLegal(String representanteLegal) {
		this.representanteLegal = representanteLegal;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getRegistroPDM() {
		return registroPDM;
	}
	public void setRegistroPDM(String registroPDM) {
		this.registroPDM = registroPDM;
	}
	
}
