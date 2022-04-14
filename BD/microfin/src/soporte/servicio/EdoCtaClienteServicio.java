package soporte.servicio;

import soporte.bean.GeneraEdoCtaBean;
import soporte.dao.EdoCtaClienteDAO;
import soporte.servicio.GeneraEdoCtaServicio.Enum_Tran_Genera;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class EdoCtaClienteServicio extends BaseServicio{

	EdoCtaClienteDAO edoCtaClienteDAO = null;
	
	public static interface Enum_Con_Genera{
		int principal		= 1;
		int foranea			= 2;
		int rango 			= 3;	
		int edosGenerados	= 4;
	}
	

	public static interface Enum_Tran_Genera{
		int principal = 1;
		int crediclub = 2;	
	}
	
	public EdoCtaClienteServicio(){
		super();
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, GeneraEdoCtaBean generaEdoCtaBean){
		loggerSAFI.info("EdoCtaClienteServicio.tipoTransaccion:" + tipoTransaccion);
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tran_Genera.principal:
			mensaje = edoCtaClienteDAO.generaracionEdoCtaProveedor(generaEdoCtaBean);
			break;
		case Enum_Tran_Genera.crediclub:
			mensaje = edoCtaClienteDAO.generacionEdoCtaCrediclub(generaEdoCtaBean);
			break;
		}
		return mensaje;
	}
		
	public GeneraEdoCtaBean consulta(int tipoConsulta, GeneraEdoCtaBean generaEdoCtaBean){
		GeneraEdoCtaBean generaEdoBean = null;
		switch (tipoConsulta) {
			case Enum_Con_Genera.foranea:
				generaEdoBean = edoCtaClienteDAO.consultaParamEdoCta(generaEdoCtaBean, tipoConsulta);
				break;
			case Enum_Con_Genera.rango:
				generaEdoBean = edoCtaClienteDAO.consultaRangoClientes(generaEdoCtaBean, tipoConsulta);
				break;
			case Enum_Con_Genera.edosGenerados:
				generaEdoBean = edoCtaClienteDAO.validarEdosCtaEjecutados(generaEdoCtaBean);
				break;
		}
		return generaEdoBean;
	}
	
	public EdoCtaClienteDAO getEdoCtaClienteDAO() {
		return edoCtaClienteDAO;
	}

	public void setEdoCtaClienteDAO(EdoCtaClienteDAO generaEdoCtaDAO) {
		this.edoCtaClienteDAO = generaEdoCtaDAO;
	}
}