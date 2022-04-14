package soporte.servicio;

import soporte.bean.GeneraEdoCtaBean;
import soporte.dao.GeneraEdoCtaDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class GeneraEdoCtaServicio extends BaseServicio{

	GeneraEdoCtaDAO generaEdoCtaDAO = null;
	
	public static interface Enum_Con_Genera{
		int principal		= 1;
		int foranea			= 2;
		int rango 			= 3;	
		int edosGenerados	= 4;
		
	}
	
	public static interface Enum_Tran_Genera{
		int principal = 1;
		int crediclub = 2;
		int crediclubGenCadenas = 3;
		int crediclubTrimbrado = 4;
	}
	
	public GeneraEdoCtaServicio(){
		super();
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, GeneraEdoCtaBean generaEdoCtaBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tran_Genera.principal:
			mensaje = generaEdoCtaDAO.generaracionEdoCtaProveedor(generaEdoCtaBean);
			break;
		case Enum_Tran_Genera.crediclub:
			mensaje = generaEdoCtaDAO.generacionEdoCtaCrediclub(generaEdoCtaBean);
			break;
		}
		return mensaje;
	}
		
	public GeneraEdoCtaBean consulta(int tipoConsulta, GeneraEdoCtaBean generaEdoCtaBean){
		GeneraEdoCtaBean generaEdoBean = null;
		switch (tipoConsulta) {
			case Enum_Con_Genera.foranea:
				generaEdoBean = generaEdoCtaDAO.consultaParamEdoCta(generaEdoCtaBean, tipoConsulta);
				break;
			case Enum_Con_Genera.rango:
				generaEdoBean = generaEdoCtaDAO.consultaRangoClientes(generaEdoCtaBean, tipoConsulta);
				break;
			case Enum_Con_Genera.edosGenerados:
				generaEdoBean = generaEdoCtaDAO.validarEdosCtaEjecutados(generaEdoCtaBean);
				break;
		}
		return generaEdoBean;
	}
	public GeneraEdoCtaDAO getGeneraEdoCtaDAO() {
		return generaEdoCtaDAO;
	}

	public void setGeneraEdoCtaDAO(GeneraEdoCtaDAO generaEdoCtaDAO) {
		this.generaEdoCtaDAO = generaEdoCtaDAO;
	}
}
