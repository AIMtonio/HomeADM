package regulatorios.bean;

import general.bean.BaseBean;

public class EstimacionPreventivaA419Bean extends BaseBean {
	 

	//Variables o Atributos
	private String fecha;	
	private String periodo;
	private String claveEntidad;
	private String subReporte;
	private String claveConcepto;
	private String descripcion;
	private String formulario;
	private String tipoMoneda;	
	private String tipoCartera;
	private String tipoSaldo;
	private String monto;
	private String valor;
	
	
	public String getValor() {
		return valor;
	}
	public void setValor(String valor) {
		this.valor = valor;
	}
	
	public String getPeriodo() {
		return periodo;
	}
	public void setPeriodo(String periodo) {
		this.periodo = periodo;
	}
	
	
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getClaveEntidad() {
		return claveEntidad;
	}
	public void setClaveEntidad(String claveEntidad) {
		this.claveEntidad = claveEntidad;
	}
	public String getSubReporte() {
		return subReporte;
	}
	public void setSubReporte(String subReporte) {
		this.subReporte = subReporte;
	}
	public String getClaveConcepto() {
		return claveConcepto;
	}
	public void setClaveConcepto(String claveConcepto) {
		this.claveConcepto = claveConcepto;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getFormulario() {
		return formulario;
	}
	public void setFormulario(String formulario) {
		this.formulario = formulario;
	}
	public String getTipoMoneda() {
		return tipoMoneda;
	}
	public void setTipoMoneda(String tipoMoneda) {
		this.tipoMoneda = tipoMoneda;
	}
	public String getTipoCartera() {
		return tipoCartera;
	}
	public void setTipoCartera(String tipoCartera) {
		this.tipoCartera = tipoCartera;
	}
	public String getTipoSaldo() {
		return tipoSaldo;
	}
	public void setTipoSaldo(String tipoSaldo) {
		this.tipoSaldo = tipoSaldo;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	
	
}
