package operacionesVBC.servicioweb;

import java.util.Iterator;
import java.util.List;

import operacionesVBC.bean.VbcConsultaAmortiPagosBean;
import operacionesVBC.beanWS.request.VbcConsultaAmorPagRequest;
import operacionesVBC.beanWS.response.VbcConsultaAmorPagResponse;
import operacionesVBC.servicio.VbcConsultaAmorPagServicio;

import org.springframework.ws.server.endpoint.AbstractDomPayloadEndpoint;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;
import soporte.servicio.ParametrosSisServicio;


public class VbcConsultaAmorPagWS  extends AbstractDomPayloadEndpoint {
	VbcConsultaAmorPagServicio vbcConsultaAmorPagServicio = null;
	ParametrosSisServicio parametrosSisServicio = null;
		
	public static final String NAMESPACE = "http://safisrv/ws/schemas";
								
	public VbcConsultaAmorPagWS() {
		super();
		// TODO Auto-generated constructor stub
	}	

    protected Element invokeInternal(Element domRequest, Document document) throws Exception {                   
    	VbcConsultaAmorPagRequest request     = this.xmlToInfoRequest(domRequest); 
    	String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosVBC");
    	vbcConsultaAmorPagServicio.getVbcConsultaAmorPagDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
    	
    	VbcConsultaAmorPagResponse response   = new VbcConsultaAmorPagResponse();
    	request.setClave(SeguridadRecursosServicio.encriptaPass(request.getUsuario(),request.getClave()));
		
		response  = (VbcConsultaAmorPagResponse) vbcConsultaAmorPagServicio.listaPagosAmortizacionesWS(request);
        Element  domResponse = this.responseToXml(response, document);            
        return domResponse;  
    }  

    /* convierte a xml el request */
    private VbcConsultaAmorPagRequest xmlToInfoRequest(Element request){           
    	VbcConsultaAmorPagRequest xmlInfoRequest = new VbcConsultaAmorPagRequest();  
    	try{
    		// recupera el elemento llamado "CreditoID"
            Element elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "CreditoID").item(0);
            // obtiene el texto contenido
            String creditoID= elementoNombre.getTextContent();
            xmlInfoRequest.setCreditoID(creditoID);
            
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
    private Element responseToXml(VbcConsultaAmorPagResponse response, Document document){  
        Element     root    = document.createElementNS("http://safisrv/ws/schemas", "VbcConsultaAmorPagResponse");   
        Element domCod = document.createElement("CodigoRespuesta");  
       	Element domMen = document.createElement("MensajeRespuesta"); 
        List<VbcConsultaAmortiPagosBean> amortiPagosBean  = response.getAmortiPagos();  
          
       if (amortiPagosBean != null){  
    	   if (amortiPagosBean.size() > 0  ){
    		   Iterator<VbcConsultaAmortiPagosBean> iteDetSimCre = null;  

    		   VbcConsultaAmortiPagosBean amortiWsBean = null;  
    		   Element    domSimWs  = null;  
              
    		   iteDetSimCre = amortiPagosBean.iterator();  
    		   while (iteDetSimCre.hasNext()){  
    			   amortiWsBean    = iteDetSimCre.next();  
    			   domSimWs = this.mapeoXml(document, amortiWsBean);  
    			   
    			   domCod.appendChild(document.createTextNode(amortiWsBean.getCodigoError()));
        		   domMen.appendChild(document.createTextNode(amortiWsBean.getMensajeError()));
        		   root.appendChild(domCod);
        		   root.appendChild(domMen);
        		   
    			   root.appendChild(domSimWs);  
    		   }  
    	   }else{           	
       			domCod.appendChild(document.createTextNode("999"));
              	domMen.appendChild(document.createTextNode("Error al Consultar Pagos Amortizaciones"));
              	root.appendChild(domCod);
              	root.appendChild(domMen);
    	   }
        }  
          
        return root;  
    }
    
    /* Crea la estructura del nodo en el xml */ 
    private Element mapeoXml(Document document, VbcConsultaAmortiPagosBean amortizaBean){  
    	Element domNodo = document.createElement("DetallePagos");  
    
    	this.agregaHijo(document, domNodo, "CreditoID", amortizaBean.getCreditoID());
    	this.agregaHijo(document, domNodo, "AmortizacionID", amortizaBean.getAmortizacionID());
    	this.agregaHijo(document, domNodo, "ClienteID", amortizaBean.getClienteID());
    	this.agregaHijo(document, domNodo, "FechaExigible", amortizaBean.getFechaExigible()); 
    	this.agregaHijo(document, domNodo, "TotalPagado", amortizaBean.getTotalPagado()); 

    	this.agregaHijo(document, domNodo, "Capital", amortizaBean.getCapitalPagado()); 
    	this.agregaHijo(document, domNodo, "Interes", amortizaBean.getInteres()); 
    	this.agregaHijo(document, domNodo, "IvaInteres", amortizaBean.getIvaInteres()); 
    	this.agregaHijo(document, domNodo, "InteresMora", amortizaBean.getInteresMora()); 
    	this.agregaHijo(document, domNodo, "IvaInteresMora", amortizaBean.getIvaInteresMora());
    	
    	this.agregaHijo(document, domNodo, "FechaPago", amortizaBean.getFechaPago()); 
    	this.agregaHijo(document, domNodo, "DiasAtraso", amortizaBean.getDiasAtraso()); 
        this.agregaHijo(document, domNodo, "Estatus", amortizaBean.getEstatus()); 
    	return domNodo;  
    }
    
    /* agrega nodo al xml */
    private void agregaHijo(Document document, Element padre, String tag, String valor){  
        Element domNombre = document.createElement(tag);  
        Text    domValor  = document.createTextNode(valor);  
        domNombre.appendChild(domValor);  
        padre.appendChild(domNombre);  
    }

	public VbcConsultaAmorPagServicio getVbcConsultaAmorPagServicio() {
		return vbcConsultaAmorPagServicio;
	}

	public void setVbcConsultaAmorPagServicio(
			VbcConsultaAmorPagServicio vbcConsultaAmorPagServicio) {
		this.vbcConsultaAmorPagServicio = vbcConsultaAmorPagServicio;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
}

