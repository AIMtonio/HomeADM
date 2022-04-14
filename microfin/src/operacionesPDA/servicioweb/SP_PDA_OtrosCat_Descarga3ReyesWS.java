package operacionesPDA.servicioweb;

import herramientas.Constantes;

import java.util.Iterator;
//import java.util.Iterator;
import java.util.List;

import operacionesPDA.bean.SP_PDA_OtrosCat_Descarga3ReyesBean;
import operacionesPDA.beanWS.request.SP_PDA_OtrosCat_Descarga3ReyesRequest;
import operacionesPDA.beanWS.response.SP_PDA_OtrosCat_Descarga3ReyesResponse;
import operacionesPDA.servicio.SP_PDA_OtrosCat_Descarga3ReyesServicio;

import org.springframework.ws.server.endpoint.AbstractDomPayloadEndpoint;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

import soporte.PropiedadesSAFIBean;
import soporte.bean.ParametrosCajaBean;
import soporte.servicio.ParametrosCajaServicio;


public class SP_PDA_OtrosCat_Descarga3ReyesWS  extends AbstractDomPayloadEndpoint {
	SP_PDA_OtrosCat_Descarga3ReyesServicio sp_PDA_OtrosCat_Descarga3ReyesServicio = null;
	
	ParametrosCajaServicio parametrosCajaServicio = null;
	String varYanga = "YANGA";
	String var3Reyes = "3 REYES";
		
		
	public static final String NAMESPACE = "http://safisrv/ws/schemas";

	
	public SP_PDA_OtrosCat_Descarga3ReyesWS() {
		super();
		// TODO Auto-generated constructor stub
	}
	

    protected Element invokeInternal(Element domRequest, Document document) throws Exception {                   
    	SP_PDA_OtrosCat_Descarga3ReyesRequest request     = this.xmlToInfoRequest(domRequest); 
    	String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
    	sp_PDA_OtrosCat_Descarga3ReyesServicio.getSp_PDA_OtrosCat_Descarga3ReyesDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
    	
    	SP_PDA_OtrosCat_Descarga3ReyesResponse response   = new SP_PDA_OtrosCat_Descarga3ReyesResponse();
    	
     ParametrosCajaBean parametrosCajaBean = new ParametrosCajaBean();
		
        parametrosCajaBean.setEmpresaID("1");
		parametrosCajaBean = parametrosCajaServicio.consulta(ParametrosCajaServicio.Enum_Con_ParametrosCaja.paramVersionWS, parametrosCajaBean);
		
		if(parametrosCajaBean.getVersionWS().equals(varYanga)){
			response  = (SP_PDA_OtrosCat_Descarga3ReyesResponse) sp_PDA_OtrosCat_Descarga3ReyesServicio.listaOtrosCatWS(request);
		}
		else{

		if(parametrosCajaBean.getVersionWS().equals(var3Reyes)){
			response  = (SP_PDA_OtrosCat_Descarga3ReyesResponse) sp_PDA_OtrosCat_Descarga3ReyesServicio.listaOtrosCatWS(request);

			}
		}
 
        Element  domResponse = this.responseToXml(response, document);            
        return domResponse;  
    }  

    /* convierte a xml el request */
    private SP_PDA_OtrosCat_Descarga3ReyesRequest xmlToInfoRequest(Element request){  
          
    	SP_PDA_OtrosCat_Descarga3ReyesRequest xmlInfoRequest = new SP_PDA_OtrosCat_Descarga3ReyesRequest();  
    	try{
    		// recupera el elemento llamado "SP_Name"
            Element elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "SP_Name").item(0);
            // obtiene el texto contenido
            String solicitudString = elementoNombre.getTextContent();
            xmlInfoRequest.setSP_Name(solicitudString);
    	}
          catch(Exception e){
        	  e.printStackTrace();
          }
        return xmlInfoRequest; 
    }
    
    /* convierte a xml el response */
    private Element responseToXml(SP_PDA_OtrosCat_Descarga3ReyesResponse response, Document document){  
        Element     root    = document.createElementNS("http://safisrv/ws/schemas", "DescargarCatalogoGenericoResponse");  
        List<SP_PDA_OtrosCat_Descarga3ReyesBean> otrosCat  = response.getOtrosCat();  
          
       if (otrosCat != null){  
            Iterator<SP_PDA_OtrosCat_Descarga3ReyesBean> iteCatalogos = null;  

            SP_PDA_OtrosCat_Descarga3ReyesBean sp_PDA_OtrosCat_DescargaBean = null;  
            Element    domCatalogo  = null;  
              
            iteCatalogos = otrosCat.iterator();  
            while (iteCatalogos.hasNext()){  
            	sp_PDA_OtrosCat_DescargaBean    = iteCatalogos.next();  
            	domCatalogo = this.mapeoXml(document, sp_PDA_OtrosCat_DescargaBean);  
                root.appendChild(domCatalogo);  
           }  
        }  
          
        return root;  
    }
    
    /* Crea la estructura del nodo en el xml */
    private Element mapeoXml(Document document, SP_PDA_OtrosCat_Descarga3ReyesBean otrosCatBean){  
       Element domNodo = document.createElement("Generico");  
       
        this.agregaHijo(document, domNodo, "Id_Campo", otrosCatBean.getCampo());
        this.agregaHijo(document, domNodo, "NombreCampo",otrosCatBean.getNcampo());
        this.agregaHijo(document, domNodo, "Id_Padre", otrosCatBean.getPadre()); 

    
        return domNodo;  
    }
    
    /* agrega nodo al xml */
    private void agregaHijo(Document document, Element padre, String tag, String valor){  
        Element domNombre = document.createElement(tag);  
        Text    domValor  = document.createTextNode(valor);  
          
        domNombre.appendChild(domValor);  
        padre.appendChild(domNombre);  
    }


	public SP_PDA_OtrosCat_Descarga3ReyesServicio getSp_PDA_OtrosCat_Descarga3ReyesServicio() {
		return sp_PDA_OtrosCat_Descarga3ReyesServicio;
	}


	public void setSp_PDA_OtrosCat_Descarga3ReyesServicio(
			SP_PDA_OtrosCat_Descarga3ReyesServicio sp_PDA_OtrosCat_Descarga3ReyesServicio) {
		this.sp_PDA_OtrosCat_Descarga3ReyesServicio = sp_PDA_OtrosCat_Descarga3ReyesServicio;
	}


	public ParametrosCajaServicio getParametrosCajaServicio() {
		return parametrosCajaServicio;
	}


	public void setParametrosCajaServicio(
			ParametrosCajaServicio parametrosCajaServicio) {
		this.parametrosCajaServicio = parametrosCajaServicio;
	}

}

