package soporte.servicio;

import soporte.bean.GeneraConstanciaRetencionBean;
import soporte.dao.GeneraConstanciaRetencionDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class GeneraConstanciaRetencionServicio extends BaseServicio{
	GeneraConstanciaRetencionDAO generaConstanciaRetencionDAO = null; 	
	
  // Consultas Generacion Constancia Retencion
  public static interface Enum_Con_Genera{
		int foranea		= 2;
  }

   public GeneraConstanciaRetencionServicio (){
	   super();
   }
   
   // Transacciones Generacion Constancia Retencion
   public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, GeneraConstanciaRetencionBean generaConstanciaRetencionBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = generaConstanciaRetencionDAO.generacionConstanciaRetencion(generaConstanciaRetencionBean);
		return mensaje;
	}
   
   // Consultas Generacion Constancia Retencion
   public GeneraConstanciaRetencionBean consulta(int tipoConsulta, GeneraConstanciaRetencionBean generaConstanciaRetencionBean){
	   GeneraConstanciaRetencionBean generaConstanciaBean = null;
		switch (tipoConsulta) {
			case Enum_Con_Genera.foranea:
				generaConstanciaBean = generaConstanciaRetencionDAO.consultaParamConstancia(generaConstanciaRetencionBean, tipoConsulta);
			break;
		}
		return generaConstanciaBean;
	}

   /* ============ SETTER's Y GETTER's =============== */
   public GeneraConstanciaRetencionDAO getGeneraConstanciaRetencionDAO() {
		return generaConstanciaRetencionDAO;
	}

	public void setGeneraConstanciaRetencionDAO(
			GeneraConstanciaRetencionDAO generaConstanciaRetencionDAO) {
		this.generaConstanciaRetencionDAO = generaConstanciaRetencionDAO;
	}
   
}