package credito.bean;
import general.bean.BaseBean;
       
public class ReporteMovimientosCreditosBean extends BaseBean{
	private String amortiCreID;
	private String transaccion;
	private String fechaOperacion;
	private String fechaAplicacion;
	private String descripcion;
	private String tipoMovCreID;
	private String natMovimiento;
	private String monedaID;
	private String cantidad;
	private String referencia;
	private String tipoMov;
	private String horaMov;
	private String fechaEmision;
	private String cuentaID;
	private String creditoID;
	private String fechaIni;
	private String fechaFin;
	
	//Sumarizado
	private String Fecha;
	private String descripcions;
	private Double monto;
	private Double capital;
	private Double interesNormal;
	private Double ivainteresNormal;
	private Double interesMoratorio;
	private Double ivainteresMoratorio;
	private Double comisionFaltapago;
	private Double ivaComisiones;	
	private String horaEmision;
	private Double montoSeguroCuota;
	private Double montoIVASeguroCuota;
	private String cobraSeguroCuota;
	
	public String getAmortiCreID() {
		return amortiCreID;
	}
	public void setAmortiCreID(String amortiCreID) {
		this.amortiCreID = amortiCreID;
	}
	public String getTransaccion() {
		return transaccion;
	}
	public void setTransaccion(String transaccion) {
		this.transaccion = transaccion;
	}
	public String getFechaOperacion() {
		return fechaOperacion;
	}
	public void setFechaOperacion(String fechaOperacion) {
		this.fechaOperacion = fechaOperacion;
	}
	public String getFechaAplicacion() {
		return fechaAplicacion;
	}
	public void setFechaAplicacion(String fechaAplicacion) {
		this.fechaAplicacion = fechaAplicacion;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getTipoMovCreID() {
		return tipoMovCreID;
	}
	public void setTipoMovCreID(String tipoMovCreID) {
		this.tipoMovCreID = tipoMovCreID;
	}
	public String getNatMovimiento() {
		return natMovimiento;
	}
	public void setNatMovimiento(String natMovimiento) {
		this.natMovimiento = natMovimiento;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getCantidad() {
		return cantidad;
	}
	public void setCantidad(String cantidad) {
		this.cantidad = cantidad;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getTipoMov() {
		return tipoMov;
	}
	public void setTipoMov(String tipoMov) {
		this.tipoMov = tipoMov;
	}
	public String getHoraMov() {
		return horaMov;
	}
	public void setHoraMov(String horaMov) {
		this.horaMov = horaMov;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getCuentaID() {
		return cuentaID;
	}
	public void setCuentaID(String cuentaID) {
		this.cuentaID = cuentaID;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getFechaIni() {
		return fechaIni;
	}
	public void setFechaIni(String fechaIni) {
		this.fechaIni = fechaIni;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getFecha() {
		return Fecha;
	}
	public void setFecha(String fecha) {
		Fecha = fecha;
	}
	public String getDescripcions() {
		return descripcions;
	}
	public void setDescripcions(String descripcions) {
		this.descripcions = descripcions;
	}
	public Double getMonto() {
		return monto;
	}
	public void setMonto(Double monto) {
		this.monto = monto;
	}
	public Double getCapital() {
		return capital;
	}
	public void setCapital(Double capital) {
		this.capital = capital;
	}
	public Double getInteresNormal() {
		return interesNormal;
	}
	public void setInteresNormal(Double interesNormal) {
		this.interesNormal = interesNormal;
	}
	public Double getIvainteresNormal() {
		return ivainteresNormal;
	}
	public void setIvainteresNormal(Double ivainteresNormal) {
		this.ivainteresNormal = ivainteresNormal;
	}
	public Double getInteresMoratorio() {
		return interesMoratorio;
	}
	public void setInteresMoratorio(Double interesMoratorio) {
		this.interesMoratorio = interesMoratorio;
	}
	public Double getIvainteresMoratorio() {
		return ivainteresMoratorio;
	}
	public void setIvainteresMoratorio(Double ivainteresMoratorio) {
		this.ivainteresMoratorio = ivainteresMoratorio;
	}
	public Double getComisionFaltapago() {
		return comisionFaltapago;
	}
	public void setComisionFaltapago(Double comisionFaltapago) {
		this.comisionFaltapago = comisionFaltapago;
	}
	public Double getIvaComisiones() {
		return ivaComisiones;
	}
	public void setIvaComisiones(Double ivaComisiones) {
		this.ivaComisiones = ivaComisiones;
	}
	public String getHoraEmision() {
		return horaEmision;
	}
	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}
	public Double getMontoSeguroCuota() {
		return montoSeguroCuota;
	}
	public void setMontoSeguroCuota(Double montoSeguroCuota) {
		this.montoSeguroCuota = montoSeguroCuota;
	}
	public Double getMontoIVASeguroCuota() {
		return montoIVASeguroCuota;
	}
	public void setMontoIVASeguroCuota(Double montoIVASeguroCuota) {
		this.montoIVASeguroCuota = montoIVASeguroCuota;
	}
	public String getCobraSeguroCuota() {
		return cobraSeguroCuota;
	}
	public void setCobraSeguroCuota(String cobraSeguroCuota) {
		this.cobraSeguroCuota = cobraSeguroCuota;
	}
	
	
}
