package sms.servicio;

import java.util.List;


import sms.bean.SMSPlantillaBean;
import sms.dao.SMSPlantillaDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class SMSPlantillaServicio extends BaseServicio{
	
	SMSPlantillaDAO smsPlantillaDAO = null;
	
	public static interface Enum_Tra_Plan {
		int alta		= 1;
		int modifica	= 2;
		int elimina		= 3;
	}
	public static interface Enum_Lis_Plantilla {
		int alfanumerica = 1;
	}
	public static interface Enum_Con_Plantilla {
		int principal = 1;
	}
		
	// Transacciones
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, final SMSPlantillaBean smsPlantillaBean ) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Plan.alta:
				mensaje = altaPlantilla(tipoTransaccion, smsPlantillaBean);
			break;
			case Enum_Tra_Plan.modifica:
				mensaje = modificaPlantilla(tipoTransaccion, smsPlantillaBean);
			break;
			case Enum_Tra_Plan.elimina:
				mensaje = bajaPantilla(smsPlantillaBean);
			break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean altaPlantilla(int tipoTransaccion, SMSPlantillaBean smsPlantillaBean) {
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Tra_Plan.alta:
				mensaje = smsPlantillaDAO.altaPlantilla(tipoTransaccion, smsPlantillaBean);
			break;
		}
		return mensaje;
	}

	public MensajeTransaccionBean modificaPlantilla(int tipoTransaccion,SMSPlantillaBean smsPlantillaBean){
			MensajeTransaccionBean mensaje = null;
			mensaje = smsPlantillaDAO.modificaPlantilla( tipoTransaccion, smsPlantillaBean);
			return mensaje;
		}
	public MensajeTransaccionBean bajaPantilla(SMSPlantillaBean smsPlantillaBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = smsPlantillaDAO.bajaPantilla( smsPlantillaBean);
		return mensaje;
	}

	
	public SMSPlantillaBean consulta(int tipoConsulta, SMSPlantillaBean smsPlantillaBean){
		SMSPlantillaBean plantilla = null;
		switch(tipoConsulta){
			case Enum_Con_Plantilla.principal:
				plantilla = smsPlantillaDAO.consultaPrincipal(smsPlantillaBean, tipoConsulta);
			break;
		}
		return plantilla;
	}


	public List lista(int tipoLista, SMSPlantillaBean smsPlantillaBean){
		List listaPlantilla = null;
		switch (tipoLista) {
		case Enum_Lis_Plantilla.alfanumerica:		
			listaPlantilla=  smsPlantillaDAO.listaPlantilla(smsPlantillaBean, tipoLista);				
			break;
		}	
		return listaPlantilla;
	}


	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaPlantilla = null;
		switch(tipoLista){
			case (Enum_Lis_Plantilla.alfanumerica): 
				listaPlantilla =  smsPlantillaDAO.listaPlantillaCombo(tipoLista);
				break;
		}
		return listaPlantilla.toArray();		
	}
	
	
	
	public SMSPlantillaDAO getSmsPlantillaDAO() {
		return smsPlantillaDAO;
	}
		
	public void setSmsPlantillaDAO(SMSPlantillaDAO smsPlantillaDAO) {
		this.smsPlantillaDAO = smsPlantillaDAO;
	}
	
	
	
}
