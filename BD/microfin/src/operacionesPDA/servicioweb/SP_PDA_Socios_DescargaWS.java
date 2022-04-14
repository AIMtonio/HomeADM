package operacionesPDA.servicioweb;

import java.util.Iterator;
import java.util.List;

import operacionesPDA.beanWS.request.SP_PDA_Socios_DescargaRequest;
import operacionesPDA.beanWS.response.SP_PDA_Ahorros_DescargaResponse;
import operacionesPDA.beanWS.response.SP_PDA_Socios_DescargaResponse;
import operacionesPDA.servicio.SP_PDA_Socios_Descarga3ReyesServicio;

import org.springframework.ws.server.endpoint.AbstractDomPayloadEndpoint;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

import soporte.PropiedadesSAFIBean;
import soporte.bean.ParametrosCajaBean;
import soporte.servicio.ParametrosCajaServicio;
import cliente.bean.ClienteBean;
import cliente.bean.GruposNosolidariosBean;
import cliente.servicio.GruposNosolidariosServicio;

public class SP_PDA_Socios_DescargaWS  extends AbstractDomPayloadEndpoint {
GruposNosolidariosServicio gruposNosolidariosServicio = null;

SP_PDA_Socios_Descarga3ReyesServicio sp_PDA_Socios_Descarga3ReyesServicio= null;
ParametrosCajaServicio parametrosCajaServicio = null;
String varYanga = "YANGA";
String var3Reyes = "3 REYES";

public static final String NAMESPACE = "http://safisrv/ws/schemas";
	
	public SP_PDA_Socios_DescargaWS()  {
		super();
	}
	

    protected Element invokeInternal(Element domRequest, Document document) throws Exception {                   
    	SP_PDA_Socios_DescargaRequest  request     = this.xmlToInfoRequest(domRequest);      
    	String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
    	gruposNosolidariosServicio.getGruposNosolidariosDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
    	sp_PDA_Socios_Descarga3ReyesServicio.getSp_PDA_Socios_Descarga3ReyesDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);

    	SP_PDA_Socios_DescargaResponse response    = new SP_PDA_Socios_DescargaResponse();
    	ParametrosCajaBean parametrosCajaBean = new ParametrosCajaBean();

		parametrosCajaBean.setEmpresaID("1");
		parametrosCajaBean = parametrosCajaServicio.consulta(ParametrosCajaServicio.Enum_Con_ParametrosCaja.paramVersionWS, parametrosCajaBean);
		
		Element  domResponse = null;
		
		if(parametrosCajaBean.getVersionWS().equals(varYanga)){
			response    = (SP_PDA_Socios_DescargaResponse) gruposNosolidariosServicio.listaSociosWS(request);
	        domResponse = this.responseToXml(response, document);            

		}
		else{

		if(parametrosCajaBean.getVersionWS().equals(var3Reyes)){
			response  = (SP_PDA_Socios_DescargaResponse) sp_PDA_Socios_Descarga3ReyesServicio.listaSociosWS(request);
	        domResponse = this.response3ReyesToXml(response, document);            

			}
		}
          
