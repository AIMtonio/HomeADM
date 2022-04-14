package tarjetas.beanWS.request;

import general.bean.BaseBeanWS;

public class IsotrxRequest extends BaseBeanWS {

	private ParamTarjetasRequest paramTarjetasRequest;
	private TarjetaPeticionRequest tarjetaPeticionRequest;
	private OperacionTarjetaRequest operacionTarjetaRequest;

	public ParamTarjetasRequest getParamTarjetasRequest() {
		return paramTarjetasRequest;
	}
	public void setParamTarjetasRequest(ParamTarjetasRequest paramTarjetasRequest) {
		this.paramTarjetasRequest = paramTarjetasRequest;
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
