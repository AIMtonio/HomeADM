package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
 
import java.util.StringTokenizer;

import org.pentaho.reporting.engine.classic.core.function.sys.GetDataRowValueExpression;

import originacion.bean.ClidatsocioeBean;
import originacion.bean.GarantiaBean;
import originacion.dao.ClidatsocioeDAO;
import originacion.servicio.CatlineanegocioServicio.Enum_Lis_LinNegocio;
import originacion.servicio.GarantiaServicio.Enum_Con_garantia;
import originacion.servicio.GarantiaServicio.Enum_TipoLis_AsignaGarantias;



public class ClidatsocioeServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	ClidatsocioeDAO clidatsocioeDAO = null;		

	
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_DatosSocioE {
		int principal = 1;
		int foranea = 2;
		int datoSocioE = 3;
	}	
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_DatosSocioE {
		int principal 		= 1;	
		int gridDatosSocioe	= 2;	
		int inforDatosSocioe= 3;	
		int gastosPasivos	=4;
		int llenaComboGasto =5;
	
		
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_DatosSocioE {
		int alta = 1;
		int modificacion = 2;
		int grabaListaSocioEcon =3;
	}
	
	
	
	public ClidatsocioeServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	ClidatsocioeBean clidatsocioeBean ){
		ArrayList listaDetalleSocioecono = (ArrayList) creaListaDetalle(clidatsocioeBean);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_DatosSocioE.alta:		
				mensaje = altaDatosSocioEconomicos(clidatsocioeBean);								
				break;
			case Enum_Tra_DatosSocioE.grabaListaSocioEcon:		
				mensaje = grabaDatosSocioEconomicos(clidatsocioeBean,listaDetalleSocioecono);								
				break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean altaDatosSocioEconomicos(ClidatsocioeBean clidatsocioeBean){
		MensajeTransaccionBean mensaje = null;
		final long q=1;
			mensaje = clidatsocioeDAO.altaDatosSocioeconomicos(clidatsocioeBean,q);
		return mensaje;
	}
	
	public MensajeTransaccionBean grabaDatosSocioEconomicos(ClidatsocioeBean clidatsocioeBean, List listaDetalleSocioecono){
		MensajeTransaccionBean mensaje = null;
			mensaje = clidatsocioeDAO.grabaDatosSocioecoDetalles(clidatsocioeBean,listaDetalleSocioecono);
		return mensaje;
	}
	
				
	public ClidatsocioeBean consulta(int tipoConsulta, ClidatsocioeBean clidatsocioeBean){
		ClidatsocioeBean clidatsocioe = null;
		switch (tipoConsulta) {
			case Enum_Con_DatosSocioE.principal:	
				clidatsocioe = clidatsocioeDAO.consultaPrincipal(clidatsocioeBean,tipoConsulta);
				break;	
			case Enum_Con_DatosSocioE.foranea:	
				clidatsocioe = clidatsocioeDAO.consultaForanea(clidatsocioeBean,tipoConsulta);
				break;	
			case Enum_Con_DatosSocioE.datoSocioE:	
				clidatsocioe = clidatsocioeDAO.consultaDatoSocioEconomico(clidatsocioeBean,tipoConsulta);
				break;									
		}				
		return clidatsocioe;
	}


	public List lista(int tipoLista, ClidatsocioeBean clidatsocioeBean){		
		List listaDatosSocioEco = null;
		switch (tipoLista) {
			case Enum_Lis_DatosSocioE.principal:		
			listaDatosSocioEco = clidatsocioeDAO.listaGastoAlimenticio(clidatsocioeBean, tipoLista);				
				break;	
			case Enum_Lis_DatosSocioE.gridDatosSocioe:		
				listaDatosSocioEco = clidatsocioeDAO.listaDatosSocioeconomicosPantalla(clidatsocioeBean, tipoLista);				
				break;	
			case Enum_Lis_DatosSocioE.gastosPasivos:		
				listaDatosSocioEco = clidatsocioeDAO.listaGastosPasivos(clidatsocioeBean, tipoLista);
				break;	
				
			
		}			
		return listaDatosSocioEco;
	}
	
	
	
	
		
	// listas para comboBox
	public  List listaCombo(ClidatsocioeBean clidatsocioeBean,int tipoLista) {		
		List listaDatosSocioEco = null;		
		switch(tipoLista){
			case Enum_Lis_DatosSocioE.inforDatosSocioe: 
				listaDatosSocioEco =  clidatsocioeDAO.listaDatosSocioeconomicosporCteProspec(clidatsocioeBean, tipoLista);	
				break;
				
			case Enum_Lis_DatosSocioE.llenaComboGasto: 
				listaDatosSocioEco =  clidatsocioeDAO.ComboGastos(clidatsocioeBean, tipoLista);	
				break;
			
			
		}
		
		return listaDatosSocioEco;		
	}
	
	
	// Crea la lista de detalle de datos socioeconomicos
		private List creaListaDetalle(ClidatsocioeBean clidatsocioeBean){	
			
			List<String>  socioEIDL = clidatsocioeBean.getLSocioEID();
			List<String>  catSocioEIDL = clidatsocioeBean.getLcatSocioEID();
			List<String>  montoL = clidatsocioeBean.getLmonto();
			
			ArrayList listaDetalleSocioeconomicos = new ArrayList();
			ClidatsocioeBean clidatsocioeIterBean = null;
			
			int tamanio = 0;
			if(catSocioEIDL!=null){
				tamanio=catSocioEIDL.size();
			}

			for(int i=0; i<tamanio; i++){
				clidatsocioeIterBean = new ClidatsocioeBean();
				clidatsocioeIterBean.setSocioEID(socioEIDL.get(i) );
				clidatsocioeIterBean.setCatSocioEID(catSocioEIDL.get(i) );
				clidatsocioeIterBean.setMonto(montoL.get(i));
				clidatsocioeIterBean.setClienteID(clidatsocioeBean.getClienteID());
				clidatsocioeIterBean.setProspectoID(clidatsocioeBean.getProspectoID());
				clidatsocioeIterBean.setLinNegID(clidatsocioeBean.getLinNegID());
				clidatsocioeIterBean.setFechaRegistro(clidatsocioeBean.getFechaRegistro());
				clidatsocioeIterBean.setSolicitudCreditoID(clidatsocioeBean.getSolicitudCreditoID());
				
			
			
			listaDetalleSocioeconomicos.add(clidatsocioeIterBean);
			
			}	
			return listaDetalleSocioeconomicos;
		}


	//------------------ Geters y Seters ------------------------------------------------------	
	
	public ClidatsocioeDAO getClidatsocioeDAO() {
		return clidatsocioeDAO;
	}


	public void setClidatsocioeDAO(ClidatsocioeDAO clidatsocioeDAO) {
		this.clidatsocioeDAO = clidatsocioeDAO;
	}
	
}
