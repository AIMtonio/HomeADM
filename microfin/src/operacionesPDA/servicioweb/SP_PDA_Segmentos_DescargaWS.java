package operacionesPDA.servicioweb;
import java.util.Iterator;
import java.util.List;

import operacionesPDA.beanWS.request.SP_PDA_Segmentos_DescargaRequest;
import operacionesPDA.beanWS.response.SP_PDA_Segmentos_DescargaResponse;
import operacionesPDA.servicio.SP_PDA_Segmentos_Descarga3ReyesServicio;

import org.springframework.ws.server.endpoint.AbstractDomPayloadEndpoint;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

import soporte.PropiedadesSAFIBean;
import soporte.bean.ParametrosCajaBean;
import soporte.servicio.ParametrosCajaServicio;
import cliente.bean.GruposNosolidariosBean;
import cliente.bean.PromotoresBean;
import cliente.servicio.GruposNosolidariosServicio;

public class SP_PDA_Segmentos_DescargaWS  extends AbstractDomPayloadEndpoint {
	
	private GruposNosolidariosServicio gruposNosolidariosServicio;
	
	SP_PDA_Segmentos_Descarga3ReyesServicio sp_PDA_Segmentos_Descarga3ReyesServicio= null;
	ParametrosCajaServicio parametrosCajaServicio = null;
	String varYanga = "YANGA";
	String var3Reyes = "3 REYES";
	
	public static final String NAMESPACE = "http://safisrv/ws/schemas";
	  

    protected Element invokeInternal(Element domRequest, Document document) throws Exception {      
    	
    	SP_PDA_Segmentos_DescargaRequest  request     = this.xmlToInfoRequest(domRequest);   
    	String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
    	sp_PDA_Segmentos_Descarga3ReyesServicio.getSp_PDA_Segmentos_Descarga3ReyesDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
    	gruposNosolidariosServicio.getGruposNosolidariosDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);

     	SP_PDA_Segmentos_DescargaResponse response    = new SP_PDA_Segmentos_DescargaResponse();   	
          
     	Element  domResponse = null;
     	ParametrosCajaBean parametrosCajaBean = new ParametrosCajaBean();

		parametrosCajaBean.setEmpresaID("1");
		parametrosCajaBean = parametrosCajaServicio.consulta(ParametrosCajaServicio.Enum_Con_ParametrosCaja.paramVersionWS, parametrosCajaBean);
		
		if(parametrosCajaBean.getVersionWS().equals(varYanga)){
			response  = (SP_PDA_Segmentos_DescargaResponse)  gruposNosolidariosServicio.listaGruposWS(request);
	     	domResponse = this.responseToXml(response, document);   

		}
		else{

		if(parametrosCajaBean.getVersionWS().equals(var3Reyes)){
			response  = (SP_PDA_Segmentos_DescargaResponse) sp_PDA_Segmentos_Descarga3ReyesServicio.listaPromotoresWS(request);
	     	domResponse = this.responseToXmlPromotores(response, document);   

			}
		}
	 	   	        
