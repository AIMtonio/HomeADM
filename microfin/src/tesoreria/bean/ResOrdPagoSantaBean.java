package tesoreria.bean;

import general.bean.BaseBean;

public class ResOrdPagoSantaBean extends BaseBean{

	private String rutaArchivo;
	private String archivo;
	private String extensionArchivo;
	private String delimitador;
	private String contVencido;
	private String contCancelado;
	private String contLiquidado;
	private String contPendiente;
	
	public String getRutaArchivo() {
		return rutaArchivo;
	}
	public void setRutaArchivo(String rutaArchivo) {
		this.rutaArchivo = rutaArchivo;
	}
	public String getArchivo() {
		return archivo;
	}
	public void setArchivo(String archivo) {
		this.archivo = archivo;
	}
	public String getExtensionArchivo() {
		return extensionArchivo;
	}
	public void setExtensionArchivo(String extensionArchivo) {
		this.extensionArchivo = extensionArchivo;
	}
	public String getDelimitador() {
		return delimitador;
	}
	public void setDelimitador(String delimitador) {
		this.delimitador = delimitador;
	}
	public String getContVencido() {
		return contVencido;
	}
	public void setContVencido(String contVencido) {
		this.contVencido = contVencido;
	}
	public String getContCancelado() {
		return contCancelado;
	}
	public void setContCancelado(String contCancelado) {
		this.contCancelado = contCancelado;
	}
	public String getContLiquidado() {
		return contLiquidado;
	}
	public void setContLiquidado(String contLiquidado) {
		this.contLiquidado = contLiquidado;
	}
	public String getContPendiente() {
		return contPendiente;
	}
	public void setContPendiente(String contPendiente) {
		this.contPendiente = contPendiente;
	}
		
}
