package sms.servicio;

import java.util.List;

import sms.bean.SMSCondiciCargaBean;
import sms.dao.SMSCondiciCargaDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class SMSCondiciCargaServicio extends BaseServicio{
	
	SMSCondiciCargaDAO smsCondiciCargaDAO = null;
	
	public static interface Enum_Tra_Cond{
		int alta = 2;
	}
	public static interface Enum_Lis_Cond{
		int simulaFechas = 1;
	}
	public static interface Enum_Con_Cond{
		int principal = 1;
	}
	
	public SMSCondiciCargaServicio(){
		super();
	}
	
	//Transacciones
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, final SMSCondiciCargaBean smsCondiciCargaBean, final String numTransaccion) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Cond.alta:
				mensaje = smsCondiciCargaDAO.altaCondiciones(smsCondiciCargaBean, numTransaccion);
			break;
		}
		return mensaje;
	}
	
	//Obtiene la lista de fechas probables de envio de SMS
	public List lista(int tipoLista, SMSCondiciCargaBean smsCondiciCargaBean){
		List listaFechas = null;
		switch (tipoLista) {
			case Enum_Lis_Cond.simulaFechas:		
				listaFechas = smsCondiciCargaDAO.simulaFechas(smsCondiciCargaBean, tipoLista);				
				break;				
		}		
		return listaFechas;
	}
	
	//-------Getters y Setters -----------------------------
	public SMSCondiciCargaDAO getSmsCondiciCargaDAO() {
		return smsCondiciCargaDAO;
	}

	public void setSmsCondiciCargaDAO(SMSCondiciCargaDAO smsCondiciCargaDAO) {
		this.smsCondiciCargaDAO = smsCondiciCargaDAO;
	}
	
}
