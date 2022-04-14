package credito.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import credito.bean.ClasificCreditoBean;
import credito.dao.ClasificCreditoDAO;
public class ClasificCreditoServicio extends BaseServicio {

	
	//---------- Variables ------------------------------------------------------------------------
	ClasificCreditoDAO clasificCreditoDAO = null;

	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_ClasificCredito {
		int principal  = 1;
		int listaCombo  = 2;
		int listaComboCartera = 3;
	}
	public static interface Enum_Tra_ClasificCredito {
		int alta = 1;
		int modificacion = 2;
	}
	public static interface Enum_Con_ClasificCredito {
		int principal   = 1;
		int foranea   = 2;
	}

	public ClasificCreditoServicio ()    {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ClasificCreditoBean clasificCredito){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		/*case Enum_Tra_ClasificCredito.alta:
			mensaje = clasificCreditoDAO.alta(clasificCredito);
			break;
		case Enum_Tra_ClasificCredito.modificacion:
			mensaje = clasificCreditoDAO.modifica(clasificCredito);
			break;*/
		}

		return mensaje;
	}

	public ClasificCreditoBean consulta(int tipoConsulta, ClasificCreditoBean clasificCredito){
		ClasificCreditoBean clasificCreditoBean = null;
		switch(tipoConsulta){
			case Enum_Con_ClasificCredito.principal:
				//productosCreditoBean = clasificCreditoDAO.consultaPrincipal(clasificCredito, Enum_Con_ProductosCredito.foranea);
			break;
			case Enum_Con_ClasificCredito.foranea:
				clasificCreditoBean = clasificCreditoDAO.consultaForanea(clasificCredito, Enum_Con_ClasificCredito.foranea);
			break;
			
		}
		return clasificCreditoBean;
	}
	
	public List lista(int tipoLista, ClasificCreditoBean clasificCredito){
		List clasificCreditoLista = null;

		switch (tipoLista) {
	        case  Enum_Lis_ClasificCredito.principal:
	        	clasificCreditoLista = clasificCreditoDAO.listaClasificCredito(clasificCredito, tipoLista);
	        break;
	        
		}
		return clasificCreditoLista;
	}
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista,ClasificCreditoBean clasificCredito){
		List listaComboCla = null;
		switch(tipoLista){
			case (Enum_Lis_ClasificCredito.listaCombo): 
				listaComboCla =  clasificCreditoDAO.listaCombo(clasificCredito, tipoLista);
				break;
			case (Enum_Lis_ClasificCredito.listaComboCartera): 
				listaComboCla =  clasificCreditoDAO.listaCombo(clasificCredito, tipoLista);
				break;
		}
		return listaComboCla.toArray();		
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	
	public void setClasificCreditoDAO(ClasificCreditoDAO clasificCreditoDAO) {
		this.clasificCreditoDAO = clasificCreditoDAO;
	}	
}
