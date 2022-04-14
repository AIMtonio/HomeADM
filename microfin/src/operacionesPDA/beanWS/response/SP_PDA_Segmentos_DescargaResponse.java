package operacionesPDA.beanWS.response;

import general.bean.BaseBeanWS;

import java.util.ArrayList;

import cliente.bean.GruposNosolidariosBean;
import cliente.bean.PromotoresBean;

public class SP_PDA_Segmentos_DescargaResponse extends BaseBeanWS{
private ArrayList<GruposNosolidariosBean> segmentos = new ArrayList<GruposNosolidariosBean>();

private ArrayList<PromotoresBean> promotores = new ArrayList<PromotoresBean>();

	
	public void addSegmento(GruposNosolidariosBean segmento){  
        this.segmentos.add(segmento);  
	}

	public ArrayList<GruposNosolidariosBean> getSegmentos() {
		return segmentos;
	}

	public void setSegmentos(ArrayList<GruposNosolidariosBean> segmentos) {
		this.segmentos = segmentos;
	}
	
	/* Lista de Promotores Externos */

	public void addSegmentos(PromotoresBean promotor){  
        this.promotores.add(promotor);  
	}

	public ArrayList<PromotoresBean> getPromotores() {
		return promotores;
	}

	public void setPromotores(ArrayList<PromotoresBean> promotores) {
		this.promotores = promotores;
	}	
	
}