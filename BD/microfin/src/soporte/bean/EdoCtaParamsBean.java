package soporte.bean;

import general.bean.BaseBean;


public class EdoCtaParamsBean extends BaseBean{
		private String montoMin;
		private String rutaExpPDF;
		private String rutaReporte;		
	
		private String ciudadUEAUID;
		private String ciudadUEAU;
		private String telefonoUEAU;
		private String otrasCiuUEAU;
		private String horarioUEAU;
		private String direccionUEAU;
		private String correoUEAU; 
		private String rutaCBB;
		private String rutaCFDI;
		private String rutaLogo;
		private String extTelefonoPart;
		private String extTelefono;
		private String tipoCuentaID;
		private String descripCuenta;
		private String envioAutomatico;
		private String correoRemitente;
		private String servidorSMTP;
		private String puertoSMTP;
		private String usuarioRemitente;
		private String contraseniaRemitente;
		private String asunto;
		private String cuerpoTexto;
		private String requiereAut;
		private String tipoAut;
		private String anioMes;
		private String tokenSW;
		private String uRLWSSmarterWeb;
				
		private String empresaID;
		private String usuario;
		private String fechaActual;
		private String direccionIP;		
		private String programaID;
		private String sucursal;
		private String numTransaccion;
		
		// Ruta del aplicativo data-integration para el proceso de EdoCta
		private String rutaPDI;		
		private String prefijoEmpresa;
		
		public String getMontoMin() {
			return montoMin;
		}
		public void setMontoMin(String montoMin) {
			this.montoMin = montoMin;
		}
		public String getRutaExpPDF() {
			return rutaExpPDF;
		}
		public void setRutaExpPDF(String rutaExpPDF) {
			this.rutaExpPDF = rutaExpPDF;
		}
		public String getRutaReporte() {
			return rutaReporte;
		}
		public void setRutaReporte(String rutaReporte) {
			this.rutaReporte = rutaReporte;
		}
		public String getCiudadUEAUID() {
			return ciudadUEAUID;
		}
		public void setCiudadUEAUID(String ciudadUEAUID) {
			this.ciudadUEAUID = ciudadUEAUID;
		}
		public String getCiudadUEAU() {
			return ciudadUEAU;
		}
		public void setCiudadUEAU(String ciudadUEAU) {
			this.ciudadUEAU = ciudadUEAU;
		}
		public String getTelefonoUEAU() {
			return telefonoUEAU;
		}
		public void setTelefonoUEAU(String telefonoUEAU) {
			this.telefonoUEAU = telefonoUEAU;
		}
		public String getOtrasCiuUEAU() {
			return otrasCiuUEAU;
		}
		public void setOtrasCiuUEAU(String otrasCiuUEAU) {
			this.otrasCiuUEAU = otrasCiuUEAU;
		}
		public String getHorarioUEAU() {
			return horarioUEAU;
		}
		public void setHorarioUEAU(String horarioUEAU) {
			this.horarioUEAU = horarioUEAU;
		}
		public String getDireccionUEAU() {
			return direccionUEAU;
		}
		public void setDireccionUEAU(String direccionUEAU) {
			this.direccionUEAU = direccionUEAU;
		}
		public String getCorreoUEAU() {
			return correoUEAU;
		}
		public void setCorreoUEAU(String correoUEAU) {
			this.correoUEAU = correoUEAU;
		}			
		public String getRutaCBB() {
			return rutaCBB;
		}
		public void setRutaCBB(String rutaCBB) {
			this.rutaCBB = rutaCBB;
		}
		public String getRutaCFDI() {
			return rutaCFDI;
		}
		public void setRutaCFDI(String rutaCFDI) {
			this.rutaCFDI = rutaCFDI;
		}
		public String getTokenSW() {
			return tokenSW;
		}
		public void setTokenSW(String tokenSW) {
			this.tokenSW = tokenSW;
		}
		public String getuRLWSSmarterWeb() {
			return uRLWSSmarterWeb;
		}
		public void setuRLWSSmarterWeb(String uRLWSSmarterWeb) {
			this.uRLWSSmarterWeb = uRLWSSmarterWeb;
		}
		
		
		public String getAnioMes() {
			return anioMes;
		}
		public void setAnioMes(String anioMes) {
			this.anioMes = anioMes;
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
		public String getRutaLogo() {
			return rutaLogo;
		}
		public void setRutaLogo(String rutaLogo) {
			this.rutaLogo = rutaLogo;
		}
		public String getExtTelefonoPart() {
			return extTelefonoPart;
		}
		public void setExtTelefonoPart(String extTelefonoPart) {
			this.extTelefonoPart = extTelefonoPart;
		}
		public String getExtTelefono() {
			return extTelefono;
		}
		public void setExtTelefono(String extTelefono) {
			this.extTelefono = extTelefono;
		}

		public String getDescripCuenta() {
			return descripCuenta;
		}
		public void setDescripCuenta(String descripCuenta) {
			this.descripCuenta = descripCuenta;
		}
		public String getTipoCuentaID() {
			return tipoCuentaID;
		}
		public void setTipoCuentaID(String tipoCuentaID) {
			this.tipoCuentaID = tipoCuentaID;
		}
		public String getEnvioAutomatico() {
			return envioAutomatico;
		}
		public void setEnvioAutomatico(String envioAutomatico) {
			this.envioAutomatico = envioAutomatico;
		}
		public String getCorreoRemitente() {
			return correoRemitente;
		}
		public void setCorreoRemitente(String correoRemitente) {
			this.correoRemitente = correoRemitente;
		}
		public String getServidorSMTP() {
			return servidorSMTP;
		}
		public void setServidorSMTP(String servidorSMTP) {
			this.servidorSMTP = servidorSMTP;
		}
		public String getPuertoSMTP() {
			return puertoSMTP;
		}
		public void setPuertoSMTP(String puertoSMTP) {
			this.puertoSMTP = puertoSMTP;
		}
		public String getUsuarioRemitente() {
			return usuarioRemitente;
		}
		public void setUsuarioRemitente(String usuarioRemitente) {
			this.usuarioRemitente = usuarioRemitente;
		}
		public String getContraseniaRemitente() {
			return contraseniaRemitente;
		}
		public void setContraseniaRemitente(String contraseniaRemitente) {
			this.contraseniaRemitente = contraseniaRemitente;
		}
		public String getAsunto() {
			return asunto;
		}
		public void setAsunto(String asunto) {
			this.asunto = asunto;
		}
		public String getCuerpoTexto() {
			return cuerpoTexto;
		}
		public void setCuerpoTexto(String cuerpoTexto) {
			this.cuerpoTexto = cuerpoTexto;
		}
		public String getRequiereAut() {
			return requiereAut;
		}
		public void setRequiereAut(String requiereAut) {
			this.requiereAut = requiereAut;
		}
		public String getTipoAut() {
			return tipoAut;
		}
		public void setTipoAut(String tipoAut) {
			this.tipoAut = tipoAut;
		}
		public String getRutaPDI() {
			return rutaPDI;
		}
		public void setRutaPDI(String rutaPDI) {
			this.rutaPDI = rutaPDI;
		}
		public String getPrefijoEmpresa() {
			return prefijoEmpresa;
		}
		public void setPrefijoEmpresa(String prefijoEmpresa) {
			this.prefijoEmpresa = prefijoEmpresa;
		}
		
		
}
