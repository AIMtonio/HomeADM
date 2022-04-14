package tarjetas.bean;

import general.bean.BaseBean;
public class LoteTarjetaDebBean extends BaseBean{
	private String loteDebitoID;
	private String tipoTarjetaDebID;
	private String fechaRegistro;
	private String usuarioID;
	private String numTarjetas;
	private String folioInicial;
	private String folioFinal;
	private String bitCargaID;
	public String getLoteDebitoID() {
		return loteDebitoID;
	}
	public void setLoteDebitoID(String loteDebitoID) {
		this.loteDebitoID = loteDebitoID;
	}
	public String getTipoTarjetaDebID() {
		return tipoTarjetaDebID;
	}
	public void setTipoTarjetaDebID(String tipoTarjetaDebID) {
		this.tipoTarjetaDebID = tipoTarjetaDebID;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getNumTarjetas() {
		return numTarjetas;
	}
	public void setNumTarjetas(String numTarjetas) {
		this.numTarjetas = numTarjetas;
	}
	public String getFolioInicial() {
		return folioInicial;
	}
	public void setFolioInicial(String folioInicial) {
		this.folioInicial = folioInicial;
	}
	public String getFolioFinal() {
		return folioFinal;
	}
	public void setFolioFinal(String folioFinal) {
		this.folioFinal = folioFinal;
	}
	public String getBitCargaID() {
		return bitCargaID;
	}
	public void setBitCargaID(String bitCargaID) {
		this.bitCargaID = bitCargaID;
	}

}