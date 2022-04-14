
package tesoreria.bean;

import java.util.List;

import general.bean.BaseBean;
 
public class ReqGastosSucBean extends BaseBean {
	public String numReqGasID;
	public String fechRequisicion;
	public String sucursalID;
	public String tipoPago;
	public String formaPago;
	public String cuentaDepositar;
	public String usuarioID;
	public String estatus;
	public String tipoGasto;
	public String institucionID;
	public String sucursalDescr;
	public String usuarioDescr;
	public String institucionSuc;
	public String cuentaAhoID; 
	public String centroCostosID;
	
	private List ldetReqGasID;
	private List ltipoGastoID;
	private List lobservaciones;
	private List lcentroCostoID;
	private List lpartidaPre;
	private List lmontoPre;
	private List lnoPresupuestado;
	private List lmonAutorizado;
	private List lstatus;
	private List lpartidaPreID;
	private List lgastoDireccion;
	private List lclaveDispMov;
	private List lnoFactura;
	private List lproveedor;
	private List ltipoDeposito;    
	
	//parametros Bean para reporte de Req de gastos
	public String fechaInicio;
	public String fechaFin;
	public String sucursal;
	public String estatusEnc;
	public String estatusDet;
	public String usuario;
	public String nombreSucursal;
	public String nombreUsuario;
	public String parFechaEmision;
	public String nombreInstitucion;
	public String nombreEstatusEnc;
	public String nombreEstatusDet;
	public String descripcionSuc;
	public String SaldoCajaAntenc;
	public String SaldoCajaPrin;
	public String PorDesembo;
	public String DesemboHoy;
	public String MtoBancosRec;
	
	
	public String getSaldoCajaAntenc() {
		return SaldoCajaAntenc;
	}
	public void setSaldoCajaAntenc(String saldoCajaAntenc) {
		SaldoCajaAntenc = saldoCajaAntenc;
	}
	public String getSaldoCajaPrin() {
		return SaldoCajaPrin;
	}
	public void setSaldoCajaPrin(String saldoCajaPrin) {
		SaldoCajaPrin = saldoCajaPrin;
	}
	public String getPorDesembo() {
		return PorDesembo;
	}
	public void setPorDesembo(String porDesembo) {
		PorDesembo = porDesembo;
	}
	public String getDesemboHoy() {
		return DesemboHoy;
	}
	public void setDesemboHoy(String desemboHoy) {
		DesemboHoy = desemboHoy;
	}
	public String getMtoBancosRec() {
		return MtoBancosRec;
	}
	public void setMtoBancosRec(String mtoBancosRec) {
		MtoBancosRec = mtoBancosRec;
	}
	public String getNumReqGasID() {
		return numReqGasID;
	}
	public void setNumReqGasID(String numReqGasID) {
		this.numReqGasID = numReqGasID;
	}
	public String getFechRequisicion() {
		return fechRequisicion;
	}
	public void setFechRequisicion(String fechRequisicion) {
		this.fechRequisicion = fechRequisicion;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getTipoPago() {
		return tipoPago;
	}
	public void setTipoPago(String tipoPago) {
		this.tipoPago = tipoPago;
	}
	public String getFormaPago() {
		return formaPago;
	}
	public void setFormaPago(String formaPago) {
		this.formaPago = formaPago;
	}
	public String getCuentaDepositar() {
		return cuentaDepositar;
	}
	public void setCuentaDepositar(String cuentaDepositar) {
		this.cuentaDepositar = cuentaDepositar;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getTipoGasto() {
		return tipoGasto;
	}
	public void setTipoGasto(String tipoGasto) {
		this.tipoGasto = tipoGasto;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getSucursalDescr() {
		return sucursalDescr;
	}
	public void setSucursalDescr(String sucursalDescr) {
		this.sucursalDescr = sucursalDescr;
	}
	public String getUsuarioDescr() {
		return usuarioDescr;
	}
	public void setUsuarioDescr(String usuarioDescr) {
		this.usuarioDescr = usuarioDescr;
	}
	public String getInstitucionSuc() {
		return institucionSuc;
	}
	public void setInstitucionSuc(String institucionSuc) {
		this.institucionSuc = institucionSuc;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public List getLdetReqGasID() {
		return ldetReqGasID;
	}
	public void setLdetReqGasID(List ldetReqGasID) {
		this.ldetReqGasID = ldetReqGasID;
	}
	public List getLtipoGastoID() {
		return ltipoGastoID;
	}
	public void setLtipoGastoID(List ltipoGastoID) {
		this.ltipoGastoID = ltipoGastoID;
	}
	public List getLobservaciones() {
		return lobservaciones;
	}
	public void setLobservaciones(List lobservaciones) {
		this.lobservaciones = lobservaciones;
	}
	public List getLcentroCostoID() {
		return lcentroCostoID;
	}
	public void setLcentroCostoID(List lcentroCostoID) {
		this.lcentroCostoID = lcentroCostoID;
	}
	public List getLpartidaPre() {
		return lpartidaPre;
	}
	public void setLpartidaPre(List lpartidaPre) {
		this.lpartidaPre = lpartidaPre;
	}
	public List getLmontoPre() {
		return lmontoPre;
	}
	public void setLmontoPre(List lmontoPre) {
		this.lmontoPre = lmontoPre;
	}
	public List getLnoPresupuestado() {
		return lnoPresupuestado;
	}
	public void setLnoPresupuestado(List lnoPresupuestado) {
		this.lnoPresupuestado = lnoPresupuestado;
	}
	public List getLmonAutorizado() {
		return lmonAutorizado;
	}
	public void setLmonAutorizado(List lmonAutorizado) {
		this.lmonAutorizado = lmonAutorizado;
	}
	public List getLstatus() {
		return lstatus;
	}
	public void setLstatus(List lstatus) {
		this.lstatus = lstatus;
	}
	public List getLpartidaPreID() {
		return lpartidaPreID;
	}
	public void setLpartidaPreID(List lpartidaPreID) {
		this.lpartidaPreID = lpartidaPreID;
	}
	public List getLgastoDireccion() {
		return lgastoDireccion;
	}
	public void setLgastoDireccion(List lgastoDireccion) {
		this.lgastoDireccion = lgastoDireccion;
	}
	public List getLclaveDispMov() {
		return lclaveDispMov;
	}
	public void setLclaveDispMov(List lclaveDispMov) {
		this.lclaveDispMov = lclaveDispMov;
	}
	public List getLnoFactura() {
		return lnoFactura;
	}
	public void setLnoFactura(List lnoFactura) {
		this.lnoFactura = lnoFactura;
	}
	public List getLproveedor() {
		return lproveedor;
	}
	public void setLproveedor(List lproveedor) {
		this.lproveedor = lproveedor;
	}
	public List getLtipoDeposito() {
		return ltipoDeposito;
	}
	public void setLtipoDeposito(List ltipoDeposito) {
		this.ltipoDeposito = ltipoDeposito;
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
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getEstatusEnc() {
		return estatusEnc;
	}
	public void setEstatusEnc(String estatusEnc) {
		this.estatusEnc = estatusEnc;
	}
	public String getEstatusDet() {
		return estatusDet;
	}
	public void setEstatusDet(String estatusDet) {
		this.estatusDet = estatusDet;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getParFechaEmision() {
		return parFechaEmision;
	}
	public void setParFechaEmision(String parFechaEmision) {
		this.parFechaEmision = parFechaEmision;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getNombreEstatusEnc() {
		return nombreEstatusEnc;
	}
	public void setNombreEstatusEnc(String nombreEstatusEnc) {
		this.nombreEstatusEnc = nombreEstatusEnc;
	}
	public String getNombreEstatusDet() {
		return nombreEstatusDet;
	}
	public void setNombreEstatusDet(String nombreEstatusDet) {
		this.nombreEstatusDet = nombreEstatusDet;
	}
	public String getDescripcionSuc() {
		return descripcionSuc;
	}
	public void setDescripcionSuc(String descripcionSuc) {
		this.descripcionSuc = descripcionSuc;
	}
	public String getCentroCostosID() {
		return centroCostosID;
	}
	public void setCentroCostosID(String centroCostosID) {
		this.centroCostosID = centroCostosID;
	}
	
 


	
} 