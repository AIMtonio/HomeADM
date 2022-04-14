	package ventanilla.bean;

	import java.util.List;

	import general.bean.BaseBean;
	import herramientas.Utileria;

	public class SpeiEnvioBean extends BaseBean{
	
		public String folioSpeiID;
		public String clabeRastreo;   
		public String tipoPago;		   
		public String cuentaAhoID;		   
		public String tipoCuentaOrd;	   
		public String nombreOrd;		   

		public String ordRFC;	           
		public String monedaID;		   
		public String tipoOperacion;	   
		public String montoTransferir;	   
		public String IVAPorPagar;	   

		public String comisionTrans;	   
		public String IVAComision;		   
		public String instiRemitente;	   
		public String totalCargoCuenta;   
		public String instiReceptora;	   

		public String cuentaBeneficiario; 
		public String nombreBeneficiario; 
		public String beneficiarioRFC;	   
		public String tipoCuentaBen;	   
		public String conceptoPago;	   

		public String cuentaBenefiDos;    
		public String nombreBenefiDos;    
		public String BenefiDosRFC;	   
		public String tipoCuentaBenDos;   
		public String conceptoPagoDos;    

		public String referenciaCobranza; 
		public String referenciaNum;      
		public String prioridadEnvio;	   
		public String estatusEnv;   	   
		public String fecha;       	   

		public String clavePago;          
		public String usuarioEnvio;       
		public String areaEmiteID;	       
		public String estatus;   	   
		public String fechaEnvio;       

		public String causaDevol;     
		public String pagarIVA;
		public String comisionIVA;
		public String cuentaOrd;
	    public String totalCargoLetras;

	    private String firma;
	   
		public String empresaID;	   
		public String usuario;			   
		public String fechaActual;		   
		public String direccionIP;		   
		public String programaID;		   
		public String sucursal;	   
		public String numTransaccion;
		
		public String rFCOrd;
		private String rFCBeneficiario;
		private String origenOperacion;
		private String ipUsuario;
		
		public String getFolioSpeiID() {
			return folioSpeiID;
		}
		public void setFolioSpeiID(String folioSpeiID) {
			this.folioSpeiID = folioSpeiID;
		}
		public String getClabeRastreo() {
			return clabeRastreo;
		}
		public void setClabeRastreo(String clabeRastreo) {
			this.clabeRastreo = clabeRastreo;
		}
		public String getTipoPago() {
			return tipoPago;
		}
		public void setTipoPago(String tipoPago) {
			this.tipoPago = tipoPago;
		}
		public String getCuentaAhoID() {
			return cuentaAhoID;
		}
		public void setCuentaAhoID(String cuentaAhoID) {
			this.cuentaAhoID = cuentaAhoID;
		}
		public String getTipoCuentaOrd() {
			return tipoCuentaOrd;
		}
		public void setTipoCuentaOrd(String tipoCuentaOrd) {
			this.tipoCuentaOrd = tipoCuentaOrd;
		}
		public String getNombreOrd() {
			return nombreOrd;
		}
		public void setNombreOrd(String nombreOrd) {
			this.nombreOrd = nombreOrd;
		}
		public String getOrdRFC() {
			return ordRFC;
		}
		public void setOrdRFC(String ordRFC) {
			this.ordRFC = ordRFC;
		}
		public String getMonedaID() {
			return monedaID;
		}
		public void setMonedaID(String monedaID) {
			this.monedaID = monedaID;
		}
		public String getTipoOperacion() {
			return tipoOperacion;
		}
		public void setTipoOperacion(String tipoOperacion) {
			this.tipoOperacion = tipoOperacion;
		}
		public String getMontoTransferir() {
			return montoTransferir;
		}
		public void setMontoTransferir(String montoTransferir) {
			this.montoTransferir = montoTransferir;
		}
		public String getIVAPorPagar() {
			return IVAPorPagar;
		}
		public void setIVAPorPagar(String iVAPorPagar) {
			IVAPorPagar = iVAPorPagar;
		}
		public String getComisionTrans() {
			return comisionTrans;
		}
		public void setComisionTrans(String comisionTrans) {
			this.comisionTrans = comisionTrans;
		}
		public String getIVAComision() {
			return IVAComision;
		}
		public void setIVAComision(String iVAComision) {
			IVAComision = iVAComision;
		}
		public String getInstiRemitente() {
			return instiRemitente;
		}
		public void setInstiRemitente(String instiRemitente) {
			this.instiRemitente = instiRemitente;
		}
		public String getTotalCargoCuenta() {
			return totalCargoCuenta;
		}
		public void setTotalCargoCuenta(String totalCargoCuenta) {
			this.totalCargoCuenta = totalCargoCuenta;
		}
		public String getInstiReceptora() {
			return instiReceptora;
		}
		public void setInstiReceptora(String instiReceptora) {
			this.instiReceptora = instiReceptora;
		}
		public String getCuentaBeneficiario() {
			return cuentaBeneficiario;
		}
		public void setCuentaBeneficiario(String cuentaBeneficiario) {
			this.cuentaBeneficiario = cuentaBeneficiario;
		}
		public String getNombreBeneficiario() {
			return nombreBeneficiario;
		}
		public void setNombreBeneficiario(String nombreBeneficiario) {
			this.nombreBeneficiario = nombreBeneficiario;
		}
		public String getBeneficiarioRFC() {
			return beneficiarioRFC;
		}
		public void setBeneficiarioRFC(String beneficiarioRFC) {
			this.beneficiarioRFC = beneficiarioRFC;
		}
		public String getTipoCuentaBen() {
			return tipoCuentaBen;
		}
		public void setTipoCuentaBen(String tipoCuentaBen) {
			this.tipoCuentaBen = tipoCuentaBen;
		}
		public String getConceptoPago() {
			return conceptoPago;
		}
		public void setConceptoPago(String conceptoPago) {
			this.conceptoPago = conceptoPago;
		}
		public String getCuentaBenefiDos() {
			return cuentaBenefiDos;
		}
		public void setCuentaBenefiDos(String cuentaBenefiDos) {
			this.cuentaBenefiDos = cuentaBenefiDos;
		}
		public String getNombreBenefiDos() {
			return nombreBenefiDos;
		}
		public void setNombreBenefiDos(String nombreBenefiDos) {
			this.nombreBenefiDos = nombreBenefiDos;
		}
		public String getBenefiDosRFC() {
			return BenefiDosRFC;
		}
		public void setBenefiDosRFC(String benefiDosRFC) {
			BenefiDosRFC = benefiDosRFC;
		}
		public String getTipoCuentaBenDos() {
			return tipoCuentaBenDos;
		}
		public void setTipoCuentaBenDos(String tipoCuentaBenDos) {
			this.tipoCuentaBenDos = tipoCuentaBenDos;
		}
		public String getConceptoPagoDos() {
			return conceptoPagoDos;
		}
		public void setConceptoPagoDos(String conceptoPagoDos) {
			this.conceptoPagoDos = conceptoPagoDos;
		}
		public String getReferenciaCobranza() {
			return referenciaCobranza;
		}
		public void setReferenciaCobranza(String referenciaCobranza) {
			this.referenciaCobranza = referenciaCobranza;
		}
		public String getReferenciaNum() {
			return referenciaNum;
		}
		public void setReferenciaNum(String referenciaNum) {
			this.referenciaNum = referenciaNum;
		}
		public String getPrioridadEnvio() {
			return prioridadEnvio;
		}
		public void setPrioridadEnvio(String prioridadEnvio) {
			this.prioridadEnvio = prioridadEnvio;
		}
		public String getEstatusEnv() {
			return estatusEnv;
		}
		public void setEstatusEnv(String estatusEnv) {
			this.estatusEnv = estatusEnv;
		}
		public String getFecha() {
			return fecha;
		}
		public void setFecha(String fecha) {
			this.fecha = fecha;
		}
		public String getClavePago() {
			return clavePago;
		}
		public void setClavePago(String clavePago) {
			this.clavePago = clavePago;
		}
		public String getUsuarioEnvio() {
			return usuarioEnvio;
		}
		public void setUsuarioEnvio(String usuarioEnvio) {
			this.usuarioEnvio = usuarioEnvio;
		}
		public String getAreaEmiteID() {
			return areaEmiteID;
		}
		public void setAreaEmiteID(String areaEmiteID) {
			this.areaEmiteID = areaEmiteID;
		}
		public String getEstatus() {
			return estatus;
		}
		public void setEstatus(String estatus) {
			this.estatus = estatus;
		}
		public String getFechaEnvio() {
			return fechaEnvio;
		}
		public void setFechaEnvio(String fechaEnvio) {
			this.fechaEnvio = fechaEnvio;
		}
		public String getCausaDevol() {
			return causaDevol;
		}
		public void setCausaDevol(String causaDevol) {
			this.causaDevol = causaDevol;
		}
		
		
		
		public String getCuentaOrd() {
			return cuentaOrd;
		}
		public void setCuentaOrd(String cuentaOrd) {
			this.cuentaOrd = cuentaOrd;
		}
		public String getComisionIVA() {
			return comisionIVA;
		}
		public void setComisionIVA(String comisionIVA) {
			this.comisionIVA = comisionIVA;
		}
		public String getPagarIVA() {
			return pagarIVA;
		}
		public void setPagarIVA(String pagarIVA) {
			this.pagarIVA = pagarIVA;
		}

		public String getTotalCargoLetras() {
			return totalCargoLetras;
		}
		public void setTotalCargoLetras(String totalCargoLetras) {
			this.totalCargoLetras = totalCargoLetras;
		}
		public String getFirma() {
			return firma;
		}
		public void setFirma(String firma) {
			this.firma = firma;
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
		public String getrFCOrd() {
			return rFCOrd;
		}
		public void setrFCOrd(String rFCOrd) {
			this.rFCOrd = rFCOrd;
		}
		public String getrFCBeneficiario() {
			return rFCBeneficiario;
		}
		public void setrFCBeneficiario(String rFCBeneficiario) {
			this.rFCBeneficiario = rFCBeneficiario;
		}
		public String getOrigenOperacion() {
			return origenOperacion;
		}
		public void setOrigenOperacion(String origenOperacion) {
			this.origenOperacion = origenOperacion;
		}
		public String getIpUsuario() {
			return ipUsuario;
		}
		public void setIpUsuario(String ipUsuario) {
			this.ipUsuario = ipUsuario;
		}	   

		
		
		
	}


