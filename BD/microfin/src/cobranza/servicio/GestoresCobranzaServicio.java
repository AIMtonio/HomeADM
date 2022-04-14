package cobranza.servicio;


import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import cobranza.bean.GestoresCobranzaBean;
import cobranza.dao.GestoresCobranzaDAO;

public class GestoresCobranzaServicio extends BaseServicio {
	GestoresCobranzaDAO gestoresCobranzaDAO = null;
	
	public static interface Enum_Trans_GestoresCob {
		int alta	 = 1;
		int modifica = 2;
		int elimina	 = 3;
		int activa 	 = 4;
	}
	
	public static interface Enum_Lis_GestoresCob{
		int listaGestores	= 1; 
	}
	
	public static interface Enum_Con_TiposAsignacion{
		int tiposAsignacion 	= 1;
	}
	
	public static interface Enum_Con_GestoresCob{
		int principal= 1;
	}	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, GestoresCobranzaBean gestoresCobranza){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Trans_GestoresCob.alta:		
				mensaje = gestoresCobranzaDAO.altaGestoresCobranza(gestoresCobranza);	 			
				break;				
			case Enum_Trans_GestoresCob.modifica:
				mensaje = gestoresCobranzaDAO.modificacionGestoresCobranza(gestoresCobranza);
				break;
			case Enum_Trans_GestoresCob.elimina:
				mensaje = gestoresCobranzaDAO.actualizaGestoresCobranza(gestoresCobranza,Enum_Trans_GestoresCob.elimina);			
				break;
			case Enum_Trans_GestoresCob.activa:
				mensaje = gestoresCobranzaDAO.actualizaGestoresCobranza(gestoresCobranza,Enum_Trans_GestoresCob.activa);
			
				break;			
		}
		return mensaje;
	}
	
	public List lista(int tipoLista, GestoresCobranzaBean gestores){
		List listaGestores = null;
		
		switch(tipoLista){
			case Enum_Lis_GestoresCob.listaGestores:
				listaGestores = gestoresCobranzaDAO.listaGestores(tipoLista, gestores);
				break;
		}
		
		return listaGestores;
	}

	// listas para comboBox
	public  Object[] listaCombo(int tipoConsulta) {	
		List listaTipoAsig = null;
			
		switch(tipoConsulta){
			case (Enum_Con_TiposAsignacion.tiposAsignacion): 
				listaTipoAsig =  gestoresCobranzaDAO.listaTiposAsignacion(tipoConsulta);
				break;
			
		}
		return listaTipoAsig.toArray();		
	}
	
	public GestoresCobranzaBean consulta(int tipoConsulta, GestoresCobranzaBean gestoresBean){
		GestoresCobranzaBean gestor = null;
		
		switch(tipoConsulta){
			case Enum_Con_GestoresCob.principal:
				gestor = gestoresCobranzaDAO.consultaPrincipal(tipoConsulta,gestoresBean);
				break;
		}
		
		return gestor;
	}
		
	public GestoresCobranzaDAO getGestoresCobranzaDAO() {
		return gestoresCobranzaDAO;
	}

	public void setGestoresCobranzaDAO(GestoresCobranzaDAO gestoresCobranzaDAO) {
		this.gestoresCobranzaDAO = gestoresCobranzaDAO;
	}
}