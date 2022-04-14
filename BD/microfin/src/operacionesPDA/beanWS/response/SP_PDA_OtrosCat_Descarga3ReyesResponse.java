package operacionesPDA.beanWS.response;

import java.util.ArrayList;

import operacionesPDA.bean.SP_PDA_OtrosCat_Descarga3ReyesBean;
import general.bean.BaseBeanWS;

public class SP_PDA_OtrosCat_Descarga3ReyesResponse extends BaseBeanWS{

	private ArrayList<SP_PDA_OtrosCat_Descarga3ReyesBean> otrosCat = new ArrayList<SP_PDA_OtrosCat_Descarga3ReyesBean>();  
	
	public ArrayList<SP_PDA_OtrosCat_Descarga3ReyesBean> getOtrosCat() {
		return otrosCat;
	}
	public void setOtrosCat(ArrayList<SP_PDA_OtrosCat_Descarga3ReyesBean> otrosCatal) {
		this.otrosCat = otrosCatal;
	} 
	public void addOtrosCat(SP_PDA_OtrosCat_Descarga3ReyesBean otrosCata){  
        this.otrosCat.add(otrosCata);  
	}

}