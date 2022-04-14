package soporte.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import soporte.bean.EdoCtaClavePDFBean;
import soporte.dao.EdoCtaClavePDFDAO;

public class EdoCtaClavePDFServicio extends BaseServicio {
	EdoCtaClavePDFDAO edoCtaClavePDFDAO;
	
	public static interface Enum_Tran_EdoCtaClavePDFServicio {
		int actualizacionContrasenia = 1;
	}
	
	public static interface Enum_Con_EdoCtaClavePDFServicio {
		int principal 				= 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, EdoCtaClavePDFBean edoCtaClavePDF){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tran_EdoCtaClavePDFServicio.actualizacionContrasenia:
				mensaje = edoCtaClavePDFDAO.actualizaContraseniaClavePDF(tipoTransaccion, edoCtaClavePDF);
				break;
		}
		return mensaje;
	}
	
	
	public EdoCtaClavePDFBean consulta(int tipoConsulta, EdoCtaClavePDFBean edoCtaClavePDFBean) {
		EdoCtaClavePDFBean result = null;
		switch (tipoConsulta) {
	        case  Enum_Con_EdoCtaClavePDFServicio.principal:
	        	result = edoCtaClavePDFDAO.consultaPrincipalClavePDF(edoCtaClavePDFBean, tipoConsulta);
	        	break;
	        default:
	        	result = null;
		}
		
		return result;		
	}

	public List lista(int tipoLista, EdoCtaClavePDFBean edoCtaClavePDFBean){
		List inverLista = null;

		return inverLista;
	}
	
	public EdoCtaClavePDFDAO getEdoCtaClavePDFDAO() {
		return edoCtaClavePDFDAO;
	}

	public void setEdoCtaClavePDFDAO(EdoCtaClavePDFDAO edoCtaClavePDFDAO) {
		this.edoCtaClavePDFDAO = edoCtaClavePDFDAO;
	}
}
