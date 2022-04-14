	package spei.bean;

	import general.bean.BaseBean;

	public class ConsultaSpeiBean extends BaseBean{
		
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
		private String numero;
		private String descripcion;
		private String montoSpei;
		private String procesado;
		private String saldoActual;
		private String saldoReservado;	
		private String montoDisponible;	
		private String balanceCuenta;
		private String fechaInicial;
		private String fechaFinal;
		
		
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
		
		public String getNumero() {
			return numero;
		}
		public void setNumero(String numero) {
			this.numero = numero;
		}
		
		public String getDescripcion() {
			return descripcion;
		}
		public void setDescripcion(String descripcion) {
			this.descripcion = descripcion;
		}
		
		
		
		
		
		
		
		
		
		
		
		public String getSaldoActual() {
			return saldoActual;
		}
		public void setSaldoActual(String saldoActual) {
			this.saldoActual = saldoActual;
		}
		public String getSaldoReservado() {
			return saldoReservado;
		}
		public void setSaldoReservado(String saldoReservado) {
			this.saldoReservado = saldoReservado;
		}
		public String getMontoDisponible() {
			return montoDisponible;
		}
		public void setMontoDisponible(String montoDisponible) {
			this.montoDisponible = montoDisponible;
		}
		public String getBalanceCuenta() {
			return balanceCuenta;
		}
		public void setBalanceCuenta(String balanceCuenta) {
			this.balanceCuenta = balanceCuenta;
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
		public String getProcesado() {
			return procesado;
		}
		public void setProcesado(String procesado) {
			this.procesado = procesado;
		}
		public String getMontoSpei() {
			return montoSpei;
		}
		public void setMontoSpei(String montoSpei) {
			this.montoSpei = montoSpei;
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
		
		
		
	}



