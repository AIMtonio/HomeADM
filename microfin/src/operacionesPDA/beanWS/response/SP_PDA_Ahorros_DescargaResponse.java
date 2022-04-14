package operacionesPDA.beanWS.response;

import general.bean.BaseBeanWS;

import java.util.ArrayList;

import cuentas.bean.CuentasAhoBean;

public class SP_PDA_Ahorros_DescargaResponse extends BaseBeanWS{
	private String Num_Cta;
	private String Num_Socio;
	private String Id_Cuenta;
	private String SaldoTot;
	private String SaldoDisp;
	private String Parametros;

private ArrayList<CuentasAhoBean> ahorros = new ArrayList<CuentasAhoBean>();
	
	public void addCuenta(CuentasAhoBean cuenta){  
        this.ahorros.add(cuenta);  
	}

	public ArrayList<CuentasAhoBean> getAhorros() {
		return ahorros;
	}

	public void setAhorros(ArrayList<CuentasAhoBean> ahorros) {
		this.ahorros = ahorros;
	}
	
}
