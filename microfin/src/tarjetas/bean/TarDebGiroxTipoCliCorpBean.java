package tarjetas.bean;
import java.util.List;
import general.bean.BaseBean;

public class TarDebGiroxTipoCliCorpBean  extends BaseBean {
	private String tipoTarjetaDebID;
	private String nombreTarjeta;
	private String coorporativo;
	private String nombreCoorp;
	private String giroID;
	private String descripcion;
	private  List lnumGiro;
	
	
	
	public String getTipoTarjetaDebID() {
		return tipoTarjetaDebID;
	}
	public void setTipoTarjetaDebID(String tipoTarjetaDebID) {
		this.tipoTarjetaDebID = tipoTarjetaDebID;
	}
	public String getNombreTarjeta() {
		return nombreTarjeta;
	}
	public void setNombreTarjeta(String nombreTarjeta) {
		this.nombreTarjeta = nombreTarjeta;
	}
	public String getCoorporativo() {
		return coorporativo;
	}
	public void setCoorporativo(String coorporativo) {
		this.coorporativo = coorporativo;
	}
	public String getNombreCoorp() {
		return nombreCoorp;
	}
	public void setNombreCoorp(String nombreCoorp) {
		this.nombreCoorp = nombreCoorp;
	}
	public String getGiroID() {
		return giroID;
	}
	public void setGiroID(String giroID) {
		this.giroID = giroID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public List getLnumGiro() {
		return lnumGiro;
	}
	public void setLnumGiro(List lnumGiro) {
		this.lnumGiro = lnumGiro;
	}


}
