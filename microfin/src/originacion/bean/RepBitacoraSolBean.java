
package originacion.bean;

import general.bean.BaseBean;

public class RepBitacoraSolBean extends BaseBean{
	
	// datos de la pantalla
	private String fechaInicio;
	private String fechaFin;
	private String nombreInstitucion;
	private String fechaSistema;
	private String nombreUsuario;
	private String horaEmision;
	private String usuarioID;	
	private String promotorID;
	private String nombrePromotor;
	private String sucursalID;
	private String nombreSucursal;
	private String producCreditoID;
	private String nombreProducto;
	private String nomUsuario;
	private String esAgropecuario;
	
	// datos del reporte
	
	

	private String fechaRegistro;
	
	private String solicitudCreditoID;
	private String creditoID;	

	private String clienteID;
	private String nombreCliente;
	private String promotor;
	private String nomPromotor;
	private String estatus;	

	private String fechaSolRegistro;
	private String usuSolRegistro;
	private String nomUsuSolRegistro;
	private String comSolRegistro;
	private String tiempoEstRegistro;
	
	private String fechaSolLibera;
	private String usuSolLibera;
	private String nomUsuSolLibera;
	private String comSolLibera;
	private String tiempoEstLibera;
	
	private String fechaSolActualiza;
	private String usuSolActualiza;
	private String nomUsuSolActualiza;
	private String comSolActualiza;
	private String tiempoEstActualiza;	
	
	private String fechaSolRechaza;
	private String usuSolRechaza;
	private String nomUsuSolRechaza;
	private String comSolRechaza;
	
	private String fechaSolAutoriza;
	private String usuSolAutoriza;
	private String nomUsuSolAutoriza;
	private String comSolAutoriza;
	private String tiempoEstAutoriza;
	
	private String fechaCreRegistro;
	private String usuCreRegistro;
	private String nomUsuCreRegistro;
	private String comCreRegistro;
	private String tiempoEstCreRegistro;
	
	private String fechaCreCondiciona;
	private String usuCreCondiciona;
	private String nomUsuCreCondiciona;
	private String comCreCondiciona;
	private String tiempoEstCreCondiciona;
	
	private String fechaCreAutoriza;
	private String usuCreAutoriza;
	private String nomUsuCreAutoriza;
	private String comCreAutoriza;
	private String tiempoEstCreAutoriza;
	
	private String fechaCreDesembolsa;
	private String usuCreDesembolsa;
	private String nomUsuCreDesembolsa;
	private String comCreDesembolsa;
	
	private String fechaCreCancela;
	private String usuCreCancela;
	private String nomUsuCreCancela;	
	private String comCreCancela;
	
	private String dias;
	
	public String getFechaSolActualiza() {
		return fechaSolActualiza;
	}

	public void setFechaSolActualiza(String fechaSolActualiza) {
		this.fechaSolActualiza = fechaSolActualiza;
	}

	public String getUsuSolActualiza() {
		return usuSolActualiza;
	}

	public void setUsuSolActualiza(String usuSolActualiza) {
		this.usuSolActualiza = usuSolActualiza;
	}

	public String getComSolActualiza() {
		return comSolActualiza;
	}

	public void setComSolActualiza(String comSolActualiza) {
		this.comSolActualiza = comSolActualiza;
	}

	public String getTiempoEstActualiza() {
		return tiempoEstActualiza;
	}

	public void setTiempoEstActualiza(String tiempoEstActualiza) {
		this.tiempoEstActualiza = tiempoEstActualiza;
	}

	public String getFechaSolRechaza() {
		return fechaSolRechaza;
	}

	public void setFechaSolRechaza(String fechaSolRechaza) {
		this.fechaSolRechaza = fechaSolRechaza;
	}

	public String getUsuSolRechaza() {
		return usuSolRechaza;
	}

	public void setUsuSolRechaza(String usuSolRechaza) {
		this.usuSolRechaza = usuSolRechaza;
	}

	public String getComSolRechaza() {
		return comSolRechaza;
	}

	public void setComSolRechaza(String comSolRechaza) {
		this.comSolRechaza = comSolRechaza;
	}

	public String getFechaCreCondiciona() {
		return fechaCreCondiciona;
	}

	public void setFechaCreCondiciona(String fechaCreCondiciona) {
		this.fechaCreCondiciona = fechaCreCondiciona;
	}

	public String getUsuCreCondiciona() {
		return usuCreCondiciona;
	}

	public void setUsuCreCondiciona(String usuCreCondiciona) {
		this.usuCreCondiciona = usuCreCondiciona;
	}

	public String getComCreCondiciona() {
		return comCreCondiciona;
	}

	public void setComCreCondiciona(String comCreCondiciona) {
		this.comCreCondiciona = comCreCondiciona;
	}

	public String getTiempoEstCreCondiciona() {
		return tiempoEstCreCondiciona;
	}

	public void setTiempoEstCreCondiciona(String tiempoEstCreCondiciona) {
		this.tiempoEstCreCondiciona = tiempoEstCreCondiciona;
	}

