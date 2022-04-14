package tesoreria.bean;

public class RequisicionGastosBean {
	
	private String requisicionID;
	private String sucursalID;
	private String usuarioID;
	private String tipoGastoID;
	private String descripcionRG;
	private String monto;
	private String tipoPago;
	private String numCtaInstit;
	private String centroCostoID;
	private String fechaAlta;
	private String fechaSolicitada;
	private String cuentaAhoID;
	private String usuarioAutoriza;
	private String usuarioProcesa;
	private String status;
	  
	
	public String getTipoPago() {
		return tipoPago;
	}
	public void setTipoPago(String tipoPago) {
		this.tipoPago = tipoPago;
	}
	public String getNumCtaInstit() {
		return numCtaInstit;
	}
	public void setNumCtaInstit(String numCtaInstit) {
		this.numCtaInstit = numCtaInstit;
	}

	
	public String getRequisicionID() {
		return requisicionID;
	}
	public void setRequisicionID(String requisicionID) {
		this.requisicionID = requisicionID;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getTipoGastoID() {
		return tipoGastoID;
	}
	public void setTipoGastoID(String tipoGastoID) {
		this.tipoGastoID = tipoGastoID;
	}
	public String getDescripcionRG() {
		return descripcionRG;
	}
	public void setDescripcionRG(String descripcionRG) {
		this.descripcionRG = descripcionRG;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getCentroCostoID() {
		return centroCostoID;
	}
	public void setCentroCostoID(String centroCostoID) {
		this.centroCostoID = centroCostoID;
	}
	public String getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(String fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public String getFechaSolicitada() {
		return fechaSolicitada;
	}
	public void setFechaSolicitada(String fechaSolicitada) {
		this.fechaSolicitada = fechaSolicitada;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getUsuarioAutoriza() {
		return usuarioAutoriza;
	}
	public void setUsuarioAutoriza(String usuarioAutoriza) {
		this.usuarioAutoriza = usuarioAutoriza;
	}
	public String getUsuarioProcesa() {
		return usuarioProcesa;
	}
	public void setUsuarioProcesa(String usuarioProcesa) {
		this.usuarioProcesa = usuarioProcesa;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
}
