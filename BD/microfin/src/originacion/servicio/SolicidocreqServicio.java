package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import originacion.bean.SolicidocreqBean;
import originacion.dao.SolicidocreqDAO;


public class SolicidocreqServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	SolicidocreqDAO solicidocreqDAO = null;		

	
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_SolDocReq {
		int principal = 1;
		int foranea = 2;
	}	
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_SolDocReq {
		int principal 		= 1;
		int gridDocReq		= 2;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_SolDocReq {
		int alta			= 1;
		int modificacion	= 2;
		int grabarDetDocReq = 3;
	}
	
	
	public SolicidocreqServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	SolicidocreqBean solicidocreqBean, String detalleDoscReq){
		ArrayList listaDetalleDocsReq = (ArrayList) creaListaDetalle(detalleDoscReq);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_SolDocReq.alta:		
				mensaje = altaDocumentosRequeridos(solicidocreqBean);								
				break;
			case Enum_Tra_SolDocReq.grabarDetDocReq:		
				mensaje = grabaDocumentosReqDetalles(solicidocreqBean,listaDetalleDocsReq);								
				break;	
				
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean altaDocumentosRequeridos(SolicidocreqBean solicidocreqBean){
		MensajeTransaccionBean mensaje = null;
			mensaje = solicidocreqDAO.altaDocumentosRequeridos(solicidocreqBean);
		return mensaje;
	}
	
	public MensajeTransaccionBean grabaDocumentosReqDetalles(SolicidocreqBean solicidocreqBean, List listaDetalleDocsReq){
		MensajeTransaccionBean mensaje = null;
			mensaje = solicidocreqDAO.grabaDocumentosReqDetalles(solicidocreqBean,listaDetalleDocsReq);
		return mensaje;
	}
	

	public List lista(int tipoLista, SolicidocreqBean solicidocreqBean){		
		List listaDocReq = null;
		switch (tipoLista) {
			case Enum_Lis_SolDocReq.principal:		
			//	listaDocReq = solicidocreqDAO.listaDatosSocioeconomicosporCteProspec(clidatsocioeBean, tipoLista);				
				break;	
			case Enum_Lis_SolDocReq.gridDocReq:		
				listaDocReq = solicidocreqDAO.listaDocumentosRequeridosProducto(solicidocreqBean, tipoLista);				
				break;	
		}		
		return listaDocReq;
	}
	

	
	// Crea la lista de detalle de documentos requeridos
		private List creaListaDetalle(String detalleDoscReq){		
			StringTokenizer tokensBean = new StringTokenizer(detalleDoscReq, "[");
			String stringCampos;
			String tokensCampos[];
			ArrayList listaDetalleDocsRequeridos = new ArrayList();
			SolicidocreqBean solicidocreqBean;
			
			while(tokensBean.hasMoreTokens()){
				solicidocreqBean = new SolicidocreqBean();
			
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");

			solicidocreqBean.setClasificaTipDocID(tokensCampos[0]);
			
			listaDetalleDocsRequeridos.add(solicidocreqBean);
			
			}	
			return listaDetalleDocsRequeridos;
		}




	//------------------ Geters y Seters ------------------------------------------------------	
	
		public SolicidocreqDAO getSolicidocreqDAO() {
			return solicidocreqDAO;
		}

		public void setSolicidocreqDAO(SolicidocreqDAO solicidocreqDAO) {
			this.solicidocreqDAO = solicidocreqDAO;
		}
	
}

