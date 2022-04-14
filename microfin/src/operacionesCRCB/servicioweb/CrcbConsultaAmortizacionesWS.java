package operacionesCRCB.servicioweb;

import herramientas.Constantes;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;


import operacionesCRCB.bean.ConsultaAmortizacionesBean;
import operacionesCRCB.beanWS.request.ConsultaAmortizacionesRequest;
import operacionesCRCB.beanWS.response.ConsultaAmortizacionesResponse;
import operacionesCRCB.beanWS.validacion.ConsultaAmortizacionesValidacion;
import operacionesCRCB.servicio.AmortizacionesCreditoServicio;

import org.springframework.ws.server.endpoint.AbstractDomPayloadEndpoint;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

public class CrcbConsultaAmortizacionesWS  extends AbstractDomPayloadEndpoint {
	
	AmortizacionesCreditoServicio amortizacionesCreditoServicio = null;
	public static final String NAMESPACE = "http://safisrv/ws/schemas";
								
	public CrcbConsultaAmortizacionesWS() {
		super();
		// TODO Auto-generated constructor stub
	}	

    protected Element invokeInternal(Element domRequest, Document document) throws Exception {   
    	Element  domResponse;
    	ConsultaAmortizacionesRequest request     = this.xmlToInfoRequest(domRequest); 
   	   	ConsultaAmortizacionesResponse response   = new ConsultaAmortizacionesResponse();	
		
    	ConsultaAmortizacionesValidacion consultaAmortizacionesValidacion = new ConsultaAmortizacionesValidacion();

    	response = consultaAmortizacionesValidacion.isRequestValid(request);		
		if(response.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
			
			request.asignaParametrosAud(amortizacionesCreditoServicio.getAmortizacionesCreditoDAO().getParametrosAuditoriaBean());
			
			response  = amortizacionesCreditoServicio.lista(request, AmortizacionesCreditoServicio.Enum_Lis_Amortiza.listaAmortizaciones);
			
	        domResponse = this.responseToXml(response, document);   
        }else{
        	domResponse = respuestaValidacion(response, document);
        }
		
        return domResponse;  
        
    }  

    
    private Element respuestaValidacion(ConsultaAmortizacionesResponse response, Document document){  
        Element     root    = document.createElementNS("http://safisrv/ws/schemas", "ConsultaAmortizacionesResponse");   
        Element domCod = document.createElement("CodigoRespuesta");  
       	Element domMen = document.createElement("MensajeRespuesta"); 
       	
        domCod.appendChild(document.createTextNode(response.getCodigoRespuesta()));
		domMen.appendChild(document.createTextNode(response.getMensajeRespuesta()));       
              	
      	root.appendChild(domCod);
      	root.appendChild(domMen);
          
        return root;  
    }
    

	/* convierte a xml el request */
    private ConsultaAmortizacionesRequest xmlToInfoRequest(Element request){           
    	ConsultaAmortizacionesRequest xmlInfoRequest = new ConsultaAmortizacionesRequest();  
    	try{
    		
            Element elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "CreditoID").item(0);

            String creditoID= elementoNombre.getTextContent();
            xmlInfoRequest.setCreditoID(creditoID);
            
    	}catch(Exception e){
    		e.printStackTrace();
    	}
        return xmlInfoRequest; 
    }
    
    /* convierte a xml el response */
    private Element responseToXml(ConsultaAmortizacionesResponse response, Document document){  
        Element     root    = document.createElementNS("http://safisrv/ws/schemas", "ConsultaAmortizacionesResponse");   
        Element domCod = document.createElement("CodigoRespuesta");  
       	Element domMen = document.createElement("MensajeRespuesta"); 
        List<ConsultaAmortizacionesBean> amortiBean  = response.getAmortiCredito();  
        
        domCod.appendChild(document.createTextNode(response.getCodigoRespuesta()));
		domMen.appendChild(document.createTextNode(response.getMensajeRespuesta()));
       
		root.appendChild(domCod);
		root.appendChild(domMen);
		
       if (amortiBean != null){  
    	   if (amortiBean.size() > 0  ){
    		   Iterator<ConsultaAmortizacionesBean> iteDetSimCre = null;  

    		   ConsultaAmortizacionesBean amortiWsBean = null;  
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
    private Element mapeoXml(Document document, ConsultaAmortizacionesBean amortizaBean){  
    	Element domNodo = document.createElement("AmortiCredito");  
    
    	this.agregaHijo(document, domNodo, "CreditoID", amortizaBean.getCreditoID());
    	this.agregaHijo(document, domNodo, "ClienteID", amortizaBean.getClienteID());
    	this.agregaHijo(document, domNodo, "AmortizacionID", amortizaBean.getAmortizacionID());
    	this.agregaHijo(document, domNodo, "FechaInicio", amortizaBean.getFechaInicio());
    	this.agregaHijo(document, domNodo, "FechaVencim", amortizaBean.getFechaVencim());
    	this.agregaHijo(document, domNodo, "FechaExigible", amortizaBean.getFechaExigible());
    	this.agregaHijo(document, domNodo, "Capital", amortizaBean.getCapital());
    	this.agregaHijo(document, domNodo, "Interes", amortizaBean.getInteres());
    	this.agregaHijo(document, domNodo, "IvaInteres", amortizaBean.getIvaInteres());
    	this.agregaHijo(document, domNodo, "TotalPago", amortizaBean.getTotalPago());
    	this.agregaHijo(document, domNodo, "SaldoInsoluto", amortizaBean.getSaldoInsoluto());
    	this.agregaHijo(document, domNodo, "Dias", amortizaBean.getDias());
    	this.agregaHijo(document, domNodo, "FecUltAmor", amortizaBean.getFecUltAmor());
    	this.agregaHijo(document, domNodo, "FecInicioAmor", amortizaBean.getFecInicioAmor());
    	this.agregaHijo(document, domNodo, "MontoCuota", amortizaBean.getMontoCuota());
    	this.agregaHijo(document, domNodo, "TotalCap", amortizaBean.getTotalCap());
    	this.agregaHijo(document, domNodo, "TotalInteres", amortizaBean.getTotalInteres());
    	this.agregaHijo(document, domNodo, "TotalIva", amortizaBean.getTotalIva());

    	return domNodo;  
    }
    
    /* agrega nodo al xml */
    private void agregaHijo(Document document, Element padre, String tag, String valor){  
        Element domNombre = document.createElement(tag);  
        Text    domValor  = document.createTextNode(valor);  
        domNombre.appendChild(domValor);  
        padre.appendChild(domNombre);  
    }

	public AmortizacionesCreditoServicio getAmortizacionesCreditoServicio() {
		return amortizacionesCreditoServicio;
	}

	public void setAmortizacionesCreditoServicio(
			AmortizacionesCreditoServicio amortizacionesCreditoServicio) {
		this.amortizacionesCreditoServicio = amortizacionesCreditoServicio;
	}

    
    
	
}

