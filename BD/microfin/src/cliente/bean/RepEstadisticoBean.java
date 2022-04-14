package cliente.bean;

public class RepEstadisticoBean {
	// datos de la pantalla
		private int tipoReporte;
		private String tipoRep;
		private String fechaCorte;
		private	String incluirGL;
		private String saldoMinimo;
		private String incluirCuentaSA;
		private String pdf;
		private String excel;
		private String detallado;
		private String sumarizado;
		private String numConsulta;
		private String detReporte;
		
		// datos del reporte sumarizado captacion 
		private String cantidadRegistros;
		private String producto;
		private String tipoProducto;
		private String saldo;
		private String saldoGL;
		
		// datos del reporte sumarizado cartera 
				
		private String montoCredito;
		private String saldoCapital;
		private String saldoInteres;
		
		// datos del reporte detallado captacion
		private String numCuenta;
		private String nomCliente;
		private String descripcion;
		private String estatus;
		private String sucursalID;
		private String nombreSucurs;
		
		// datos del reporte detallado cartera
		private String numCredito;
		//auxiliares
		private String claveUsuario;
		private String horaEmision;
		private String fechaEmision;
		private String nombreInstitucion;
		private String fechaReporte;
		private String rutaImagen;
		private String clienteID;

		public String getFechaCorte() {
			return fechaCorte;
		}

		public void setFechaCorte(String fechaCorte) {
			this.fechaCorte = fechaCorte;
		}

		public String getIncluirGL() {
			return incluirGL;
		}

		public void setIncluirGL(String incluirGL) {
			this.incluirGL = incluirGL;
		}

		public String getSaldoMinimo() {
			return saldoMinimo;
		}

		public void setSaldoMinimo(String saldoMinimo) {
			this.saldoMinimo = saldoMinimo;
		}

		public String getIncluirCuentaSA() {
			return incluirCuentaSA;
		}

		public void setIncluirCuentaSA(String incluirCuentaSA) {
			this.incluirCuentaSA = incluirCuentaSA;
		}

		public String getPdf() {
			return pdf;
		}

		public void setPdf(String pdf) {
			this.pdf = pdf;
		}

		public String getExcel() {
			return excel;
		}

		public void setExcel(String excel) {
			this.excel = excel;
		}

		public String getDetallado() {
			return detallado;
		}

		public void setDetallado(String detallado) {
			this.detallado = detallado;
		}

		public String getSumarizado() {
			return sumarizado;
		}

		public void setSumarizado(String sumarizado) {
			this.sumarizado = sumarizado;
		}

		public String getCantidadRegistros() {
			return cantidadRegistros;
		}

		public void setCantidadRegistros(String cantidadRegistros) {
			this.cantidadRegistros = cantidadRegistros;
		}

		public String getProducto() {
			return producto;
		}

		public void setProducto(String producto) {
			this.producto = producto;
		}

		public String getTipoProducto() {
			return tipoProducto;
		}

		public void setTipoProducto(String tipoProducto) {
			this.tipoProducto = tipoProducto;
		}

		public String getSaldo() {
			return saldo;
		}

		public void setSaldo(String saldo) {
			this.saldo = saldo;
		}

		public String getSaldoGL() {
			return saldoGL;
		}

		public void setSaldoGL(String saldoGL) {
			this.saldoGL = saldoGL;
		}

		public String getMontoCredito() {
			return montoCredito;
		}

		public void setMontoCredito(String montoCredito) {
			this.montoCredito = montoCredito;
		}

		public String getSaldoCapital() {
			return saldoCapital;
		}

		public void setSaldoCapital(String saldoCapital) {
			this.saldoCapital = saldoCapital;
		}

		public String getSaldoInteres() {
			return saldoInteres;
		}

		public void setSaldoInteres(String saldoInteres) {
			this.saldoInteres = saldoInteres;
		}

		public String getNumCuenta() {
			return numCuenta;
		}

		public void setNumCuenta(String numCuenta) {
			this.numCuenta = numCuenta;
		}

		public String getNomCliente() {
			return nomCliente;
		}

		public void setNomCliente(String nomCliente) {
			this.nomCliente = nomCliente;
		}

		public String getDescripcion() {
			return descripcion;
		}

		public void setDescripcion(String descripcion) {
			this.descripcion = descripcion;
		}

		public String getEstatus() {
			return estatus;
		}

		public void setEstatus(String estatus) {
			this.estatus = estatus;
		}

		public String getSucursalID() {
			return sucursalID;
		}

		public void setSucursalID(String sucursalID) {
			this.sucursalID = sucursalID;
		}

		public String getNombreSucurs() {
			return nombreSucurs;
		}

		public void setNombreSucurs(String nombreSucurs) {
			this.nombreSucurs = nombreSucurs;
		}

		public String getNumCredito() {
			return numCredito;
		}

		public void setNumCredito(String numCredito) {
			this.numCredito = numCredito;
		}

		public String getNumConsulta() {
			return numConsulta;
		}

		public void setNumConsulta(String numConsulta) {
			this.numConsulta = numConsulta;
		}

		public String getClaveUsuario() {
			return claveUsuario;
		}

		public void setClaveUsuario(String claveUsuario) {
			this.claveUsuario = claveUsuario;
		}

		public String getHoraEmision() {
			return horaEmision;
		}

		public void setHoraEmision(String horaEmision) {
			this.horaEmision = horaEmision;
		}

		public String getFechaEmision() {
			return fechaEmision;
		}

		public void setFechaEmision(String fechaEmision) {
			this.fechaEmision = fechaEmision;
		}

		public String getNombreInstitucion() {
			return nombreInstitucion;
		}

		public void setNombreInstitucion(String nombreInstitucion) {
			this.nombreInstitucion = nombreInstitucion;
		}

		public int getTipoReporte() {
			return tipoReporte;
		}

		public void setTipoReporte(int tipoReporte) {
			this.tipoReporte = tipoReporte;
		}

		public String getTipoRep() {
			return tipoRep;
		}

		public void setTipoRep(String tipoRep) {
			this.tipoRep = tipoRep;
		}

		public String getFechaReporte() {
			return fechaReporte;
		}

		public void setFechaReporte(String fechaReporte) {
			this.fechaReporte = fechaReporte;
		}

		public String getDetReporte() {
			return detReporte;
		}

		public void setDetReporte(String detReporte) {
			this.detReporte = detReporte;
		}

		public String getRutaImagen() {
			return rutaImagen;
		}

		public void setRutaImagen(String rutaImagen) {
			this.rutaImagen = rutaImagen;
		}

		public String getClienteID() {
			return clienteID;
		}

		public void setClienteID(String clienteID) {
			this.clienteID = clienteID;
		}	
		
		

}
