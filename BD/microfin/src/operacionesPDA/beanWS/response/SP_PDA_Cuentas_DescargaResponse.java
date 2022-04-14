package operacionesPDA.beanWS.response;

import general.bean.BaseBeanWS;

import java.util.ArrayList;

import cuentas.bean.CuentasAhoBean;

public class SP_PDA_Cuentas_DescargaResponse extends BaseBeanWS{
	private ArrayList<CuentasAhoBean> cuentas = new ArrayList<CuentasAhoBean>();
	
	public void addCuentas(CuentasAhoBean cuenta){  
        this.cuentas.add(cuenta);  
	}

	public ArrayList<CuentasAhoBean> getCuentas() {
		return cuentas;
	}

	public void setCuentas(ArrayList<CuentasAhoBean> cuentas) {
		this.cuentas = cuentas;
	}
	
}