	public String getFechaCreDesembolsa() {
		return fechaCreDesembolsa;
	}

	public void setFechaCreDesembolsa(String fechaCreDesembolsa) {
		this.fechaCreDesembolsa = fechaCreDesembolsa;
	}

	public String getUsuCreDesembolsa() {
		return usuCreDesembolsa;
	}

	public void setUsuCreDesembolsa(String usuCreDesembolsa) {
		this.usuCreDesembolsa = usuCreDesembolsa;
	}

	public String getComCreDesembolsa() {
		return comCreDesembolsa;
	}

	public void setComCreDesembolsa(String comCreDesembolsa) {
		this.comCreDesembolsa = comCreDesembolsa;
	}

	public String getFechaCreCancela() {
		return fechaCreCancela;
	}

	public void setFechaCreCancela(String fechaCreCancela) {
		this.fechaCreCancela = fechaCreCancela;
	}

	public String getUsuCreCancela() {
		return usuCreCancela;
	}

	public void setUsuCreCancela(String usuCreCancela) {
		this.usuCreCancela = usuCreCancela;
	}

	public String getComCreCancela() {
		return comCreCancela;
	}

	public void setComCreCancela(String comCreCancela) {
		this.comCreCancela = comCreCancela;
	}
	
	public String getNombreProducto() {
		return nombreProducto;
	}

	public void setNombreProducto(String nombreProducto) {
		this.nombreProducto = nombreProducto;
	}

