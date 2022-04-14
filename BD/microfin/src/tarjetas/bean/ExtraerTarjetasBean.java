package tarjetas.bean;

import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;

public class ExtraerTarjetasBean extends BaseBean{
	private MultipartFile file;
	private String tarDebExtraccionDetID;
	private String iD;
	private String tarDebExtraccionID;
	private String nomArchivo;
	private String bin;
	private String subBin;
	private String contenido;
	private String esHeader;
	private String tipoTarjetaDebID;
	private String nomArchivoExt;
	private String tipo;
	private String nomArchivoZip;
	private String ruta;
	public MultipartFile getFile() {
		return file;
	}
	public void setFile(MultipartFile file) {
		this.file = file;
	}
	public String getTarDebExtraccionDetID() {
		return tarDebExtraccionDetID;
	}
	public void setTarDebExtraccionDetID(String tarDebExtraccionDetID) {
		this.tarDebExtraccionDetID = tarDebExtraccionDetID;
	}
	public String getTarDebExtraccionID() {
		return tarDebExtraccionID;
	}
	public void setTarDebExtraccionID(String tarDebExtraccionID) {
		this.tarDebExtraccionID = tarDebExtraccionID;
	}
	public String getBin() {
		return bin;
	}
	public void setBin(String bin) {
		this.bin = bin;
	}
	public String getSubBin() {
		return subBin;
	}
	public void setSubBin(String subBin) {
		this.subBin = subBin;
	}
	public String getNomArchivoExt() {
		return nomArchivoExt;
	}
	public void setNomArchivoExt(String nomArchivoExt) {
		this.nomArchivoExt = nomArchivoExt;
	}
	public String getiD() {
		return iD;
	}
	public void setiD(String iD) {
		this.iD = iD;
	}
	public String getNomArchivo() {
		return nomArchivo;
	}
	public void setNomArchivo(String nomArchivo) {
		this.nomArchivo = nomArchivo;
	}
	public String getContenido() {
		return contenido;
	}
	public void setContenido(String contenido) {
		this.contenido = contenido;
	}
	public String getEsHeader() {
		return esHeader;
	}
	public void setEsHeader(String esHeader) {
		this.esHeader = esHeader;
	}
	public String getTipoTarjetaDebID() {
		return tipoTarjetaDebID;
	}
	public void setTipoTarjetaDebID(String tipoTarjetaDebID) {
		this.tipoTarjetaDebID = tipoTarjetaDebID;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getNomArchivoZip() {
		return nomArchivoZip;
	}
	public void setNomArchivoZip(String nomArchivoZip) {
		this.nomArchivoZip = nomArchivoZip;
	}
	public String getRuta() {
		return ruta;
	}
	public void setRuta(String ruta) {
		this.ruta = ruta;
	}
	
	
}
