package cuentas.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import credito.bean.CalPorRangoBean;
import credito.servicio.CalPorRangoServicio.Enum_Lis_CalifRango;

import cuentas.bean.ParentescosBean;
import cuentas.dao.ParentescosDAO;

public class ParentescosServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	ParentescosDAO parentescosDAO = null;

	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Parentescos {
		int principal = 1;
		int foranea = 2;
		int relaciones= 3;
				
	}

	public static interface Enum_Lis_Parentescos {
		int principal = 1;
		int foranea  = 2;
		int relaciones = 3;
	}

	public static interface Enum_Tra_Parentescos {
		int alta = 1;
		int modificacion = 2;
		int actualiza = 3;
	}
	
	public ParentescosServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParentescosBean parentescos){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Parentescos.alta:		
				//mensaje = altaRelacionCliente(parentescos);				
				break;				
			case Enum_Tra_Parentescos.modificacion:
				//mensaje = modificaRelacionCliente(parentescos);				
				break;
			case Enum_Tra_Parentescos.actualiza:
				//mensaje = actualizaRelacionCliente(parentescos);				
				break;
		
		}
		return mensaje;
	}

	////////////////Corrreegiirrrrrrrrrrrrrrrrrrr
	public ParentescosBean consultaParentesco(int tipoConsulta, ParentescosBean parentescosBean ){
		ParentescosBean parentescos = null;
		switch(tipoConsulta){
			case Enum_Con_Parentescos.principal:
				parentescos = parentescosDAO.consultaPrincipal(parentescosBean, Enum_Con_Parentescos.principal);
			break;
			case Enum_Con_Parentescos.relaciones:
				parentescos = parentescosDAO.consultaParentescos(parentescosBean, Enum_Con_Parentescos.relaciones);
			break;
		}
		return parentescos;
	}
	

	
	public List lista(int tipoLista, ParentescosBean parentescos){		
		List listaParentescos = null;
		switch (tipoLista) {
			case Enum_Lis_Parentescos.principal:		
				listaParentescos=  parentescosDAO.listaParentescos(parentescos,tipoLista);				
				break;
			case Enum_Lis_Parentescos.relaciones:		
				listaParentescos=  parentescosDAO.listaParentescos(parentescos,tipoLista);				
				break;
		}		
		return listaParentescos;
	}
	
	
	//------------------ Geters y Seters ------------------------------------------------------	
	public void setParentescosDAO(ParentescosDAO parentescosDAO) {
		this.parentescosDAO = parentescosDAO;
	}	


}
