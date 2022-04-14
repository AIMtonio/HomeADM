package soporte.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import soporte.bean.EdoCtaPerEjecutadoBean;
import soporte.dao.GeneraInfoEdoCtaDAO;

public class GeneraInfoEdoCtaServicio extends BaseServicio {
	
	//Instancia al DAO
	GeneraInfoEdoCtaDAO generaInfoEdoCtaDAO = null;
	
	public static interface Enum_Tra_GeneraInfoEdoCta {
		int proceso = 1;
	}
	
	//Metodo de graba transaccion que se encarga de ejecutar un metodo en especifico de el DAO
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	EdoCtaPerEjecutadoBean edoCtaPerEjecutadoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		switch (tipoTransaccion) {
			case Enum_Tra_GeneraInfoEdoCta.proceso:
				mensaje = generaInfoEdoCtaDAO.procesar(edoCtaPerEjecutadoBean);
				break;
		}
		return mensaje;
	}
	
	//----------------- Metodos Getter's and Setter's de nuestro DAO ------------------//
	public GeneraInfoEdoCtaDAO getGeneraInfoEdoCtaDAO() {
		return generaInfoEdoCtaDAO;
	}

	public void setGeneraInfoEdoCtaDAO(GeneraInfoEdoCtaDAO generaInfoEdoCtaDAO) {
		this.generaInfoEdoCtaDAO = generaInfoEdoCtaDAO;
	}
}
