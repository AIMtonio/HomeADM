package invkubo.bean;

import general.bean.BaseBean;

public class FondeoSolicitudBean extends BaseBean{
	
		private String 	solFondeoID;
		private String 	solicitudCreditoID;
		private String	consecutivo;
		private String	clienteID;
		private String	cuentaID;
		private String	fechaRegistro;
		private String	montoFondeo;
		private String	porcentajeFondeo;
		private String	monedaID;
		private String	estatus;
		private String	tasaActiva;
		private String	tasaPasiva;
		private String	fondeoKuboID;
		private String	tipoFondeadorID;
		private String	margen;	//para almacenar el calculo del margen
		private String	porcentaje;	//para almacenar el calculo del porcentaje del monto total
		private String	montoTotal;	//para almacenar el calculo del monto total
		private	String	nombreCompleto;
		private	String	rfcCliente;
		private	String	nivelRiesgoCliente;
		
		private String empresaID;
		private String usuario;
		private String sucursal;
		private String fechaActual;
		private String direccionIP;
		private String programaID;
		private String numTransaccion;
		
		
		public String getSolicitudCreditoID() {
			return solicitudCreditoID;
		}
		public void setSolicitudCreditoID(String solicitudCreditoID) {
			this.solicitudCreditoID = solicitudCreditoID;
		}
		public String getConsecutivo() {
			return consecutivo;
		}
		public void setConsecutivo(String consecutivo) {
			this.consecutivo = consecutivo;
		}
		public String getClienteID() {
			return clienteID;
		}
		public void setClienteID(String clienteID) {
			this.clienteID = clienteID;
		}
		public String getCuentaID() {
			return cuentaID;
		}
		public void setCuentaID(String cuentaID) {
			this.cuentaID = cuentaID;
		}
		public String getFechaRegistro() {
			return fechaRegistro;
		}
		public void setFechaRegistro(String fechaRegistro) {
			this.fechaRegistro = fechaRegistro;
		}
		public String getMontoFondeo() {
			return montoFondeo;
		}
		public void setMontoFondeo(String montoFondeo) {
			this.montoFondeo = montoFondeo;
		}
		public String getPorcentajeFondeo() {
			return porcentajeFondeo;
		}
		public void setPorcentajeFondeo(String porcentajeFondeo) {
			this.porcentajeFondeo = porcentajeFondeo;
		}
		public String getMonedaID() {
			return monedaID;
		}
		public void setMonedaID(String monedaID) {
			this.monedaID = monedaID;
		}
		public String getEstatus() {
			return estatus;
		}
		public void setEstatus(String estatus) {
			this.estatus = estatus;
		}
		public String getTasaActiva() {
			return tasaActiva;
		}
		public void setTasaActiva(String tasaActiva) {
			this.tasaActiva = tasaActiva;
		}
		public String getTasaPasiva() {
			return tasaPasiva;
		}
		public void setTasaPasiva(String tasaPasiva) {
			this.tasaPasiva = tasaPasiva;
		}
		public String getFondeoKuboID() {
			return fondeoKuboID;
		}
		public void setFondeoKuboID(String fondeoKuboID) {
			this.fondeoKuboID = fondeoKuboID;
		}
		public String getTipoFondeadorID() {
			return tipoFondeadorID;
		}
		public void setTipoFondeadorID(String tipoFondeadorID) {
			this.tipoFondeadorID = tipoFondeadorID;
		}
		public String getMargen() {
			return margen;
		}
		public void setMargen(String margen) {
			this.margen = margen;
		}
		public String getPorcentaje() {
			return porcentaje;
		}
		public void setPorcentaje(String porcentaje) {
			this.porcentaje = porcentaje;
		}
		public String getMontoTotal() {
			return montoTotal;
		}
		public void setMontoTotal(String montoTotal) {
			this.montoTotal = montoTotal;
		}
		public String getNombreCompleto() {
			return nombreCompleto;
		}
		public void setNombreCompleto(String nombreCompleto) {
			this.nombreCompleto = nombreCompleto;
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
		public String getRfcCliente() {
			return rfcCliente;
		}
		public void setRfcCliente(String rfcCliente) {
			this.rfcCliente = rfcCliente;
		}
		public String getSolFondeoID() {
			return solFondeoID;
		}
		public void setSolFondeoID(String solFondeoID) {
			this.solFondeoID = solFondeoID;
		}
		public String getNivelRiesgoCliente() {
			return nivelRiesgoCliente;
		}
		public void setNivelRiesgoCliente(String nivelRiesgoCliente) {
			this.nivelRiesgoCliente = nivelRiesgoCliente;
		}	
		
		
}
