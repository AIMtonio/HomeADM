package soporte.bean;

import java.util.List;

import general.bean.BaseBean;

public class GeneradorXMLBean extends BaseBean{

	private String reporteID;
	private String nombreReporte;
	private String descripcionReporte;
	private String nombreArchivo;
	private String nombreSP;
	private String elementoRoot;
	private String extension;
	private String rutaRep;
	private List<ReporteParametrosBean> parametros;
	private List<GeneradorXMLEtiquetasBean> etiquetas;
	private List<List<String>> filas;
	private List<String> campos;
	private List<String> valorCampos;
	private List<String> valorParam;
	
	public String getReporteID() {
		return reporteID;
	}
	public void setReporteID(String reporteID) {
		this.reporteID = reporteID;
	}
	public String getNombreReporte() {
		return nombreReporte;
	}
	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
	public String getDescripcionReporte() {
		return descripcionReporte;
	}
	public void setDescripcionReporte(String descripcionReporte) {
		this.descripcionReporte = descripcionReporte;
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
	public String getElementoRoot() {
		return elementoRoot;
	}
	public void setElementoRoot(String elementoRoot) {
		this.elementoRoot = elementoRoot;
	}
	public String getExtension() {
		return extension;
	}
	public void setExtension(String extension) {
		this.extension = extension;
	}
	public List<ReporteParametrosBean> getParametros() {
		return parametros;
	}
	public void setParametros(List<ReporteParametrosBean> parametros) {
		this.parametros = parametros;
	}
	public List<GeneradorXMLEtiquetasBean> getEtiquetas() {
		return etiquetas;
	}
	public void setEtiquetas(List<GeneradorXMLEtiquetasBean> etiquetas) {
		this.etiquetas = etiquetas;
	}
	public List<List<String>> getFilas() {
		return filas;
	}
	public void setFilas(List<List<String>> filas) {
		this.filas = filas;
	}
	public List<String> getCampos() {
		return campos;
	}
	public void setCampos(List<String> campos) {
		this.campos = campos;
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
	public String getRutaRep() {
		return rutaRep;
	}
	public void setRutaRep(String rutaRep) {
		this.rutaRep = rutaRep;
	}

}
