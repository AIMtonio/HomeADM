package soporte.bean;

import general.bean.BaseBean;

public class InstrumentosArchivosBean extends BaseBean{
	private String ArchivoBajID;
	private String tipoInstrumento;
	private String numeroInstrumento;
	
	public String getArchivoBajID() {
		return ArchivoBajID;
	}
	public void setArchivoBajID(String archivoBajID) {
		ArchivoBajID = archivoBajID;
	}
	
	public String getTipoInstrumento() {
		return tipoInstrumento;
	}
	public void setTipoInstrumento(String tipoInstrumento) {
		this.tipoInstrumento = tipoInstrumento;
	}
	public String getNumeroInstrumento() {
		return numeroInstrumento;
	}
	public void setNumeroInstrumento(String numeroInstrumento) {
		this.numeroInstrumento = numeroInstrumento;
	}
	
}