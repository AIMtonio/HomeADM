package cuentas.bean;

import java.util.List;

import general.bean.BaseBean;

public class ComisionesSaldoPromedioBean extends BaseBean{
	//CONDONACION
	private String comisionID;
	private String fechaCorte;
	private String cuentaAhoID;
	private String comSaldoPromOri;
	private String IVAComSalPromOri;
	private String comSaldoPromAct;
	private String IVAComSalPromAct;
	private String omSaldoPromCob;
	private String comSaldoPromCob;
	private String IVAComSalPromCob;
	private String comSaldoPromCond;
	private String IVAComSalPromCond;
	private String estatus;
	private String origenComision;
	private String clienteID;
	private String desEstatus;
	
	//REVERSA
	private String cobroID;
	private String saldoDispon;
	private String fechaCobro;
	private String comSaldoPromPend;
	private String IVAComSalPromPend;
	private String totalCobrado;
	private String origenCobro;
	private String desOrigen;
	
	private String saldoComPendiente;
	private String iVAComision;
	private String tipoComision;
	private String tipoCondonacion;
	private String tipoReversa;
	private String origen;	
	private String fecha;
	private String fechaProceso;
	private String motivoProceso;
	private String usuarioAutoriza;
	private String tipoOperacion;
	private String saldoComision;
	private String IVAComisionPendiente;
	private String descripcion;
	private String catalogoID;
	private String contraseniaUsuarioAutoriza;
	private String usuarioAutorizaID;
	private String usuarioID;
	private String tipoMotivo;
	private String totalSaldoCom;
	private String tipoCondonacionID;
	private String tipoReversaID;	
	
	
	private List lmotivoProceso;
	private List ltipoProceso;
	private List lcuentaAhoID;
	private List lsaldoComision;
	private List lIVAsaldoComision;
	private List lcomisionID;
	private List lseleccionado;
	private List lseleccionadoCheck;
	private List lcobroID;

	private String montoMovPago;
	private String polizaID;
	
	public static String reversaCoision	= "1109";				//Concepto Contable Reversa de Comision (CONCEPTOSCONTA)
	public static String desRevComision = "REVERSA COMISION SALDO PROMEDIO";
	
