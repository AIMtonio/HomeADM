package fondeador.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import cuentas.servicio.TiposCuentaServicio.Enum_Lis_TiposCuenta;

import fondeador.bean.InstitutFondeoBean;
import fondeador.dao.InstitutFondeoDAO;

public class InstitutFondeoServicio extends BaseServicio {

	//---------- Variabless ------------------------------------------------------------------------
	InstitutFondeoDAO institutFondeoDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Fondeo {
		int principal = 1;
		int foranea = 2;
		int fondeador = 3;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Fondeo {
		int principal = 1;
		int foranea = 2;
		int validas = 3;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_Fondeo {
		int alta = 1;
		int modificacion = 2;
	}
	public static interface Enum_Lis_TiposInstitucion {
		int combo = 1;
		int combo1=2;
	}
	
	
	
	public InstitutFondeoServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, InstitutFondeoBean institutFondeoBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Fondeo.alta:		
				mensaje = institutFondeoDAO.alta(institutFondeoBean);				
				break;				
			case Enum_Tra_Fondeo.modificacion:
				mensaje = institutFondeoDAO.modifica(institutFondeoBean);				
				break;
			
		}
		return mensaje;
	}
	
	public InstitutFondeoBean consulta(int tipoConsulta, InstitutFondeoBean institutFondeoBean){
		InstitutFondeoBean instFondeo = null;
		switch (tipoConsulta) {
			case Enum_Con_Fondeo.principal:		
				instFondeo = institutFondeoDAO.consultaPrincipal(institutFondeoBean, tipoConsulta);				
				break;	
			case Enum_Con_Fondeo.foranea:		
				instFondeo = institutFondeoDAO.consultaForanea(institutFondeoBean, tipoConsulta);				
			break;	
		}				
		return instFondeo;
	}
	
	public List lista(int tipoLista, InstitutFondeoBean institutFondeoBean){		
		List listaInstitut = null;
		switch (tipoLista) {
			case Enum_Lis_Fondeo.principal:		
				listaInstitut = institutFondeoDAO.listaPrincipal(institutFondeoBean, tipoLista);
				break;
			case Enum_Lis_Fondeo.validas:
				listaInstitut = institutFondeoDAO.listaPrincipal(institutFondeoBean, tipoLista);				
				break;
		}		
		return listaInstitut;
	}

	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaIsntitucion = null;
		switch(tipoLista){
			case (Enum_Lis_TiposInstitucion.combo): 
				listaIsntitucion =  institutFondeoDAO.listaTiposIsntitucion(tipoLista);
				break;			
			case (Enum_Lis_TiposInstitucion.combo1): 
				listaIsntitucion =  institutFondeoDAO.listaInstitucion(tipoLista);
				break;			
		}
		return listaIsntitucion.toArray();		
	}
	
	// Lista fondeador para la definicion de seguimiento
	public  Object[] listaConsulta(int tipoConsulta, InstitutFondeoBean institutFondeoBean){
		List listInsitucion = null;
		switch(tipoConsulta){
			case Enum_Con_Fondeo.fondeador:
				listInsitucion = institutFondeoDAO.listaFondeador(institutFondeoBean, tipoConsulta);
		}
		return listInsitucion.toArray();
	}

	//------------------ Geters y Seters ------------------------------------------------------	
	public void setInstitutFondeoDAO(InstitutFondeoDAO institutFondeoDAO) {
		this.institutFondeoDAO = institutFondeoDAO;
	}


	public InstitutFondeoDAO getInstitutFondeoDAO() {
		return institutFondeoDAO;
	}	
		
}