        return domResponse;  
    }  

   
    /* convierte a xml el request */
    private SP_PDA_Socios_DescargaRequest xmlToInfoRequest(Element request){         
   	
    	String Id_Segmento ;
    	SP_PDA_Socios_DescargaRequest xmlInfoRequest  = new SP_PDA_Socios_DescargaRequest();  
    	try{
            Element elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "Id_Segmento").item(0);
            
            Id_Segmento = elementoNombre.getTextContent();
            xmlInfoRequest.setId_Segmento(Id_Segmento);
    	}
          catch(Exception e){
        	  e.printStackTrace();
          }
         
        return xmlInfoRequest; 
    }
    
    /* convierte a xml el response */
    private Element responseToXml(SP_PDA_Socios_DescargaResponse response, Document document){  
        Element     root    = document.createElementNS("http://safisrv/ws/schemas", "DescargarSociosResponse");  
        List<GruposNosolidariosBean> socios  = response.getSocios();  
          
        if (socios != null){  
            Iterator<GruposNosolidariosBean> iteSocios = null;  
            GruposNosolidariosBean socio     = null;  
            Element    domSocio  = null;  
              
            iteSocios = socios.iterator();  
            while (iteSocios.hasNext()){  
            	socio    = iteSocios.next();  
            	domSocio = this.mapeoXml(document, socio);  
                root.appendChild(domSocio);  
            }  
        }  
          
        return root;  
    }
    
    /* Crea la estructura del nodo en el xml */
    private Element mapeoXml(Document document, GruposNosolidariosBean segmentoBean){  
        Element domNodo = document.createElement("Socio");  
          
        this.agregaHijo(document, domNodo, "NumSocio", segmentoBean.getNumSocio());  
        this.agregaHijo(document, domNodo, "Nombre",  segmentoBean.getNombre());  
        this.agregaHijo(document, domNodo, "ApPaterno", segmentoBean.getApPaterno());  
        this.agregaHijo(document, domNodo, "ApMaterno",  segmentoBean.getApMaterno());  
        this.agregaHijo(document, domNodo, "FecNacimiento", segmentoBean.getFecNacimiento());  
        this.agregaHijo(document, domNodo, "Rfc",  segmentoBean.getRfc());  
          
        return domNodo;  
    }
    
    

    /* convierte a xml el response para clientes por promotor*/
    private Element response3ReyesToXml(SP_PDA_Socios_DescargaResponse response, Document document){  
        Element     root    = document.createElementNS("http://safisrv/ws/schemas", "DescargarSociosResponse");  
        List<ClienteBean> socios  = response.getCliente();  
          
        if (socios != null){  
            Iterator<ClienteBean> iteSocios = null;  
            ClienteBean socio     = null;  
            Element    domSocio  = null;  
              
            iteSocios = socios.iterator();  
            while (iteSocios.hasNext()){  
            	socio    = iteSocios.next();  
            	domSocio = this.mapeo3ReyesXml(document, socio);  
                root.appendChild(domSocio);  
            }  
        }  
          
        return root;  
    }
    
    /* Crea la estructura del nodo en el xml */
    private Element mapeo3ReyesXml(Document document, ClienteBean segmentoBean){  
        Element domNodo = document.createElement("Socio");  
          
        this.agregaHijo(document, domNodo, "NumSocio", segmentoBean.getNumero());  
        this.agregaHijo(document, domNodo, "Nombre",  segmentoBean.getNombreCompleto());  
        this.agregaHijo(document, domNodo, "ApPaterno", segmentoBean.getApellidoPaterno());  
        this.agregaHijo(document, domNodo, "ApMaterno",  segmentoBean.getApellidoMaterno());  
        this.agregaHijo(document, domNodo, "FecNacimiento", segmentoBean.getFechaNacimiento());  
        this.agregaHijo(document, domNodo, "Rfc",  segmentoBean.getRFC());  
          
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


	public SP_PDA_Socios_Descarga3ReyesServicio getSp_PDA_Socios_Descarga3ReyesServicio() {
		return sp_PDA_Socios_Descarga3ReyesServicio;
	}


	public void setSp_PDA_Socios_Descarga3ReyesServicio(
			SP_PDA_Socios_Descarga3ReyesServicio sp_PDA_Socios_Descarga3ReyesServicio) {
		this.sp_PDA_Socios_Descarga3ReyesServicio = sp_PDA_Socios_Descarga3ReyesServicio;
	}


	public ParametrosCajaServicio getParametrosCajaServicio() {
		return parametrosCajaServicio;
	}


	public void setParametrosCajaServicio(
			ParametrosCajaServicio parametrosCajaServicio) {
		this.parametrosCajaServicio = parametrosCajaServicio;
	} 
	
}