package psl.rest;

import java.util.Map;

public class ConsumoRestBean<T> {
	private T beanRequest;
	private String urlServicio;
	private String endPoint;
	private Map<String, String> headers;
	private MetodoHTTP tipoEnvio;
	
	public T getBeanRequest() {
		return beanRequest;
	}
	public void setBeanRequest(T beanRequest) {
		this.beanRequest = beanRequest;
	}
	public String getUrlServicio() {
		return urlServicio;
	}
	public void setUrlServicio(String urlServicio) {
		this.urlServicio = urlServicio;
	}
	public String getEndPoint() {
		return endPoint;
	}
	public void setEndPoint(String endPoint) {
		this.endPoint = endPoint;
	}
	public Map<String, String> getHeaders() {
		return headers;
	}
	public void setHeaders(Map<String, String> headers) {
		this.headers = headers;
	}
	public MetodoHTTP getTipoEnvio() {
		return tipoEnvio;
	}
	public void setTipoEnvio(MetodoHTTP tipoEnvio) {
		this.tipoEnvio = tipoEnvio;
	}
}