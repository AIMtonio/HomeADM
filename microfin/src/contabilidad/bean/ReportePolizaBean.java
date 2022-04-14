package contabilidad.bean;

import general.bean.BaseBean;

import java.util.Date;

public class ReportePolizaBean extends BaseBean{
	//Declaracion de Constantes
	
	//Declaracion de Variables
	private String fechaInicial;
	private String fechaFinal;
	
	private long polizaID;
	private long numeroTransaccion;
	private int sucursalID;
	private int monedaID;
	private String tipoInstrumentoID;
	private String primerRango;       // primer Rango de tipo de instrumento
	private String segundoRango;      // segundo Rango de Tipo de Instrumento
	private String primerCentroCostos; // primer centro de costos
	private String segundoCentroCostos;// segundo centro de costos
	private String nombCompletoCli; // Nombre Completo de cliente
	private String descTipoInstrumento; // descripcion del tipo de instrumento
		
	//Declaracion de variables auxiliares
	private String nombreUsuario;
	private String nombreInstitucion;
	private String fechaEmision;
	private String nombreSucursal;
	private String descripMoneda;
	private String valorTransaccion;
	private String valorPoliza;
	
	// Declaracion de variables auxiliares excel
	private String fecha;
	private String tipo;
	private String concepto;
	private String instrumento;
	private String cuentaCompleta;
	private String detDescri;
	private String referencia;
	private String cargos;
	private String abonos;
	private String cueDescri;
	private String descripcion;
	private String nombreSucurs;
	private String centroCostoID;
	private String hora;
	private String usuarioID;
	private String nomUsuario;
	
	public long getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(long polizaID) {
		this.polizaID = polizaID;
	}
	public long getNumeroTransaccion() {
		return numeroTransaccion;
	}
	public void setNumeroTransaccion(long numeroTransaccion) {
		this.numeroTransaccion = numeroTransaccion;
	}
	public int getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(int sucursalID) {
		this.sucursalID = sucursalID;
	}
	public int getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(int monedaID) {
		this.monedaID = monedaID;
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
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getDescripMoneda() {
		return descripMoneda;
	}
	public void setDescripMoneda(String descripMoneda) {
		this.descripMoneda = descripMoneda;
	}
	public String getValorTransaccion() {
		return valorTransaccion;
	}
	public void setValorTransaccion(String valorTransaccion) {
		this.valorTransaccion = valorTransaccion;
	}
	public String getValorPoliza() {
		return valorPoliza;
	}
	public void setValorPoliza(String valorPoliza) {
		this.valorPoliza = valorPoliza;
	}
	public String getCuentaCompleta() {
		return cuentaCompleta;
	}
	public void setCuentaCompleta(String cuentaCompleta) {
		this.cuentaCompleta = cuentaCompleta;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getConcepto() {
		return concepto;
	}
	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}
	public String getInstrumento() {
		return instrumento;
	}
	public void setInstrumento(String instrumento) {
		this.instrumento = instrumento;
	}
	public String getDetDescri() {
		return detDescri;
	}
	public void setDetDescri(String detDescri) {
		this.detDescri = detDescri;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getCargos() {
		return cargos;
	}
	public void setCargos(String cargos) {
		this.cargos = cargos;
	}
	public String getAbonos() {
		return abonos;
	}
	public void setAbonos(String abonos) {
		this.abonos = abonos;
	}
	public String getCueDescri() {
		return cueDescri;
	}
	public void setCueDescri(String cueDescri) {
		this.cueDescri = cueDescri;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getNombreSucurs() {
		return nombreSucurs;
	}
	public void setNombreSucurs(String nombreSucurs) {
		this.nombreSucurs = nombreSucurs;
	}
	public String getCentroCostoID() {
		return centroCostoID;
	}
	public void setCentroCostoID(String centroCostoID) {
		this.centroCostoID = centroCostoID;
	}	
	public String getTipoInstrumentoID() {
		return tipoInstrumentoID;
	}
	public void setTipoInstrumentoID(String tipoInstrumentoID) {
		this.tipoInstrumentoID = tipoInstrumentoID;
	}
	public String getPrimerRango() {
		return primerRango;
	}
	public void setPrimerRango(String primerRango) {
		this.primerRango = primerRango;
	}
	public String getSegundoRango() {
		return segundoRango;
	}
	public void setSegundoRango(String segundoRango) {
		this.segundoRango = segundoRango;
	}
	public String getPrimerCentroCostos() {
		return primerCentroCostos;
	}
	public void setPrimerCentroCostos(String primerCentroCostos) {
		this.primerCentroCostos = primerCentroCostos;
	}
	public String getSegundoCentroCostos() {
		return segundoCentroCostos;
	}
	public void setSegundoCentroCostos(String segundoCentroCostos) {
		this.segundoCentroCostos = segundoCentroCostos;
	}
	public String getNombCompletoCli() {
		return nombCompletoCli;
	}
	public void setNombCompletoCli(String nombCompletoCli) {
		this.nombCompletoCli = nombCompletoCli;
	}
	public String getDescTipoInstrumento() {
		return descTipoInstrumento;
	}
	public void setDescTipoInstrumento(String descTipoInstrumento) {
		this.descTipoInstrumento = descTipoInstrumento;
	}
	public String getHora() {
		return hora;
	}
	public void setHora(String hora) {
		this.hora = hora;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getNomUsuario() {
		return nomUsuario;
	}
	public void setNomUsuario(String nomUsuario) {
		this.nomUsuario = nomUsuario;
	}
	
}
