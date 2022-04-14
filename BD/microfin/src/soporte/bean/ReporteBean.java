package soporte.bean;

import java.util.List;

import general.bean.BaseBean;

public class ReporteBean extends BaseBean{
	
	String vista;

	String reporteID;
	String tituloReporte;
	String nombreArchivo;
	String nombreSP;
	String nombreHoja;
	
	String usuario;
	String fechaSistema;
	String nombreInstitucion;
	
	List<ReporteParametrosBean> parametros;
	List<ReporteColumnasBean> columnas;
	List<String> campos;
	List<String> valorCampos;
	List<String> valorParam;
	List<List<String>> filas;
	
	public String getReporteID() {
		return reporteID;
	}
	public void setReporteID(String reporteID) {
		this.reporteID = reporteID;
	}
	public String getTituloReporte() {
		return tituloReporte;
	}
	public void setTituloReporte(String tituloReporte) {
		this.tituloReporte = tituloReporte;
	}
	public String getNombreArchivo() {
		return nombreArchivo;
	}
	public void setNombreArchivo(String nombreArchivo) {
		this.nombreArchivo = nombreArchivo;
	}
	public String getNombreSP() {
		return nombreSP;
	}
	public void setNombreSP(String nombreSP) {
		this.nombreSP = nombreSP;
	}
	public String getNombreHoja() {
		return nombreHoja;
	}
	public void setNombreHoja(String nombreHoja) {
		this.nombreHoja = nombreHoja;
	}
	public List<ReporteParametrosBean> getParametros() {
		return parametros;
	}
	public void setParametros(List<ReporteParametrosBean> parametros) {
		this.parametros = parametros;
	}
	public List<String> getCampos() {
		return campos;
	}
	public void setCampos(List<String> campos) {
		this.campos = campos;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getVista() {
		return vista;
	}
	public void setVista(String vista) {
		this.vista = vista;
	}
	public List<ReporteColumnasBean> getColumnas() {
		return columnas;
	}
	public void setColumnas(List<ReporteColumnasBean> columnas) {
		this.columnas = columnas;
	}
	public List<String> getValorCampos() {
		return valorCampos;
	}
	public void setValorCampos(List<String> valorCampos) {
		this.valorCampos = valorCampos;
	}
	public List<String> getValorParam() {
		return valorParam;
	}
	public void setValorParam(List<String> valorParam) {
		this.valorParam = valorParam;
	}
	public List<List<String>> getFilas() {
		return filas;
	}
	public void setFilas(List<List<String>> filas) {
		this.filas = filas;
	}
}
