	package spei.bean;

	import general.bean.BaseBean;

	public class AutorizaSpeiBean extends BaseBean{
		
		public static int LONGITUD_ID = 10;
		private String cuentaBanco;
		private String fecha;
		
		private String clienteID;
		private String nombreOrd;
		private String totalCargoCuenta;
		private String tipoCuentaBen;
		private String instiReceptora;
		private String nomInstiReceptora;
		private String nombreBeneficiario;
		private String cuentaBeneficiario;
		private String comentario;
		private String folio;
		private String claveRastreo;
		private String estatusEnv;
		private String causaDevol;
		private String usuarioEnvio;
		private String estatus;
		private String descripcion;
		private String folioSpeiID;
		
		private String usuarioAutoriza;
		private String usuarioVerifica;
		private String fechaIncial;
		private String fechaFinal;
		private String origenSpei;
		
		private String empresaID; 
		private String usuario; 
		private String fechaActual; 
		private String direccionIP; 
		private String programaID; 
		private String sucursal; 
		private String numTransaccion;
		
		

		public String getFecha() {
			return fecha;
		}
		public void setFecha(String fecha) {
			this.fecha = fecha;
		}
		
		
		public String getCuentaBanco() {
			return cuentaBanco;
		}
		public void setCuentaBanco(String cuentaBanco) {
			this.cuentaBanco = cuentaBanco;
		}
		public String getClienteID() {
			return clienteID;
		}
		public void setClienteID(String clienteID) {
			this.clienteID = clienteID;
		}
		public String getNombreOrd() {
			return nombreOrd;
		}
		public void setNombreOrd(String nombreOrd) {
			this.nombreOrd = nombreOrd;
		}
		public String getTotalCargoCuenta() {
			return totalCargoCuenta;
		}
		public void setTotalCargoCuenta(String totalCargoCuenta) {
			this.totalCargoCuenta = totalCargoCuenta;
		}
		public String getTipoCuentaBen() {
			return tipoCuentaBen;
		}
		public void setTipoCuentaBen(String tipoCuentaBen) {
			this.tipoCuentaBen = tipoCuentaBen;
		}
		public String getInstiReceptora() {
			return instiReceptora;
		}
		public void setInstiReceptora(String instiReceptora) {
			this.instiReceptora = instiReceptora;
		}
		public String getNombreBeneficiario() {
			return nombreBeneficiario;
		}
		public void setNombreBeneficiario(String nombreBeneficiario) {
			this.nombreBeneficiario = nombreBeneficiario;
		}
		public String getCuentaBeneficiario() {
			return cuentaBeneficiario;
		}
		public void setCuentaBeneficiario(String cuentaBeneficiario) {
			this.cuentaBeneficiario = cuentaBeneficiario;
		}
		public String getComentario() {
			return comentario;
		}
		public void setComentario(String comentario) {
			this.comentario = comentario;
		}
		
		public String getNomInstiReceptora() {
			return nomInstiReceptora;
		}
		public void setNomInstiReceptora(String nomInstiReceptora) {
			this.nomInstiReceptora = nomInstiReceptora;
		}

		public String getFolio() {
			return folio;
		}
		public void setFolio(String folio) {
			this.folio = folio;
		}
		public String getClaveRastreo() {
			return claveRastreo;
		}
		public void setClaveRastreo(String claveRastreo) {
			this.claveRastreo = claveRastreo;
		}
		public String getEstatusEnv() {
			return estatusEnv;
		}
		public void setEstatusEnv(String estatusEnv) {
			this.estatusEnv = estatusEnv;
		}
		public String getCausaDevol() {
			return causaDevol;
		}
		public void setCausaDevol(String causaDevol) {
			this.causaDevol = causaDevol;
		}
		public String getUsuarioEnvio() {
			return usuarioEnvio;
		}
		public void setUsuarioEnvio(String usuarioEnvio) {
			this.usuarioEnvio = usuarioEnvio;
		}
		
		
		public String getEstatus() {
			return estatus;
		}
		public void setEstatus(String estatus) {
			this.estatus = estatus;
		}
		
		
		public String getFolioSpeiID() {
			return folioSpeiID;
		}
		public void setFolioSpeiID(String folioSpeiID) {
			this.folioSpeiID = folioSpeiID;
		}
		public String getDescripcion() {
			return descripcion;
		}
		public void setDescripcion(String descripcion) {
			this.descripcion = descripcion;
		}
		
		
		
		
		public String getUsuarioAutoriza() {
			return usuarioAutoriza;
		}
		public void setUsuarioAutoriza(String usuarioAutoriza) {
			this.usuarioAutoriza = usuarioAutoriza;
		}
		public String getUsuarioVerifica() {
			return usuarioVerifica;
		}
		public void setUsuarioVerifica(String usuarioVerifica) {
			this.usuarioVerifica = usuarioVerifica;
		}
		public String getFechaIncial() {
			return fechaIncial;
		}
		public void setFechaIncial(String fechaIncial) {
			this.fechaIncial = fechaIncial;
		}
		public String getFechaFinal() {
			return fechaFinal;
		}
		public void setFechaFinal(String fechaFinal) {
			this.fechaFinal = fechaFinal;
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
		public String getOrigenSpei() {
			return origenSpei;
		}
		public void setOrigenSpei(String origenSpei) {
			this.origenSpei = origenSpei;
		}	
	}