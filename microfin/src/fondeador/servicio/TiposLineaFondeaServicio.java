package fondeador.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import java.util.List;

import fondeador.bean.TiposLineaFondeaBean;
import fondeador.dao.TiposLineaFondeaDAO;
import credito.servicio.CreditosServicio.Enum_Con_Creditos;

public class TiposLineaFondeaServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	TiposLineaFondeaDAO tiposLineaFondeaDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_TipoLinFon {
		int principal = 1;
		int foranea = 2;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_TipoLinFon {
		int principal = 1;
		int foranea   =2;
		int tipoInst  =3;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_TipoLinFon {
		int alta = 1;
		int modificacion = 2;
	}
	
	public TiposLineaFondeaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TiposLineaFondeaBean tiposLineaFondea){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_TipoLinFon.alta:		
				mensaje = altaTipoLinea(tiposLineaFondea);				
				break;				
			case Enum_Tra_TipoLinFon.modificacion:
				mensaje = modificaTipoLinea(tiposLineaFondea);				
				break;	
		}
		return mensaje;
	}
	
	
	public MensajeTransaccionBean altaTipoLinea(TiposLineaFondeaBean tiposLineaFondeaBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = tiposLineaFondeaDAO.alta(tiposLineaFondeaBean);		
		return mensaje;
	}

	public MensajeTransaccionBean modificaTipoLinea(TiposLineaFondeaBean tiposLineaFondeaBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = tiposLineaFondeaDAO.modifica(tiposLineaFondeaBean);		
		return mensaje;
	}
	
	
	
	
	public TiposLineaFondeaBean consulta(int tipoConsulta,TiposLineaFondeaBean tiposLineaFondeaBean){
		TiposLineaFondeaBean tiposLineaFondea = null;
		switch (tipoConsulta) {
			case Enum_Con_Creditos.principal:		
				tiposLineaFondea = tiposLineaFondeaDAO.consultaPrincipal(tiposLineaFondeaBean, tipoConsulta);				
				break;	
			case Enum_Con_Creditos.foranea:	
				tiposLineaFondea = tiposLineaFondeaDAO.consultaForanea(tiposLineaFondeaBean, tipoConsulta);				
			break;	
		}
				
		return tiposLineaFondea;
	}
	
	public List lista(int tipoLista, TiposLineaFondeaBean tiposLineaFondeaBean){		
		List listaTiposLinea = null;
		switch (tipoLista) {
			case Enum_Lis_TipoLinFon.principal:		
				listaTiposLinea = tiposLineaFondeaDAO.listaPrincipal(tiposLineaFondeaBean, tipoLista);				
				break;
			case Enum_Lis_TipoLinFon.foranea:		
				listaTiposLinea = tiposLineaFondeaDAO.listaForanea(tiposLineaFondeaBean, tipoLista);				
				break;	
				
		}		
		return listaTiposLinea;
	}
	
	
	
	public TiposLineaFondeaBean consultaTiposInstitut(int tipoConsulta, String numeroTipo,String numeroInstitut ){
		TiposLineaFondeaBean tiposLineaFondeaBean = null;
		switch (tipoConsulta) {
			case Enum_Lis_TipoLinFon.tipoInst:	
				tiposLineaFondeaBean = tiposLineaFondeaDAO.consultaTipoInst(Integer.parseInt(numeroTipo),Integer.parseInt(numeroInstitut),tipoConsulta);
				break;
		
		}

		
		return tiposLineaFondeaBean;
	}
	

	//------------------ Geters y Seters ------------------------------------------------------	
	

	public void setTiposLineaFondeaDAO(TiposLineaFondeaDAO tiposLineaFondeaDAO) {
		this.tiposLineaFondeaDAO = tiposLineaFondeaDAO;
	}


	public TiposLineaFondeaDAO getTiposLineaFondeaDAO() {
		return tiposLineaFondeaDAO;
	}

			
}

