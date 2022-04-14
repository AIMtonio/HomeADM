package operacionesVBC.servicioweb;

import java.util.Iterator;
import java.util.List;

import operacionesVBC.bean.VbcConsultaCatalogoBean;
import operacionesVBC.beanWS.request.VbcConsultaCatalogoRequest;
import operacionesVBC.beanWS.response.VbcConsultaCatalogoResponse;
import operacionesVBC.servicio.VbcConsultaCatalogoServicio;

import org.springframework.ws.server.endpoint.AbstractDomPayloadEndpoint;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;

public class VbcConsultaCatalogoWS extends AbstractDomPayloadEndpoint{

	VbcConsultaCatalogoServicio vbcConsultaCatalogoServicio = null;
	public static final String NAMESPACE = "http://safisrv/ws/schemas";
	
	public VbcConsultaCatalogoWS(){
		super();
		// TODO Auto-generated constructor stub
	}
	protected Element invokeInternal(Element domRequest, Document document) throws Exception {
		VbcConsultaCatalogoRequest request     = this.xmlToInfoRequest(domRequest);
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosVBC");
		vbcConsultaCatalogoServicio.getVbcConsultaCatalogoDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);

		VbcConsultaCatalogoResponse response   = new VbcConsultaCatalogoResponse();
		
		request.setNomCatalogo(request.getNomCatalogo().replace("?", ""));
		request.setUsuario(request.getUsuario().replace("?", ""));
		request.setClave(request.getClave().replace("?", ""));

		if (request.getNomCatalogo().trim().isEmpty()){
			response.setCodigoRespuesta("01");
			response.setMensajeRespuesta("El Nombre del Catalogo esta Vacio.");
		}else if (request.getUsuario().isEmpty()){
			response.setCodigoRespuesta("02");
			response.setMensajeRespuesta("El Nombre de Usuario esta Vacio.");
		}else if (request.getClave().isEmpty()){
			response.setCodigoRespuesta("03");
			response.setMensajeRespuesta("La Clave del Usuario esta Vacia.");
		}else{
			request.setClave(SeguridadRecursosServicio.encriptaPass(request.getUsuario(), request.getClave()));
			response  = (VbcConsultaCatalogoResponse) vbcConsultaCatalogoServicio.listaOtrosCatWS(request);			
		}
		Element  domResponse = this.responseToXml(response, document);
		return domResponse;
	}

	/* convierte a xml el request */
	private VbcConsultaCatalogoRequest xmlToInfoRequest(Element request){
		VbcConsultaCatalogoRequest xmlInfoRequest = new VbcConsultaCatalogoRequest();
		try{
			// recupera el elemento llamado "NomCatalogo"
			Element elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "NomCatalogo").item(0);
			// obtiene el texto contenido
			String solicitudString = elementoNombre.getTextContent();
			xmlInfoRequest.setNomCatalogo(solicitudString);
			
			// recupera el elemento llamado "Usuario"
            elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "Usuario").item(0);
            // obtiene el texto contenido
            String usuario = elementoNombre.getTextContent();
            xmlInfoRequest.setUsuario(usuario);
            
            // recupera el elemento llamado "Clave"
            elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "Clave").item(0);
            // obtiene el texto contenido
            String clave = elementoNombre.getTextContent();
            xmlInfoRequest.setClave(clave);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return xmlInfoRequest; 
	}
	    
	 /* convierte a xml el response */
    private Element responseToXml(VbcConsultaCatalogoResponse response, Document document){  
        Element root = document.createElementNS("http://safisrv/ws/schemas", "ConsultaCatalogoGenericoResponse");  
        Element domCod = document.createElement("codigoRespuesta");  
       	Element domMen = document.createElement("mensajeRespuesta");  
        List<VbcConsultaCatalogoBean> otrosCat  = response.getOtrosCat();
       if (otrosCat != null){    	   
    	 if (otrosCat.size() > 0  ){
    		   Iterator<VbcConsultaCatalogoBean> iteCatalogos = null;
    		   VbcConsultaCatalogoBean vbcConsultaCatalogoBean = null;
    		   Element domCatalogo = null;
    		   iteCatalogos = otrosCat.iterator();  
    		   while (iteCatalogos.hasNext()){
    			   vbcConsultaCatalogoBean    = iteCatalogos.next();  
    			   domCatalogo = this.mapeoXml(document, vbcConsultaCatalogoBean);  
    			   root.appendChild(domCatalogo); 
    		   }
    		   domCod.appendChild(document.createTextNode(vbcConsultaCatalogoBean.getCodigoError()));
    		   domMen.appendChild(document.createTextNode(vbcConsultaCatalogoBean.getMensajeError()));
			   root.appendChild(domCod);
	           root.appendChild(domMen);
    	   }else{
    		domCod.appendChild(document.createTextNode(response.getCodigoRespuesta()));
           	domMen.appendChild(document.createTextNode(response.getMensajeRespuesta()));
           	root.appendChild(domCod);
           	root.appendChild(domMen);
           	
    	   }
       }
        return root;  
    }
	
	 /* Crea la estructura del nodo en el xml */
    private Element mapeoXml(Document document,VbcConsultaCatalogoBean otrosCatBean){  
    	Element domNodo = document.createElement("Catalogo");  
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
	
	public VbcConsultaCatalogoServicio getVbcConsultaCatalogoServicio() {
		return vbcConsultaCatalogoServicio;
	}
	public void setVbcConsultaCatalogoServicio(
			VbcConsultaCatalogoServicio vbcConsultaCatalogoServicio) {
		this.vbcConsultaCatalogoServicio = vbcConsultaCatalogoServicio;
	}	
}