        return domResponse;  
    }  

    /* convierte a xml el request */
    private SP_PDA_Segmentos_DescargaRequest xmlToInfoRequest(Element request){         
   	
    	String Id_Sucursal ;
    	SP_PDA_Segmentos_DescargaRequest xmlInfoRequest  = new SP_PDA_Segmentos_DescargaRequest();  
    	try{
            Element elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "Id_Sucursal").item(0);
            
            Id_Sucursal = elementoNombre.getTextContent();
            xmlInfoRequest.setId_Sucursal(Id_Sucursal);
    	}
          catch(Exception e){
        	  e.printStackTrace();
          }
         
        return xmlInfoRequest; 
    }
  
    /* convierte a xml el response */
    private Element responseToXml(SP_PDA_Segmentos_DescargaResponse response, Document document){  
        Element     root    = document.createElementNS("http://safisrv/ws/schemas", "DescargarSegmentosResponse");  
        List<GruposNosolidariosBean> segmentos  = response.getSegmentos();  
          
        if (segmentos != null){  
            Iterator<GruposNosolidariosBean> iteSegmentos = null;  
            GruposNosolidariosBean segmento     = null;  
            Element    domSegmento  = null;  
              
            iteSegmentos = segmentos.iterator();  
            while (iteSegmentos.hasNext()){  
            	segmento    = iteSegmentos.next();  
            	domSegmento = this.mapeoXml(document, segmento);  
                root.appendChild(domSegmento);  
            }  
        }  
          
        return root;  
    }
    
    /* Crea la estructura del nodo en el xml para grupos no solidarios*/
    private Element mapeoXml(Document document, GruposNosolidariosBean segmentoBean){  
        Element domNodo = document.createElement("Segmento");  
          
        this.agregaHijo(document, domNodo, "Id_Segmento", segmentoBean.getGrupoID());  
        this.agregaHijo(document, domNodo, "DescSegmento",  segmentoBean.getNombreGrupo());   
          
        return domNodo;  
    }
    

    
    /*Medtodos para descargar promotores por segmento*/

    /* convierte a xml el response */
    private Element responseToXmlPromotores(SP_PDA_Segmentos_DescargaResponse response, Document document){  
        Element     root    = document.createElementNS("http://safisrv/ws/schemas", "DescargarSegmentosResponse");  
        List<PromotoresBean> promotores  = response.getPromotores();  
          
        if (promotores != null){  
            Iterator<PromotoresBean> itePromotores = null;  
            PromotoresBean promotor   = null;  
            Element    domSegmento  = null;  
              
            itePromotores = promotores.iterator();  
            while (itePromotores.hasNext()){  
            	promotor   = itePromotores.next();  
            	domSegmento = this.mapeoXmlPromotores(document, promotor);  
                root.appendChild(domSegmento);  
            }  
        }  
          
        return root;  
    }
    
    /* Crea la estructura del nodo en el xml para Promotores*/
    private Element mapeoXmlPromotores(Document document, PromotoresBean promotoresBean){  
        Element domNodo = document.createElement("Segmento");  
          
        this.agregaHijo(document, domNodo, "Id_Segmento", promotoresBean.getPromotorID());  
        this.agregaHijo(document, domNodo, "DescSegmento",  promotoresBean.getNombrePromotor());   
        return domNodo;  
    }
    
    
    /* agrega nodo al xml */
    private void agregaHijo(Document document, Element padre, String tag, String valor){  
        Element domNombre = document.createElement(tag);  
        Text    domValor  = document.createTextNode(valor);  
          
        domNombre.appendChild(domValor);  
        padre.appendChild(domNombre);  
    }
    

	public GruposNosolidariosServicio getGruposNosolidariosServicio() {
		return gruposNosolidariosServicio;
	}

	public void setGruposNosolidariosServicio(
			GruposNosolidariosServicio gruposNosolidariosServicio) {
		this.gruposNosolidariosServicio = gruposNosolidariosServicio;
	}

	public SP_PDA_Segmentos_Descarga3ReyesServicio getSp_PDA_Segmentos_Descarga3ReyesServicio() {
		return sp_PDA_Segmentos_Descarga3ReyesServicio;
	}

	public void setSp_PDA_Segmentos_Descarga3ReyesServicio(
			SP_PDA_Segmentos_Descarga3ReyesServicio sp_PDA_Segmentos_Descarga3ReyesServicio) {
		this.sp_PDA_Segmentos_Descarga3ReyesServicio = sp_PDA_Segmentos_Descarga3ReyesServicio;
	}

	public ParametrosCajaServicio getParametrosCajaServicio() {
		return parametrosCajaServicio;
	}

	public void setParametrosCajaServicio(
			ParametrosCajaServicio parametrosCajaServicio) {
		this.parametrosCajaServicio = parametrosCajaServicio;
	}

}
