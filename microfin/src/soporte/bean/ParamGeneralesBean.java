package soporte.bean;

import general.bean.BaseBean;

import java.util.List;

public class ParamGeneralesBean extends BaseBean {
	private  String valorParametro ;	
	private  String llaveParametro;
	
	
	private List<String> llavesParametros; // ID del parametro
	private List<String> valoresParametros; // respuesta de parametro
	
	public String getValorParametro() {
		return valorParametro;
	}
	public void setValorParametro(String valorParametro) {
		this.valorParametro = valorParametro;
	}
	public String getLlaveParametro() {
		return llaveParametro;
	}
	public void setLlaveParametro(String llaveParametro) {
		this.llaveParametro = llaveParametro;
	}
	public List<String> getLlavesParametros() {
		return llavesParametros;
	}
	public void setLlavesParametros(List<String> llavesParametros) {
		this.llavesParametros = llavesParametros;
	}
	public List<String> getValoresParametros() {
		return valoresParametros;
	}
	public void setValoresParametros(List<String> valoresParametros) {
		this.valoresParametros = valoresParametros;
	}

	
	
	
	
}