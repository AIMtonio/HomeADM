package credito.servicio;

import java.util.List;

import originacion.bean.CreditosPlazosBean;
import originacion.servicio.CreditosPlazosServicio.Enum_Lis_Calendario;

import credito.bean.ClasificCreditoBean;
import credito.bean.FormTipoCalIntBean;
import credito.dao.FormTipoCalIntDAO;
import credito.servicio.FormTipoCalIntServicio.Enum_Lis_FormTipoCalInt;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class FormTipoCalIntServicio extends BaseServicio{
	//---------- Variables ------------------------------------------------------------------------
	FormTipoCalIntDAO formTipoCalIntDAO = null;

	//---------- Tipos de transacciones---------------------------------------------------------------
	public static interface Enum_Con_FormTipoCalInt {
		int principal   = 1;
	}
	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_FormTipoCalInt {
		int principal   = 2;
		int combo		= 1;
	}
	
	

	public FormTipoCalIntBean consulta(int tipoConsulta, FormTipoCalIntBean formTipoCalInt){
		FormTipoCalIntBean formTipoCalIntBean = null;
		switch(tipoConsulta){
			case Enum_Con_FormTipoCalInt.principal:
				formTipoCalIntBean = formTipoCalIntDAO.consultaPrincipal(formTipoCalInt, Enum_Con_FormTipoCalInt.principal);
			break;
			
		}
		return formTipoCalIntBean;
	}

	public List lista(int tipoLista, FormTipoCalIntBean formTipoCalInt){
		List formTipoCalIntLista = null;

		switch (tipoLista) {
	        case  Enum_Lis_FormTipoCalInt.principal:
	        	formTipoCalIntLista = formTipoCalIntDAO.listaFormCalInt(formTipoCalInt, tipoLista);
	        break;
	        
		}
		return formTipoCalIntLista;
	}
	
	//Lista de Formulas para Combo Box	
	public Object[] listaCombo(int tipoLista, FormTipoCalIntBean formTipoCalInt){
				List listaFormulas = null;
				switch (tipoLista) {
					case Enum_Lis_FormTipoCalInt.combo:		
						listaFormulas=  formTipoCalIntDAO.listaCombo(formTipoCalInt,tipoLista);				
						break;
					case Enum_Lis_FormTipoCalInt.principal:
						listaFormulas=  formTipoCalIntDAO.listaCombo(formTipoCalInt,tipoLista);	
						break;
		}				
		return listaFormulas.toArray();
	}
	
	
	//------------------ Geters y Seters --------------------------------------------
	public void setFormTipoCalIntDAO(FormTipoCalIntDAO formTipoCalIntDAO) {
		this.formTipoCalIntDAO = formTipoCalIntDAO;
	}
	

}
