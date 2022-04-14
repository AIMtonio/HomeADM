package cuentas.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.util.List;

import cuentas.bean.MonedasBean;
import cuentas.dao.MonedasDAO;
import cuentas.servicio.MonedasServicio.Enum_Con_Monedas;
import cuentas.servicio.MonedasServicio.Enum_Lis_Monedas;
import cuentas.servicio.MonedasServicio.Enum_Tra_Monedas;

public class MonedasServicio  extends BaseServicio {

	
	//---------- Variables ------------------------------------------------------------------------
	MonedasDAO monedasDAO = null;

	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Monedas {
		int principal = 1;
		int foranea = 2;
		
	}

	public static interface Enum_Lis_Monedas {
		int principal = 1;
		int monedasl = 2;
		int monedas   = 3;
	}

	public static interface Enum_Tra_Monedas {
		int alta = 1;
		int modificacion = 2;

	}
	
	public MonedasServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
	
	public MonedasBean consultaMoneda(int tipoConsulta, String monedaID){
		MonedasBean monedas = null;
		switch(tipoConsulta){
			case Enum_Con_Monedas.principal:
				monedas = monedasDAO.consultaPrincipal(Utileria.convierteEntero(monedaID),Enum_Con_Monedas.principal);
			break;
			case Enum_Con_Monedas.foranea:
				monedas = monedasDAO.consultaForanea(Utileria.convierteEntero(monedaID),Enum_Con_Monedas.foranea);
			break;
		}
		return monedas;
	}
	

	
	public List lista(int tipoLista, MonedasBean monedas){		
		List listaMonedas = null;
		switch (tipoLista) {
			case Enum_Lis_Monedas.monedasl:		
				listaMonedas=  monedasDAO.listaMonedaslist(tipoLista,monedas);				
				break;				
		}		
		return listaMonedas;
	}
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaMonedas = null;
		switch(tipoLista){
			case (Enum_Lis_Monedas.monedas): 
				listaMonedas =  monedasDAO.listaMonedas(tipoLista);
				break;
		}
		return listaMonedas.toArray();		
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	
	public void setMonedasDAO(MonedasDAO monedasDAO) {
		this.monedasDAO = monedasDAO;
	}	


}
