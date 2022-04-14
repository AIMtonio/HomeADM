
package cliente.bean;

import general.bean.BaseBean;
public class ClienteExMenorBean extends BaseBean{
	//Declaracion de Constantes
	public static int LONGITUD_ID = 10;
	public static int LONGITUDSUC_ID = 3;
	private String clienteID;
	private String cuentaAhoID;
	private String usuario;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
	private String tipoCuentaID;
	private String nombreInstitucion;
	private String sucursalID;
	private String nombreCompleto;
	private String saldoAhorro;
	private String estatusCta;
	private String fechaCancela;
	private String estatusRetiro;
	private String fechaRetiro;
	private String descripcion;
	private String tipoOperacion;
	private String cajaID;
	private String tipoIdentidad;
	private String folioIdentificacion;
	
	//bean para reporte 
	private String fechaInicial;
	private String fechaFinal;
	private String sucursalInicial;
	private String sucursalFinal;
	private String nombreUsuario;
	private String fechaEmision;
	private String nomSucursalInicial;
	private String nomSucursalFinal;
	private String nombreSucursal;
	private String horaEmision;
	private String polizaID;
	private String conceptoCon;
	
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
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
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
	public String getTipoCuentaID() {
		return tipoCuentaID;
	}
	public void setTipoCuentaID(String tipoCuentaID) {
		this.tipoCuentaID = tipoCuentaID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getSaldoAhorro() {
		return saldoAhorro;
	}
	public void setSaldoAhorro(String saldoAhorro) {
		this.saldoAhorro = saldoAhorro;
	}
	public String getEstatusCta() {
		return estatusCta;
	}
	public void setEstatusCta(String estatusCta) {
		this.estatusCta = estatusCta;
	}
	public String getFechaCancela() {
		return fechaCancela;
	}
	public void setFechaCancela(String fechaCancela) {
		this.fechaCancela = fechaCancela;
	}
	public String getEstatusRetiro() {
		return estatusRetiro;
	}
	public void setEstatusRetiro(String estatusRetiro) {
		this.estatusRetiro = estatusRetiro;
	}
	public String getFechaRetiro() {
		return fechaRetiro;
	}
	public void setFechaRetiro(String fechaRetiro) {
		this.fechaRetiro = fechaRetiro;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getTipoOperacion() {
		return tipoOperacion;
	}
	public void setTipoOperacion(String tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
	}
	public String getCajaID() {
		return cajaID;
	}
	public void setCajaID(String cajaID) {
		this.cajaID = cajaID;
	}
	public String getTipoIdentidad() {
		return tipoIdentidad;
	}
	public void setTipoIdentidad(String tipoIdentidad) {
		this.tipoIdentidad = tipoIdentidad;
	}
	public String getFolioIdentificacion() {
		return folioIdentificacion;
	}
	public void setFolioIdentificacion(String folioIdentificacion) {
		this.folioIdentificacion = folioIdentificacion;
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
	public String getSucursalInicial() {
		return sucursalInicial;
	}
	public void setSucursalInicial(String sucursalInicial) {
		this.sucursalInicial = sucursalInicial;
	}
	public String getSucursalFinal() {
		return sucursalFinal;
	}
	public void setSucursalFinal(String sucursalFinal) {
		this.sucursalFinal = sucursalFinal;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getNomSucursalInicial() {
		return nomSucursalInicial;
	}
	public void setNomSucursalInicial(String nomSucursalInicial) {
		this.nomSucursalInicial = nomSucursalInicial;
	}
	public String getNomSucursalFinal() {
		return nomSucursalFinal;
	}
	public void setNomSucursalFinal(String nomSucursalFinal) {
		this.nomSucursalFinal = nomSucursalFinal;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getHoraEmision() {
		return horaEmision;
	}
	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public String getConceptoCon() {
		return conceptoCon;
	}
	public void setConceptoCon(String conceptoCon) {
		this.conceptoCon = conceptoCon;
	}	

}