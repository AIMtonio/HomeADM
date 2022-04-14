package operacionesPDA.beanWS.response;

import java.util.ArrayList;

import credito.bean.CreditosBean;

import general.bean.BaseBeanWS;

public class SP_PDA_Creditos_DescargaResponse extends BaseBeanWS{
	private ArrayList<CreditosBean> creditos = new ArrayList<CreditosBean>();  
	
	public ArrayList<CreditosBean> getCreditos() {
		return creditos;
	}
	public void setCreditos(ArrayList<CreditosBean> creditos) {
		this.creditos = creditos;
	} 
	public void addCredito(CreditosBean credito){  
        this.creditos.add(credito);  
	}
	
}