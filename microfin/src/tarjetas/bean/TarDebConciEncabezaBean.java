package tarjetas.bean;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;

public class TarDebConciEncabezaBean extends BaseBean{
	private MultipartFile file;
	private String conciliaID;
	private String nomInstituGenera;
	private String nomInstituRecibe;
	private String fechaProceso;
	private String consecutivo;
	private String fechaCarga;	
	private String nombreArchivo;
	
	private List listMovConcilia;
	
	private List listTipoOperacionInt;
	private List listNumTarjetaInt;
	private List listReferenciaInt;
	private List listMontoTransInt;
	private List listTipoOperacionExt;
	private List listNumTarjetaExt;
	private List listReferenciaExt;
	private List listMontoTransExt;	
	
	//Auxiliares
	private String continuaCarga;
	private String ruta;
	
	public String getConciliaID() {
		return conciliaID;
	}
	public void setConciliaID(String conciliaID) {
		this.conciliaID = conciliaID;
	}
	public String getNomInstituGenera() {
		return nomInstituGenera;
	}
	public void setNomInstituGenera(String nomInstituGenera) {
		this.nomInstituGenera = nomInstituGenera;
	}
	public String getNomInstituRecibe() {
		return nomInstituRecibe;
	}
	public void setNomInstituRecibe(String nomInstituRecibe) {
		this.nomInstituRecibe = nomInstituRecibe;
	}
	public String getFechaProceso() {
		return fechaProceso;
	}
	public void setFechaProceso(String fechaProceso) {
		this.fechaProceso = fechaProceso;
	}
	public String getConsecutivo() {
		return consecutivo;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
	}
	public String getFechaCarga() {
		return fechaCarga;
	}
	public void setFechaCarga(String fechaCarga) {
		this.fechaCarga = fechaCarga;
	}
	public MultipartFile getFile() {
		return file;
	}
	public void setFile(MultipartFile file) {
		this.file = file;
	}
	public List getListMovConcilia() {
		return listMovConcilia;
	}
	public void setListMovConcilia(List listMovConcilia) {
		this.listMovConcilia = listMovConcilia;
	}
	public List getListTipoOperacionInt() {
		return listTipoOperacionInt;
	}
	public void setListTipoOperacionInt(List listTipoOperacionInt) {
		this.listTipoOperacionInt = listTipoOperacionInt;
	}
	public List getListNumTarjetaInt() {
		return listNumTarjetaInt;
	}
	public void setListNumTarjetaInt(List listNumTarjetaInt) {
		this.listNumTarjetaInt = listNumTarjetaInt;
	}
	public List getListReferenciaInt() {
		return listReferenciaInt;
	}
	public void setListReferenciaInt(List listReferenciaInt) {
		this.listReferenciaInt = listReferenciaInt;
	}
	public List getListMontoTransInt() {
		return listMontoTransInt;
	}
	public void setListMontoTransInt(List listMontoTransInt) {
		this.listMontoTransInt = listMontoTransInt;
	}
	public List getListTipoOperacionExt() {
		return listTipoOperacionExt;
	}
	public void setListTipoOperacionExt(List listTipoOperacionExt) {
		this.listTipoOperacionExt = listTipoOperacionExt;
	}
	public List getListNumTarjetaExt() {
		return listNumTarjetaExt;
	}
	public void setListNumTarjetaExt(List listNumTarjetaExt) {
		this.listNumTarjetaExt = listNumTarjetaExt;
	}
	public List getListReferenciaExt() {
		return listReferenciaExt;
	}
	public void setListReferenciaExt(List listReferenciaExt) {
		this.listReferenciaExt = listReferenciaExt;
	}
	public List getListMontoTransExt() {
		return listMontoTransExt;
	}
	public void setListMontoTransExt(List listMontoTransExt) {
		this.listMontoTransExt = listMontoTransExt;
	}
	public String getContinuaCarga() {
		return continuaCarga;
	}
	public void setContinuaCarga(String continuaCarga) {
		this.continuaCarga = continuaCarga;
	}
	public String getRuta() {
		return ruta;
	}
	public void setRuta(String ruta) {
		this.ruta = ruta;
	}
	public String getNombreArchivo() {
		return nombreArchivo;
	}
	public void setNombreArchivo(String nombreArchivo) {
		this.nombreArchivo = nombreArchivo;
	}
	
	
}