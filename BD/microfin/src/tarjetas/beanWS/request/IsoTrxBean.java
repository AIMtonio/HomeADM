package tarjetas.beanWS.request;

import tarjetas.bean.ParamTarjetasBean;
import general.bean.BaseBeanWS;

public class IsoTrxBean extends BaseBeanWS {
	
	private String tipoTarjeta;
	private String rutaConSAFIWS;
	private String usuarioConSAFIWS;
	private ParamTarjetasBean paramTarjetasBean;
	private TarjetaPeticionRequest tarjetaPeticionRequest;
	private OperacionTarjetaRequest operacionTarjetaRequest;

	public String getTipoTarjeta() {
		return tipoTarjeta;
	}
	public void setTipoTarjeta(String tipoTarjeta) {
		this.tipoTarjeta = tipoTarjeta;
	}
	public String getRutaConSAFIWS() {
		return rutaConSAFIWS;
	}
	public void setRutaConSAFIWS(String rutaConSAFIWS) {
		this.rutaConSAFIWS = rutaConSAFIWS;
	}
	public String getUsuarioConSAFIWS() {
		return usuarioConSAFIWS;
	}
	public void setUsuarioConSAFIWS(String usuarioConSAFIWS) {
		this.usuarioConSAFIWS = usuarioConSAFIWS;
	}
	public ParamTarjetasBean getParamTarjetasBean() {
		return paramTarjetasBean;
	}
	public void setParamTarjetasBean(ParamTarjetasBean paramTarjetasBean) {
		this.paramTarjetasBean = paramTarjetasBean;
	}
	public TarjetaPeticionRequest getTarjetaPeticionRequest() {
		return tarjetaPeticionRequest;
	}
	public void setTarjetaPeticionRequest(
			TarjetaPeticionRequest tarjetaPeticionRequest) {
		this.tarjetaPeticionRequest = tarjetaPeticionRequest;
	}
	public OperacionTarjetaRequest getOperacionTarjetaRequest() {
		return operacionTarjetaRequest;
	}
	public void setOperacionTarjetaRequest(
			OperacionTarjetaRequest operacionTarjetaRequest) {
		this.operacionTarjetaRequest = operacionTarjetaRequest;
	}
	
}
