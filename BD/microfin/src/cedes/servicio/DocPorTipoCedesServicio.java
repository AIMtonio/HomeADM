package cedes.servicio;

	import general.bean.MensajeTransaccionBean;
	import general.servicio.BaseServicio;

	import java.util.ArrayList;
	import java.util.List;
	import java.util.StringTokenizer;

	import cedes.bean.DocPorTipoCedesBean;
	import cedes.dao.DocPorTipoCedesDAO;
		
 
		public class DocPorTipoCedesServicio extends BaseServicio {

				//---------- Variables ------------------------------------------------------------------------
			DocPorTipoCedesDAO docPorTipoCedesDAO = null;

				//---------- Tipod de Consulta ----------------------------------------------------------------
			
			 public static interface Enum_Tra_TiposDoctos {
				 int grabarDetDocReq = 3;	
			 	}
			 
				public static interface Enum_Lis_TiposDoctos {
					int grigTipoDoctos = 4;	
				}
			
				public DocPorTipoCedesServicio () {
					super();
				}

				public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	DocPorTipoCedesBean docPorTipoCedesBean, String detalleDoscReq){
					ArrayList listaDetalleDocsReq = (ArrayList) creaListaDetalle(detalleDoscReq);
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				
					switch (tipoTransaccion) {
						case Enum_Tra_TiposDoctos.grabarDetDocReq:		
							mensaje = grabaDocumentosReqDetalles(docPorTipoCedesBean,listaDetalleDocsReq);								
							break;			
					}
					return mensaje;
				}
				

				public MensajeTransaccionBean grabaDocumentosReqDetalles(DocPorTipoCedesBean docPorTipoCedesBean, List listaDetalleDocsReq){
					MensajeTransaccionBean mensaje = null;
						mensaje = docPorTipoCedesDAO.grabaDocumentosReqDetalles(docPorTipoCedesBean,listaDetalleDocsReq);
					return mensaje;
				}
				
				// Crea la lista de detalle de documentos requeridos de cedes
							private List creaListaDetalle(String detalleDoscReq){		
								StringTokenizer tokensBean = new StringTokenizer(detalleDoscReq, "[");
								String stringCampos;
								String tokensCampos[];
								ArrayList listaDetalleDocsRequeridos = new ArrayList();
								DocPorTipoCedesBean docPorTipoCedesBean;
								
								while(tokensBean.hasMoreTokens()){
									docPorTipoCedesBean = new DocPorTipoCedesBean();
								
								stringCampos = tokensBean.nextToken();		
								tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
								docPorTipoCedesBean.setTipoDocCapID(tokensCampos[0]);
								listaDetalleDocsRequeridos.add(docPorTipoCedesBean);
								
								}	
								return listaDetalleDocsRequeridos;
							}
				
						
				public List lista(int tipoLista, DocPorTipoCedesBean docPorTipoCedesBean){		
					List listaDocReq = null;
					switch (tipoLista) {
						case Enum_Lis_TiposDoctos.grigTipoDoctos:		
							listaDocReq = docPorTipoCedesDAO.listaDocumentosExistentes(docPorTipoCedesBean, tipoLista);							
							break;	
					}		
					return listaDocReq;
				}

			

				//------------------ Geters y Seters ------------------------------------------------------	
				
		
				public DocPorTipoCedesDAO getDocPorTipoCedesDAO() {
					return docPorTipoCedesDAO;
				}

				public void setDocPorTipoCedesDAO(
						DocPorTipoCedesDAO docPorTipoCedesDAO) {
					this.docPorTipoCedesDAO = docPorTipoCedesDAO;
				}



			}





