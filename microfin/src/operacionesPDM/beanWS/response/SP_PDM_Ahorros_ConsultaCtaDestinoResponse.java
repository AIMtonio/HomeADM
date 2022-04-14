package operacionesPDM.beanWS.response;

import java.util.ArrayList;

import operacionesPDM.bean.CuentasDestinoBean;

public class SP_PDM_Ahorros_ConsultaCtaDestinoResponse {	
	
	private String EsValido;
	private String codigoRespuesta;
	private String mensajeRespuesta;	
	private ArrayList<CuentasDestinoBean> conCtaDestino = new ArrayList<CuentasDestinoBean>();  	
	
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
	
	public ArrayList<CuentasDestinoBean> getConCtaDestino() {
		return conCtaDestino;
	}
	public void setConCtaDestino(ArrayList<CuentasDestinoBean> conCtaDestino) {
		this.conCtaDestino = conCtaDestino;
	} 
	public void addCtaDestino(CuentasDestinoBean conCtaDestino){  
        this.conCtaDestino.add(conCtaDestino);  
	}	

}
