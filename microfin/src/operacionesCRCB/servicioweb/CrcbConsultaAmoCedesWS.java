package operacionesCRCB.servicioweb;

import herramientas.Constantes;

import java.util.Iterator;
import java.util.List;

import operacionesCRCB.bean.ConsultaCedesBean;
import operacionesCRCB.beanWS.request.ConsultaAmortizacionCedeRequest;
import operacionesCRCB.beanWS.response.ConsultaAmortizacionCedeResponse;
import operacionesCRCB.beanWS.validacion.ConsultaAmortizacionCedeValidacion;
import operacionesCRCB.servicio.ConsultaCedesServicio;

import org.springframework.ws.server.endpoint.AbstractDomPayloadEndpoint;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

public class CrcbConsultaAmoCedesWS  extends AbstractDomPayloadEndpoint {
	
	private ConsultaCedesServicio consultaCedesServicio = null;
	public static final String NAMESPACE = "http://safisrv/ws/schemas";
	
	
	public CrcbConsultaAmoCedesWS() {
		super();
		// TODO Auto-generated constructor stub
	}

	 protected Element invokeInternal(Element domRequest, Document document) throws Exception {   
	    	Element  domResponse;
	    	ConsultaAmortizacionCedeRequest request     = this.xmlToInfoRequest(domRequest); 
	    	ConsultaAmortizacionCedeResponse response   = new ConsultaAmortizacionCedeResponse();	
				    	
	    	ConsultaAmortizacionCedeValidacion consultaAmortizacionesValidacion = new ConsultaAmortizacionCedeValidacion();

	    	response = consultaAmortizacionesValidacion.isRequestValid(request);
	    	
			if(response.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
				
				request.asignaParametrosAud(consultaCedesServicio.getConsultaCedesDAO().getParametrosAuditoriaBean());
				
				response  = (ConsultaAmortizacionCedeResponse) consultaCedesServicio.lista(request, ConsultaCedesServicio.Enum_Con_Cedes_WS.consultaAmo);
				
		        domResponse = this.responseToXml(response, document);   
	        }else{
	        	domResponse = respuestaValidacion(response, document);
	        }
			
	        return domResponse;  
	        
	    }  

	    
	    private Element respuestaValidacion(ConsultaAmortizacionCedeResponse response, Document document){  
	        Element root    = document.createElementNS("http://safisrv/ws/schemas", "ConsultaAmortizacionCedeResponse");   
	        Element domCod = document.createElement("CodigoRespuesta");  
	       	Element domMen = document.createElement("MensajeRespuesta"); 
	        domCod.appendChild(document.createTextNode(response.getCodigoRespuesta()));
			domMen.appendChild(document.createTextNode(response.getMensajeRespuesta()));       
	              	
	      	root.appendChild(domCod);
	      	root.appendChild(domMen);
	          
	        return root;  
	    }
	    
		/* convierte a xml el request */
	    private ConsultaAmortizacionCedeRequest xmlToInfoRequest(Element request){           
	    	ConsultaAmortizacionCedeRequest xmlInfoRequest = new ConsultaAmortizacionCedeRequest();  
	    	try{
	    		
	            Element elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "CedeID").item(0);

	            String cedeID= elementoNombre.getTextContent();
	            xmlInfoRequest.setCedeID(cedeID);
	            
	    	}catch(Exception e){
	    		e.printStackTrace();
	    	}
	        return xmlInfoRequest; 
	    }
	    
	    /* convierte a xml el response */
	    private Element responseToXml(ConsultaAmortizacionCedeResponse response, Document document){  
	        Element     root    = document.createElementNS("http://safisrv/ws/schemas", "ConsultaAmortizacionCedeResponse");   
	        Element domCod = document.createElement("CodigoRespuesta");  
	       	Element domMen = document.createElement("MensajeRespuesta"); 
	        List<ConsultaCedesBean> amortiBean  = response.getAmortiCedes();  
	        
	        domCod.appendChild(document.createTextNode(response.getCodigoRespuesta()));
			domMen.appendChild(document.createTextNode(response.getMensajeRespuesta()));
	       
			root.appendChild(domCod);
			root.appendChild(domMen);
			
	       if (amortiBean != null){  
	    	   if (amortiBean.size() > 0  ){
	    		   Iterator<ConsultaCedesBean> iteDetSimCre = null;  

	    		   ConsultaCedesBean amortiWsBean = null;  
	    		   Element    domSimWs  = null;  
	              
	    		   iteDetSimCre = amortiBean.iterator();  
	    		   while (iteDetSimCre.hasNext()){  
	    			   amortiWsBean    = iteDetSimCre.next();  
	    			   domSimWs = this.mapeoXml(document, amortiWsBean);  
	        		   
	    			   root.appendChild(domSimWs);  
	    		   }  
	    	   }
	        }  
	          
	        return root;  
	    }
	    
	    /* Crea la estructura del nodo en el xml */ 
	    private Element mapeoXml(Document document, ConsultaCedesBean amortizaBean){  
	    	Element domNodo = document.createElement("AmortiCedes");  
	    
	    	this.agregaHijo(document, domNodo, "CEDEID", amortizaBean.getCEDEID());
	    	this.agregaHijo(document, domNodo, "AmortizacionID", amortizaBean.getAmortizacionID());
	    	this.agregaHijo(document, domNodo, "FechaInicio", amortizaBean.getFechaInicio());
	    	this.agregaHijo(document, domNodo, "FechaVencimiento", amortizaBean.getFechaVencimiento());
	    	this.agregaHijo(document, domNodo, "FechaPago", amortizaBean.getFechaPago());
	    	this.agregaHijo(document, domNodo, "Capital", amortizaBean.getCapital());
	    	this.agregaHijo(document, domNodo, "Interes", amortizaBean.getInteres());
	    	this.agregaHijo(document, domNodo, "InteresRetener", amortizaBean.getInteresRetener());
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

		public ConsultaCedesServicio getConsultaCedesServicio() {
			return consultaCedesServicio;
		}

		public void setConsultaCedesServicio(ConsultaCedesServicio consultaCedesServicio) {
			this.consultaCedesServicio = consultaCedesServicio;
		}
	
	
}
