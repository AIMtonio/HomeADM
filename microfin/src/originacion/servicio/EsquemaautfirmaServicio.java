package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import originacion.bean.EsquemaautfirmaBean;
import originacion.dao.EsquemaautfirmaDAO;



public class EsquemaautfirmaServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	EsquemaautfirmaDAO esquemaautfirmaDAO = null;		

	
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_EsqFirmas {
		int principal = 1;
		int foranea = 2;
	}	
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_EsqFirmas {
		int principal 		= 1;
		int solicitudGrupo 	= 2;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_EsqFirmas {
		int alta			= 1;
		int modificacion	= 2;
		int grabarLisEsqFirm = 3;
	}
	
	
	public EsquemaautfirmaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	EsquemaautfirmaBean esquemaautfirmaBean, String detalleFirmasAutor){
		
		ArrayList listaDetalleFirmasAutor = (ArrayList) creaListaDetalle(detalleFirmasAutor);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_EsqFirmas.alta:		
				mensaje = altaFirmasAutorizaSolCre(esquemaautfirmaBean);								
				break;
			case Enum_Tra_EsqFirmas.grabarLisEsqFirm:	
				mensaje = grabaFirmasAutorDetalles(esquemaautfirmaBean,listaDetalleFirmasAutor);								
				break;	
				
		}
		return mensaje;
	}
	


	public MensajeTransaccionBean altaFirmasAutorizaSolCre(EsquemaautfirmaBean esquemaautfirmaBean){
		MensajeTransaccionBean mensaje = null;
			mensaje = esquemaautfirmaDAO.altaFirmasAutorizaSolCre(esquemaautfirmaBean);
		return mensaje;
	}
	
	public MensajeTransaccionBean grabaFirmasAutorDetalles(EsquemaautfirmaBean esquemaautfirmaBean, List listaDetalleFirmasAutor){
		
		MensajeTransaccionBean mensaje = null;
			mensaje = esquemaautfirmaDAO.grabaFirmasAutorDetalles(esquemaautfirmaBean,listaDetalleFirmasAutor);
		return mensaje;
	}

	//listas				
	public List lista(int tipoLista, EsquemaautfirmaBean esquemaautfirmaBean){		
		List listaFirmas= null;
		switch (tipoLista) {
			case Enum_Lis_EsqFirmas.principal:		
				listaFirmas = esquemaautfirmaDAO.listaGridFirmasAutorizadas(esquemaautfirmaBean, tipoLista);				
				break;	
			case Enum_Lis_EsqFirmas.solicitudGrupo:		
				listaFirmas = esquemaautfirmaDAO.listaGridFirmasAutorizadasGrupo(esquemaautfirmaBean, tipoLista);				
				break;	
		}		
		return listaFirmas;
	}
	
	
	
	
	// Crea la lista de detalle de firmas autorizadas
		private List creaListaDetalle(String detalleFirmasAutor){		
			StringTokenizer tokensBean = new StringTokenizer(detalleFirmasAutor, "[");
			String stringCampos;
			String tokensCampos[];
			ArrayList listaDetalleFirmasAutor = new ArrayList();
			EsquemaautfirmaBean esquemaautfirmaBean;
			
			while(tokensBean.hasMoreTokens()){
				esquemaautfirmaBean = new EsquemaautfirmaBean();
			
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			
			esquemaautfirmaBean.setEsquemaID(tokensCampos[0]);
			esquemaautfirmaBean.setNumFirma(tokensCampos[1]);
			esquemaautfirmaBean.setOrganoID(tokensCampos[2]);

			listaDetalleFirmasAutor.add(esquemaautfirmaBean);
			
			}	
			return listaDetalleFirmasAutor;
		}

		
	//------------------ Geters y Seters ------------------------------------------------------	

		public EsquemaautfirmaDAO getEsquemaautfirmaDAO() {
			return esquemaautfirmaDAO;
		}


		public void setEsquemaautfirmaDAO(EsquemaautfirmaDAO esquemaautfirmaDAO) {
			this.esquemaautfirmaDAO = esquemaautfirmaDAO;
		}

	
}

