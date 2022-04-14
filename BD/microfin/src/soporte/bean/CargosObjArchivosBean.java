package soporte.bean;

import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;

public class CargosObjArchivosBean extends BaseBean{
	private String layout;
	private MultipartFile file;
	private int tamanioListaCarga;
	private String descripcionMov;
	private String fecha;
	private String montoCargo;
	private String montoAbono;
	private String folio;
	private String periodo;
	private String tipoInstrumento;
	private String instrumentoID;
	private String descripcion;
    private String  error;
	
	
	public String getLayout() {
		return layout;
	}
	public void setLayout(String layout) {
		this.layout = layout;
	}
	
	public int getTamanioListaCarga() {
		return tamanioListaCarga;
	}
	public void setTamanioListaCarga(int tamanioListaCarga) {
		this.tamanioListaCarga = tamanioListaCarga;
	}
	
	public String getDescripcionMov() {
		return descripcionMov;
	}
	public void setDescripcionMov(String descripcionMov) {
		this.descripcionMov = descripcionMov;
	}
	public MultipartFile getFile() {
		return file;
	}
	public void setFile(MultipartFile file) {
		this.file = file;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getMontoCargo() {
		return montoCargo;
	}
	public void setMontoCargo(String montoCargo) {
		this.montoCargo = montoCargo;
	}
	public String getMontoAbono() {
		return montoAbono;
	}
	public void setMontoAbono(String montoAbono) {
		this.montoAbono = montoAbono;
	}
	public String getFolio() {
		return folio;
	}
	public void setFolio(String folio) {
		this.folio = folio;
	}
	public String getPeriodo() {
		return periodo;
	}
	public void setPeriodo(String periodo) {
		this.periodo = periodo;
	}
	public String getTipoInstrumento() {
		return tipoInstrumento;
	}
	public void setTipoInstrumento(String tipoInstrumento) {
		this.tipoInstrumento = tipoInstrumento;
	}
	public String getInstrumentoID() {
		return instrumentoID;
	}
	public void setInstrumentoID(String instrumentoID) {
		this.instrumentoID = instrumentoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getError() {
		return error;
	}
	public void setError(String error) {
		this.error = error;
	}
	
	
	
    
	
}
