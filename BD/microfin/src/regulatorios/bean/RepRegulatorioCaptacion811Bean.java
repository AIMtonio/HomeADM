package regulatorios.bean;
import general.bean.BaseBean;
public class RepRegulatorioCaptacion811Bean extends BaseBean{
	private String fecha;
	private String concepto;
	private String salCapCie;
	private String salIntNoPa; 
	private String salCieMes;
	private String intMes;
	private String comMes;
	private String valor;
	
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getConcepto() {
		return concepto;
	}
	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}
	public String getSalCapCie() {
		return salCapCie;
	}
	public void setSalCapCie(String salCapCie) {
		this.salCapCie = salCapCie;
	}
	public String getSalIntNoPa() {
		return salIntNoPa;
	}
	public void setSalIntNoPa(String salIntNoPa) {
		this.salIntNoPa = salIntNoPa;
	}
	public String getSalCieMes() {
		return salCieMes;
	}
	public void setSalCieMes(String salCieMes) {
		this.salCieMes = salCieMes;
	}
	public String getIntMes() {
		return intMes;
	}
	public void setIntMes(String intMes) {
		this.intMes = intMes;
	}
	public String getComMes() {
		return comMes;
	}
	public void setComMes(String comMes) {
		this.comMes = comMes;
	}
	public String getValor() {
		return valor;
	}
	public void setValor(String valor) {
		this.valor = valor;
	}
	
}
