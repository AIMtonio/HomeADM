package tesoreria.bean;

import general.bean.BaseBean;

public class CuentasSantanderBean extends BaseBean{

	private String fechaInicio;
	private String fechaFin;
	private String estatus;
	private String tipoCta;
	private String numeroCta;
	private String titular;
	private String claveBanco;
	private String pazaBanxico;
	private String sucursal;
	private String cuentaClabe;
	private String benefAppPaterno;
	private String benefAppMaterno;
	private String benefNombre;
	private String benefDireccion;
	private String benefCiudad;
	private String codigoRechazo;
	private String tipoCtaID;
	private String subirCtasActivas;
	private String subirCtasPendientes;
	
	//Respuesta Banco Santander
	private String rutaArchCtasActivas;
	private String rutaArchCtasPendientes;
	private String archCtasActivas;
	private String archCtasPendientes;
	private String fechaSistema;
	private String extensionArch1;
	private String extensionArch2;
	private String delimitador1;
	private String delimitador2;
	private String archivoProceso;
	private String tipoArchivo;
	
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaFin() {
		return fechaFin;
	}	
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getTipoCta() {
		return tipoCta;
	}
	public void setTipoCta(String tipoCta) {
		this.tipoCta = tipoCta;
	}
	public String getNumeroCta() {
		return numeroCta;
	}
	public void setNumeroCta(String numeroCta) {
		this.numeroCta = numeroCta;
	}
	public String getTitular() {
		return titular;
	}
	public void setTitular(String titular) {
		this.titular = titular;
	}
	public String getClaveBanco() {
		return claveBanco;
	}
	public void setClaveBanco(String claveBanco) {
		this.claveBanco = claveBanco;
	}
	public String getPazaBanxico() {
		return pazaBanxico;
	}
	public void setPazaBanxico(String pazaBanxico) {
		this.pazaBanxico = pazaBanxico;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getCuentaClabe() {
		return cuentaClabe;
	}
	public void setCuentaClabe(String cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
	}
	public String getBenefAppPaterno() {
		return benefAppPaterno;
	}
	public void setBenefAppPaterno(String benefAppPaterno) {
		this.benefAppPaterno = benefAppPaterno;
	}
	public String getBenefAppMaterno() {
		return benefAppMaterno;
	}
	public void setBenefAppMaterno(String benefAppMaterno) {
		this.benefAppMaterno = benefAppMaterno;
	}
	public String getBenefNombre() {
		return benefNombre;
	}
	public void setBenefNombre(String benefNombre) {
		this.benefNombre = benefNombre;
	}
	public String getBenefDireccion() {
		return benefDireccion;
	}
	public void setBenefDireccion(String benefDireccion) {
		this.benefDireccion = benefDireccion;
	}
	public String getBenefCiudad() {
		return benefCiudad;
	}
	public void setBenefCiudad(String benefCiudad) {
		this.benefCiudad = benefCiudad;
	}
	public String getCodigoRechazo() {
		return codigoRechazo;
	}
	public void setCodigoRechazo(String codigoRechazo) {
		this.codigoRechazo = codigoRechazo;
	}
	public String getTipoCtaID() {
		return tipoCtaID;
	}
	public void setTipoCtaID(String tipoCtaID) {
		this.tipoCtaID = tipoCtaID;
	}
	public String getSubirCtasActivas() {
		return subirCtasActivas;
	}
	public void setSubirCtasActivas(String subirCtasActivas) {
		this.subirCtasActivas = subirCtasActivas;
	}
	public String getSubirCtasPendientes() {
		return subirCtasPendientes;
	}
	public void setSubirCtasPendientes(String subirCtasPendientes) {
		this.subirCtasPendientes = subirCtasPendientes;
	}
	public String getArchCtasActivas() {
		return archCtasActivas;
	}
	public void setArchCtasActivas(String archCtasActivas) {
		this.archCtasActivas = archCtasActivas;
	}
	public String getArchCtasPendientes() {
		return archCtasPendientes;
	}
	public void setArchCtasPendientes(String archCtasPendientes) {
		this.archCtasPendientes = archCtasPendientes;
	}
	public String getRutaArchCtasActivas() {
		return rutaArchCtasActivas;
	}
	public void setRutaArchCtasActivas(String rutaArchCtasActivas) {
		this.rutaArchCtasActivas = rutaArchCtasActivas;
	}
	public String getRutaArchCtasPendientes() {
		return rutaArchCtasPendientes;
	}
	public void setRutaArchCtasPendientes(String rutaArchCtasPendientes) {
		this.rutaArchCtasPendientes = rutaArchCtasPendientes;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getExtensionArch1() {
		return extensionArch1;
	}
	public void setExtensionArch1(String extensionArch1) {
		this.extensionArch1 = extensionArch1;
	}
	public String getExtensionArch2() {
		return extensionArch2;
	}
	public void setExtensionArch2(String extensionArch2) {
		this.extensionArch2 = extensionArch2;
	}
	public String getDelimitador1() {
		return delimitador1;
	}
	public void setDelimitador1(String delimitador1) {
		this.delimitador1 = delimitador1;
	}
	public String getDelimitador2() {
		return delimitador2;
	}
	public void setDelimitador2(String delimitador2) {
		this.delimitador2 = delimitador2;
	}
	public String getArchivoProceso() {
		return archivoProceso;
	}
	public void setArchivoProceso(String archivoProceso) {
		this.archivoProceso = archivoProceso;
	}
	public String getTipoArchivo() {
		return tipoArchivo;
	}
	public void setTipoArchivo(String tipoArchivo) {
		this.tipoArchivo = tipoArchivo;
	}
	
	
}
