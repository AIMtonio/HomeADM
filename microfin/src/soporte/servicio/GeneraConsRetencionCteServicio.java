package soporte.servicio;

import java.util.List;

import soporte.bean.GeneraConstanciaRetencionBean;
import soporte.dao.GeneraConsRetencionCteDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class GeneraConsRetencionCteServicio extends BaseServicio{
	
	GeneraConsRetencionCteDAO generaConsRetencionCteDAO = null;

   // Consultas Generacion Constancia Retencion
   public static interface Enum_Con_Genera{
		int foranea		= 2;
		int consultaCliente		= 3;
	}

	public static interface Enum_Lis_ClienteConstancia {
		int listaClientes 	= 5;
	}

   public GeneraConsRetencionCteServicio (){
	   super();
   }
   
   // Transacciones Generacion Constancia Retencion
   public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, GeneraConstanciaRetencionBean generaConstanciaRetencionBean){
		MensajeTransaccionBean mensaje = null;
			mensaje = generaConsRetencionCteDAO.generacionConstanciaRetencion(generaConstanciaRetencionBean);
		return mensaje;
	}
   
   // Consultas Generacion Constancia Retencion
   public GeneraConstanciaRetencionBean consulta(int tipoConsulta, GeneraConstanciaRetencionBean generaConstanciaRetencionBean){
	   GeneraConstanciaRetencionBean generaConstanciaBean = null;
		switch (tipoConsulta) {
			case Enum_Con_Genera.foranea:
				generaConstanciaBean = generaConsRetencionCteDAO.consultaParamConstancia(generaConstanciaRetencionBean, tipoConsulta);
			break;
			case Enum_Con_Genera.consultaCliente:
				generaConstanciaBean = generaConsRetencionCteDAO.consultaCliente(generaConstanciaRetencionBean, tipoConsulta);
			break;
		}
		return generaConstanciaBean;
	}

	// Lista de Clientes para generar las Constancias de Retención
	public List lista(int tipoLista, GeneraConstanciaRetencionBean generaConstanciaRetencionBean){		
		List listaClientes = null;
		switch (tipoLista) {
			case Enum_Lis_ClienteConstancia.listaClientes:		
				listaClientes = generaConsRetencionCteDAO.listaClientes(generaConstanciaRetencionBean, tipoLista);				
				break;
		}
		return listaClientes;
	}

   /* ============ SETTER's Y GETTER's =============== */
   public GeneraConsRetencionCteDAO getGeneraConsRetencionCteDAO() {
		return generaConsRetencionCteDAO;
	}

	public void setGeneraConsRetencionCteDAO(
			GeneraConsRetencionCteDAO generaConsRetencionCteDAO) {
		this.generaConsRetencionCteDAO = generaConsRetencionCteDAO;
	}
 
}
