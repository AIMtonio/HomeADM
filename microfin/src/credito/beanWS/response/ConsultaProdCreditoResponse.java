package credito.beanWS.response;

import general.bean.BaseBeanWS;

public class ConsultaProdCreditoResponse extends BaseBeanWS {

	private String descripcion;			
	private String formaCobroComAper;
	private String montoComision;
	private String porcentajeGarLiquida;
	private String factorMora;
	private String destinoCredito;
	private String clasificacionDestino;
	
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getFormaCobroComAper() {
		return formaCobroComAper;
	}

	public void setFormaCobroComAper(String formaCobroComAper) {
		this.formaCobroComAper = formaCobroComAper;
	}

	public String getMontoComision() {
		return montoComision;
	}

	public void setMontoComision(String montoComision) {
		this.montoComision = montoComision;
	}
	public String getPorcentajeGarLiquida() {
		return porcentajeGarLiquida;
	}
	public void setPorcentajeGarLiquida(String porcentajeGarLiquida) {
		this.porcentajeGarLiquida = porcentajeGarLiquida;
	}
	public String getFactorMora() {
		return factorMora;
	}
	public void setFactorMora(String factorMora) {
		this.factorMora = factorMora;
	}
	public String getDestinoCredito() {
		return destinoCredito;
	}
	public void setDestinoCredito(String destinoCredito) {
		this.destinoCredito = destinoCredito;
	}
	public String getClasificacionDestino() {
		return clasificacionDestino;
	}
	public void setClasificacionDestino(String clasificacionDestino) {
		this.clasificacionDestino = clasificacionDestino;
	}
	
	
	
}
