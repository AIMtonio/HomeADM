package credito.beanWS.response;

import general.bean.BaseBeanWS;

public class ConsultaTasaFijaResponse extends BaseBeanWS {
  private String tasaFija;

  public String getTasaFija() {
	return tasaFija;
  }

  public void setTasaFija(String tasaFija) {
	this.tasaFija = tasaFija;
  }
	
}
