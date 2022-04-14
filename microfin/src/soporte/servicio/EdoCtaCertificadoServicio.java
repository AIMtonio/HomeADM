package soporte.servicio;

import java.io.IOException;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import soporte.bean.EdoCtaCertificadoBean;
import soporte.dao.EdoCtaCertificadoDAO;

public class EdoCtaCertificadoServicio extends BaseServicio{
	EdoCtaCertificadoDAO edoCtaCertificadoDAO=null;
	
	private EdoCtaCertificadoServicio(){
		super();		
	}
	
	public MensajeTransaccionBean grabaTransaccion(EdoCtaCertificadoBean edoCtaCertificadoBean) throws IOException {
		MensajeTransaccionBean mensaje = null;
		mensaje = edoCtaCertificadoDAO.guardar(edoCtaCertificadoBean);		
		return mensaje;
	}

	public EdoCtaCertificadoDAO getEdoCtaCertificadoDAO() {
		return edoCtaCertificadoDAO;
	}
	public void setEdoCtaCertificadoDAO(EdoCtaCertificadoDAO edoCtaCertificadoDAO) {
		this.edoCtaCertificadoDAO = edoCtaCertificadoDAO;
	}
}