	public String getNombreSucursal() {
		return nombreSucursal;
	}

	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}

	public String getNomPromotor() {
		return nomPromotor;
	}

	public void setNomPromotor(String nomPromotor) {
		this.nomPromotor = nomPromotor;
	}
	
	public String getUsuarioID() {
		return usuarioID;
	}
	
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
	
	public String getFechaSolLibera() {
		return fechaSolLibera;
	}
	public void setFechaSolLibera(String fechaSolLibera) {
		this.fechaSolLibera = fechaSolLibera;
	}
	public String getUsuSolLibera() {
		return usuSolLibera;
	}
	public void setUsuSolLibera(String usuSolLibera) {
		this.usuSolLibera = usuSolLibera;
	}
	public String getComSolLibera() {
		return comSolLibera;
	}
	public void setComSolLibera(String comSolLibera) {
		this.comSolLibera = comSolLibera;
	}
	public String getTiempoEstLibera() {
		return tiempoEstLibera;
	}
	public void setTiempoEstLibera(String tiempoEstLibera) {
		this.tiempoEstLibera = tiempoEstLibera;
	}
	public String getFechaSolAutoriza() {
		return fechaSolAutoriza;
	}
	public void setFechaSolAutoriza(String fechaSolAutoriza) {
		this.fechaSolAutoriza = fechaSolAutoriza;
	}
	public String getUsuSolAutoriza() {
		return usuSolAutoriza;
	}
	public void setUsuSolAutoriza(String usuSolAutoriza) {
		this.usuSolAutoriza = usuSolAutoriza;
	}
	public String getComSolAutoriza() {
		return comSolAutoriza;
	}
	public void setComSolAutoriza(String comSolAutoriza) {
		this.comSolAutoriza = comSolAutoriza;
	}
	public String getTiempoEstAutoriza() {
		return tiempoEstAutoriza;
	}
	public void setTiempoEstAutoriza(String tiempoEstAutoriza) {
		this.tiempoEstAutoriza = tiempoEstAutoriza;
	}
	public String getFechaCreRegistro() {
		return fechaCreRegistro;
	}
	public void setFechaCreRegistro(String fechaCreRegistro) {
		this.fechaCreRegistro = fechaCreRegistro;
	}
	public String getUsuCreRegistro() {
		return usuCreRegistro;
	}
	public void setUsuCreRegistro(String usuCreRegistro) {
		this.usuCreRegistro = usuCreRegistro;
	}
	public String getComCreRegistro() {
		return comCreRegistro;
	}
	public void setComCreRegistro(String comCreRegistro) {
		this.comCreRegistro = comCreRegistro;
	}
	public String getTiempoEstCreRegistro() {
		return tiempoEstCreRegistro;
	}
	public void setTiempoEstCreRegistro(String tiempoEstCreRegistro) {
		this.tiempoEstCreRegistro = tiempoEstCreRegistro;
	}
	public String getFechaCreAutoriza() {
		return fechaCreAutoriza;
	}
	public void setFechaCreAutoriza(String fechaCreAutoriza) {
		this.fechaCreAutoriza = fechaCreAutoriza;
	}
	public String getUsuCreAutoriza() {
		return usuCreAutoriza;
	}
	public void setUsuCreAutoriza(String usuCreAutoriza) {
		this.usuCreAutoriza = usuCreAutoriza;
	}
	public String getComCreAutoriza() {
		return comCreAutoriza;
	}
	public void setComCreAutoriza(String comCreAutoriza) {
		this.comCreAutoriza = comCreAutoriza;
	}
	public String getTiempoEstCreAutoriza() {
		return tiempoEstCreAutoriza;
	}
	public void setTiempoEstCreAutoriza(String tiempoEstCreAutoriza) {
		this.tiempoEstCreAutoriza = tiempoEstCreAutoriza;
	}	
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getPromotor() {
		return promotor;
	}
	public void setPromotor(String promotor) {
		this.promotor = promotor;
	}
	public String getNombrePromotor() {
		return nombrePromotor;
	}
	public void setNombrePromotor(String nombrePromotor) {
		this.nombrePromotor = nombrePromotor;
	}	
	public String getFechaSolRegistro() {
		return fechaSolRegistro;
	}
	public void setFechaSolRegistro(String fechaSolRegistro) {
		this.fechaSolRegistro = fechaSolRegistro;
	}
	public String getUsuSolRegistro() {
		return usuSolRegistro;
	}
	public void setUsuSolRegistro(String usuSolRegistro) {
		this.usuSolRegistro = usuSolRegistro;
	}
	public String getComSolRegistro() {
		return comSolRegistro;
	}
	public void setComSolRegistro(String comSolRegistro) {
		this.comSolRegistro = comSolRegistro;
	}
	public String getTiempoEstRegistro() {
		return tiempoEstRegistro;
	}
	public void setTiempoEstRegistro(String tiempoEstRegistro) {
		this.tiempoEstRegistro = tiempoEstRegistro;
	}
	public String getPromotorID() {
		return promotorID;
	}	
	public void setPromotorID(String promotorID) {
		this.promotorID = promotorID;
	}	
	public String getSucursalID() {
		return sucursalID;
	}

	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}	
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}	
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getHoraEmision() {
		return horaEmision;
	}
	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}
	public String getNomUsuSolRegistro() {
		return nomUsuSolRegistro;
	}

	public void setNomUsuSolRegistro(String nomUsuSolregistro) {
		this.nomUsuSolRegistro = nomUsuSolregistro;
	}

	public String getNomUsuSolLibera() {
		return nomUsuSolLibera;
	}

	public void setNomUsuSolLibera(String nomUsuSolLibera) {
		this.nomUsuSolLibera = nomUsuSolLibera;
	}

	public String getNomUsuSolActualiza() {
		return nomUsuSolActualiza;
	}

	public void setNomUsuSolActualiza(String nomUsuSolActualiza) {
		this.nomUsuSolActualiza = nomUsuSolActualiza;
	}

	public String getNomUsuSolRechaza() {
		return nomUsuSolRechaza;
	}

	public void setNomUsuSolRechaza(String nomUsuSolRechaza) {
		this.nomUsuSolRechaza = nomUsuSolRechaza;
	}

	public String getNomUsuSolAutoriza() {
		return nomUsuSolAutoriza;
	}

	public void setNomUsuSolAutoriza(String nomUsuSolAutoriza) {
		this.nomUsuSolAutoriza = nomUsuSolAutoriza;
	}

	public String getNomUsuCreRegistro() {
		return nomUsuCreRegistro;
	}

	public void setNomUsuCreRegistro(String nomUsuCreRegistro) {
		this.nomUsuCreRegistro = nomUsuCreRegistro;
	} 

	public String getNomUsuCreCondiciona() {
		return nomUsuCreCondiciona;
	}

	public void setNomUsuCreCondiciona(String nomUsuCreCondiciona) {
		this.nomUsuCreCondiciona = nomUsuCreCondiciona;
	}

	public String getNomUsuCreAutoriza() {
		return nomUsuCreAutoriza;
	}

	public void setNomUsuCreAutoriza(String nomUsuCreAutoriza) {
		this.nomUsuCreAutoriza = nomUsuCreAutoriza;
	}

	public String getNomUsuCreDesembolsa() {
		return nomUsuCreDesembolsa;
	}

	public void setNomUsuCreDesembolsa(String nomUsuCreDesembolsa) {
		this.nomUsuCreDesembolsa = nomUsuCreDesembolsa;
	}

	public String getNomUsuCreCancela() {
		return nomUsuCreCancela;
	}

	public void setNomUsuCreCancela(String nomUsuCreCancela) {
		this.nomUsuCreCancela = nomUsuCreCancela;
	}
	
	public String getEstatus() {
		return estatus;
	}

	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	
	public String getCreditoID() {
		return creditoID;
	}

	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}	

	public String getNomUsuario() {
		return nomUsuario;
	}

	public void setNomUsuario(String nomUsuario) {
		this.nomUsuario = nomUsuario;
	}

	public String getDias() {
		return dias;
	}

	public void setDias(String dias) {
		this.dias = dias;
	}

	public String getEsAgropecuario() {
		return esAgropecuario;
	}

	public void setEsAgropecuario(String esAgropecuario) {
		this.esAgropecuario = esAgropecuario;
	}
	

}