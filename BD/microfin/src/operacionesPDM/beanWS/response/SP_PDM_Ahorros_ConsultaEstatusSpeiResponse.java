package operacionesPDM.beanWS.response;

import java.util.ArrayList;

import operacionesPDM.bean.ConsultaEstatusSepiBean;

public class SP_PDM_Ahorros_ConsultaEstatusSpeiResponse {
	
	private String EsValido;
	private String codigoRespuesta;
	private String mensajeRespuesta;	
	
	private ArrayList<ConsultaEstatusSepiBean> conEstatusSpei = new ArrayList<ConsultaEstatusSepiBean>();

	public String getEsValido() {
		return EsValido;
	}

	public void setEsValido(String esValido) {
		EsValido = esValido;
	}

	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}

	public void setCodigoRespuesta(String codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}

	public String getMensajeRespuesta() {
		return mensajeRespuesta;
	}

	public void setMensajeRespuesta(String mensajeRespuesta) {
		this.mensajeRespuesta = mensajeRespuesta;
	}

	public ArrayList<ConsultaEstatusSepiBean> getConEstatusSpei() {
		return conEstatusSpei;
	}

	public void setConEstatusSpei(ArrayList<ConsultaEstatusSepiBean> conEstatusSpei) {
		this.conEstatusSpei = conEstatusSpei;
	}  
	
	public void addConSpei(ConsultaEstatusSepiBean conEstatusSpei){  
        this.conEstatusSpei.add(conEstatusSpei);  
	}
	
}