	public String getComisionID() {
		return comisionID;
	}
	public void setComisionID(String comisionID) {
		this.comisionID = comisionID;
	}
	public String getFechaCorte() {
		return fechaCorte;
	}
	public void setFechaCorte(String fechaCorte) {
		this.fechaCorte = fechaCorte;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getComSaldoPromOri() {
		return comSaldoPromOri;
	}
	public void setComSaldoPromOri(String comSaldoPromOri) {
		this.comSaldoPromOri = comSaldoPromOri;
	}
	public String getIVAComSalPromOri() {
		return IVAComSalPromOri;
	}
	public void setIVAComSalPromOri(String iVAComSalPromOri) {
		IVAComSalPromOri = iVAComSalPromOri;
	}
	public String getComSaldoPromAct() {
		return comSaldoPromAct;
	}
	public void setComSaldoPromAct(String comSaldoPromAct) {
		this.comSaldoPromAct = comSaldoPromAct;
	}
	public String getIVAComSalPromAct() {
		return IVAComSalPromAct;
	}
	public void setIVAComSalPromAct(String iVAComSalPromAct) {
		IVAComSalPromAct = iVAComSalPromAct;
	}
	public String getOmSaldoPromCob() {
		return omSaldoPromCob;
	}
	public void setOmSaldoPromCob(String omSaldoPromCob) {
		this.omSaldoPromCob = omSaldoPromCob;
	}
	public String getComSaldoPromCob() {
		return comSaldoPromCob;
	}
	public void setComSaldoPromCob(String comSaldoPromCob) {
		this.comSaldoPromCob = comSaldoPromCob;
	}
	public String getIVAComSalPromCob() {
		return IVAComSalPromCob;
	}
	public void setIVAComSalPromCob(String iVAComSalPromCob) {
		IVAComSalPromCob = iVAComSalPromCob;
	}
	public String getComSaldoPromCond() {
		return comSaldoPromCond;
	}
	public void setComSaldoPromCond(String comSaldoPromCond) {
		this.comSaldoPromCond = comSaldoPromCond;
	}
	public String getIVAComSalPromCond() {
		return IVAComSalPromCond;
	}
	public void setIVAComSalPromCond(String iVAComSalPromCond) {
		IVAComSalPromCond = iVAComSalPromCond;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getOrigenComision() {
		return origenComision;
	}
	public void setOrigenComision(String origenComision) {
		this.origenComision = origenComision;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getDesEstatus() {
		return desEstatus;
	}
	public void setDesEstatus(String desEstatus) {
		this.desEstatus = desEstatus;
	}
	public String getCobroID() {
		return cobroID;
	}
	public void setCobroID(String cobroID) {
		this.cobroID = cobroID;
	}
	public String getSaldoDispon() {
		return saldoDispon;
	}
	public void setSaldoDispon(String saldoDispon) {
		this.saldoDispon = saldoDispon;
	}
	public String getFechaCobro() {
		return fechaCobro;
	}
	public void setFechaCobro(String fechaCobro) {
		this.fechaCobro = fechaCobro;
	}
	public String getComSaldoPromPend() {
		return comSaldoPromPend;
	}
	public void setComSaldoPromPend(String comSaldoPromPend) {
		this.comSaldoPromPend = comSaldoPromPend;
	}
	public String getIVAComSalPromPend() {
		return IVAComSalPromPend;
	}
	public void setIVAComSalPromPend(String iVAComSalPromPend) {
		IVAComSalPromPend = iVAComSalPromPend;
	}
	public String getTotalCobrado() {
		return totalCobrado;
	}
	public void setTotalCobrado(String totalCobrado) {
		this.totalCobrado = totalCobrado;
	}
	public String getOrigenCobro() {
		return origenCobro;
	}
	public void setOrigenCobro(String origenCobro) {
		this.origenCobro = origenCobro;
	}
	public String getDesOrigen() {
		return desOrigen;
	}
	public void setDesOrigen(String desOrigen) {
		this.desOrigen = desOrigen;
	}
	public String getSaldoComPendiente() {
		return saldoComPendiente;
	}
	public void setSaldoComPendiente(String saldoComPendiente) {
		this.saldoComPendiente = saldoComPendiente;
	}
	public String getiVAComision() {
		return iVAComision;
	}
	public void setiVAComision(String iVAComision) {
		this.iVAComision = iVAComision;
	}
	public String getTipoComision() {
		return tipoComision;
	}
	public void setTipoComision(String tipoComision) {
		this.tipoComision = tipoComision;
	}
	public String getTipoCondonacion() {
		return tipoCondonacion;
	}
	public void setTipoCondonacion(String tipoCondonacion) {
		this.tipoCondonacion = tipoCondonacion;
	}
	public String getTipoReversa() {
		return tipoReversa;
	}
	public void setTipoReversa(String tipoReversa) {
		this.tipoReversa = tipoReversa;
	}
	public String getOrigen() {
		return origen;
	}
	public void setOrigen(String origen) {
		this.origen = origen;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getFechaProceso() {
		return fechaProceso;
	}
	public void setFechaProceso(String fechaProceso) {
		this.fechaProceso = fechaProceso;
	}
	public String getMotivoProceso() {
		return motivoProceso;
	}
	public void setMotivoProceso(String motivoProceso) {
		this.motivoProceso = motivoProceso;
	}
	public String getUsuarioAutoriza() {
		return usuarioAutoriza;
	}
	public void setUsuarioAutoriza(String usuarioAutoriza) {
		this.usuarioAutoriza = usuarioAutoriza;
	}
	public String getTipoOperacion() {
		return tipoOperacion;
	}
	public void setTipoOperacion(String tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
	}
	public String getSaldoComision() {
		return saldoComision;
	}
	public void setSaldoComision(String saldoComision) {
		this.saldoComision = saldoComision;
	}
	public String getIVAComisionPendiente() {
		return IVAComisionPendiente;
	}
	public void setIVAComisionPendiente(String iVAComisionPendiente) {
		IVAComisionPendiente = iVAComisionPendiente;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getCatalogoID() {
		return catalogoID;
	}
	public void setCatalogoID(String catalogoID) {
		this.catalogoID = catalogoID;
	}
	public String getContraseniaUsuarioAutoriza() {
		return contraseniaUsuarioAutoriza;
	}
	public void setContraseniaUsuarioAutoriza(String contraseniaUsuarioAutoriza) {
		this.contraseniaUsuarioAutoriza = contraseniaUsuarioAutoriza;
	}
	public String getUsuarioAutorizaID() {
		return usuarioAutorizaID;
	}
	public void setUsuarioAutorizaID(String usuarioAutorizaID) {
		this.usuarioAutorizaID = usuarioAutorizaID;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getTipoMotivo() {
		return tipoMotivo;
	}
	public void setTipoMotivo(String tipoMotivo) {
		this.tipoMotivo = tipoMotivo;
	}
	public String getTotalSaldoCom() {
		return totalSaldoCom;
	}
	public void setTotalSaldoCom(String totalSaldoCom) {
		this.totalSaldoCom = totalSaldoCom;
	}
	public String getTipoCondonacionID() {
		return tipoCondonacionID;
	}
	public void setTipoCondonacionID(String tipoCondonacionID) {
		this.tipoCondonacionID = tipoCondonacionID;
	}
	public String getTipoReversaID() {
		return tipoReversaID;
	}
	public void setTipoReversaID(String tipoReversaID) {
		this.tipoReversaID = tipoReversaID;
	}
	public List getLmotivoProceso() {
		return lmotivoProceso;
	}
	public void setLmotivoProceso(List lmotivoProceso) {
		this.lmotivoProceso = lmotivoProceso;
	}
	public List getLtipoProceso() {
		return ltipoProceso;
	}
	public void setLtipoProceso(List ltipoProceso) {
		this.ltipoProceso = ltipoProceso;
	}
	public List getLcuentaAhoID() {
		return lcuentaAhoID;
	}
	public void setLcuentaAhoID(List lcuentaAhoID) {
		this.lcuentaAhoID = lcuentaAhoID;
	}
	public List getLsaldoComision() {
		return lsaldoComision;
	}
	public void setLsaldoComision(List lsaldoComision) {
		this.lsaldoComision = lsaldoComision;
	}
	public List getlIVAsaldoComision() {
		return lIVAsaldoComision;
	}
	public void setlIVAsaldoComision(List lIVAsaldoComision) {
		this.lIVAsaldoComision = lIVAsaldoComision;
	}
	public List getLcomisionID() {
		return lcomisionID;
	}
	public void setLcomisionID(List lcomisionID) {
		this.lcomisionID = lcomisionID;
	}
	public List getLseleccionado() {
		return lseleccionado;
	}
	public void setLseleccionado(List lseleccionado) {
		this.lseleccionado = lseleccionado;
	}
	public List getLseleccionadoCheck() {
		return lseleccionadoCheck;
	}
	public void setLseleccionadoCheck(List lseleccionadoCheck) {
		this.lseleccionadoCheck = lseleccionadoCheck;
	}
	public List getLcobroID() {
		return lcobroID;
	}
	public void setLcobroID(List lcobroID) {
		this.lcobroID = lcobroID;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public String getMontoMovPago() {
		return montoMovPago;
	}
	public void setMontoMovPago(String montoMovPago) {
		this.montoMovPago = montoMovPago;
	}
}
