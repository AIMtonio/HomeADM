 
 package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import originacion.bean.DatSocDemogBean;
import originacion.dao.DatSocDemograDAO;
import originacion.servicio.CatlineanegocioServicio.Enum_Lis_LinNegocio;



public class DatSocDemogServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	DatSocDemograDAO datSocDemograDAO = null;		

	
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_DatosSocioE {
		int principal = 1;
		int foranea = 2;
	}	
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_DatosSocioE {
		int principal 		= 1;	
			
	}
	
	public static interface Enum_Lis_GradoEs {
		int principal 		= 1;	
			
	}

	public static interface Enum_Lis_Relaciones {
		int principal 		= 1;	
	}
	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_DatosSocioE {
		int alta = 1;
		int modificacion = 2;
		int grabaListaSocioEcon =3;
	}
	
	
	public DatSocDemogServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	DatSocDemogBean datSocDemogBean){
		 
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_DatosSocioE.alta:		
				mensaje =   datSocDemograDAO.grabaDatosSocioDemo(datSocDemogBean);
				break;
			case Enum_Tra_DatosSocioE.grabaListaSocioEcon:		
				mensaje = null;//grabaDatosSocioEconomicos(clidatsocioeBean,listaDetalleSocioecono);								
				break;
		}
		return mensaje;
	}
	
	//lista para combo de tipo de relaciones
	
	public DatSocDemogBean consulta(int tipoConsulta, DatSocDemogBean datSocDemogBean){		
		DatSocDemogBean datSocDemogResBean = null;
		switch (tipoConsulta) {
			case Enum_Con_DatosSocioE.principal:	
				datSocDemogResBean =  datSocDemograDAO.conGeneralPrincipal(datSocDemogBean, tipoConsulta);
				break;	
		 
		}		
		return datSocDemogResBean;
	}
	
	public List listaRelaciones(int tipoLista, DatSocDemogBean datSocDemogBean){		
		List listaDatosSocioEco = null;
		switch (tipoLista) {
			case Enum_Lis_Relaciones.principal:	
			 	listaDatosSocioEco =  datSocDemograDAO.listaTiposRelaciones(datSocDemogBean, tipoLista);				
				break;	
		 
		}		
		return listaDatosSocioEco;
	}
	
	
	public List listaGradosEsc(int tipoLista, DatSocDemogBean datSocDemogBean){		
		List listaDatosSocioEco = null;
		switch (tipoLista) {
			case Enum_Lis_GradoEs.principal:	
			 	listaDatosSocioEco =  datSocDemograDAO.listaGradoEscolar(datSocDemogBean, tipoLista);				
				break;	
		 
		}		
		return listaDatosSocioEco;
	}
	

	// lista para grid de dependientes economicos
	public List listaDependEconom(int tipoLista, DatSocDemogBean datSocDemogBean){		
		List listaDatosSocioEco = null;
		switch (tipoLista) {
			case Enum_Lis_DatosSocioE.principal:	
			 	listaDatosSocioEco =  datSocDemograDAO.listaDepenEconomGrid(datSocDemogBean, tipoLista);				
				break;	
		 
		}		
		return listaDatosSocioEco;
	}
	
	
	//------------------ Geters y Seters ------------------------------------------------------	
	
	public DatSocDemograDAO getDatSocDemograDAO() {
		return datSocDemograDAO;
	}


	public void setDatSocDemograDAO(DatSocDemograDAO datSocDemograDAO) {
		this.datSocDemograDAO = datSocDemograDAO;
	}
	
}
 
  
 