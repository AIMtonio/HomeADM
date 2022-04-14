package tesoreria.servicio;

import java.util.List;

import cuentas.servicio.MonedasServicio.Enum_Lis_Monedas;

import tesoreria.bean.ImpuestosBean;
import tesoreria.bean.TipoproveedoresBean;
import tesoreria.dao.ImpuestosDAO;
import tesoreria.servicio.TipoproveedoresServicio.Enum_Con_TipoProvee;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;


public class ImpuestosServicio  extends BaseServicio {

	
	//---------- Variables ------------------------------------------------------------------------
	ImpuestosDAO impuestosDAO = null;

	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_Impuesto{
		int principal   = 1;
		int tasa   		= 2;
		int combo		= 3;
	}
	public static interface Enum_Tra_Impuesto {
		int alta = 1;
		int modificacion = 2;
		int grabarLista = 3;

	}
	
	public static interface Enum_Con_Impuesto {
		int principal = 1;
		int foranea =2;
		int impuesto	= 3;
		int numImpuesto = 4;
	}
	public ImpuestosServicio () {
		super();
		// TODO Auto-generated constructor stub
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ImpuestosBean impuestosBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_Impuesto.alta:
			mensaje = alta(impuestosBean);
			break;
		case Enum_Tra_Impuesto.modificacion:
			mensaje = modifica(impuestosBean);
			break;

		}
		return mensaje;

	}
	
	
	public MensajeTransaccionBean alta(ImpuestosBean impuestosBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = impuestosDAO.alta(impuestosBean);		
		return mensaje;
	}

	public MensajeTransaccionBean modifica(ImpuestosBean impuestosBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = impuestosDAO.modifica(impuestosBean);		
		return mensaje;
	}
	// Consulta de impuestos
	public ImpuestosBean consulta(int tipoConsulta, ImpuestosBean impuestosBean){
		ImpuestosBean impuestos= null;
		switch(tipoConsulta){
			case Enum_Con_Impuesto.principal:
				impuestos = impuestosDAO.consultaPrincipal(impuestosBean, tipoConsulta);
			break;
			case Enum_Con_Impuesto.foranea:
				//impuestos = impuestosDAO.consultaForanea(impuestosBean, tipoConsulta);
			break;
			case Enum_Con_Impuesto.impuesto:
				impuestos = impuestosDAO.consultaImpuestos(impuestosBean, tipoConsulta);
			break;
			case Enum_Con_Impuesto.numImpuesto:
				impuestos = impuestosDAO.consultaNumeroImpuestos(impuestosBean, tipoConsulta);
			break;
		
		}
		return impuestos;
	}
	

	
	public List lista(int tipoLista,ImpuestosBean impuestosBean){		
		List listaImpuestos = null;
		switch (tipoLista) {
		case Enum_Lis_Impuesto.principal:		
			listaImpuestos=  impuestosDAO.listaImpuestos(impuestosBean, Enum_Lis_Impuesto.principal);				
			break;	
		case Enum_Lis_Impuesto.tasa:		
			listaImpuestos=  impuestosDAO.listaImpuestosTasa(impuestosBean, Enum_Lis_Impuesto.tasa);				
			break;
		}		
		return listaImpuestos;
	}
	
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaImpuestos = null;
		switch(tipoLista){
			case (Enum_Lis_Impuesto.combo): 
				listaImpuestos =  impuestosDAO.listaImpuestosCombo(tipoLista);
				break;
		}
		return listaImpuestos.toArray();		
	}

	
	//------------------ Geters y Seters ------------------------------------------------------
	public ImpuestosDAO getImpuestosDAO() {
		return impuestosDAO;
	}


	public void setImpuestosDAO(ImpuestosDAO impuestosDAO) {
		this.impuestosDAO = impuestosDAO;
	}


	
}
