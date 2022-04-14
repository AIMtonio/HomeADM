package operacionesVBC.servicioweb;

import java.util.Iterator;
import java.util.List;

import operacionesVBC.bean.VbcSimuladorCreditoBean;
import operacionesVBC.beanWS.request.VbcSimuladorCreditoRequest;
import operacionesVBC.beanWS.response.VbcSimuladorCreditoResponse;
import operacionesVBC.servicio.VbcSimuladorCreditoServicio;

import org.springframework.ws.server.endpoint.AbstractDomPayloadEndpoint;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;
import soporte.servicio.ParametrosSisServicio;


public class VbcSimuladorCreditoWS  extends AbstractDomPayloadEndpoint {
	VbcSimuladorCreditoServicio vbcSimuladorCreditoServicio = null;
	ParametrosSisServicio parametrosSisServicio = null;
		
	public static final String NAMESPACE = "http://safisrv/ws/schemas";
								
	public VbcSimuladorCreditoWS() {
		super();
		// TODO Auto-generated constructor stub
	}	

    protected Element invokeInternal(Element domRequest, Document document) throws Exception {                   
    	VbcSimuladorCreditoRequest request     = this.xmlToInfoRequest(domRequest); 
    	String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosVBC");
    	vbcSimuladorCreditoServicio.getVbcSimuladorCreditoDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
    	
    	VbcSimuladorCreditoResponse response   = new VbcSimuladorCreditoResponse();
    	request.setClave(SeguridadRecursosServicio.encriptaPass(request.getUsuario(),request.getClave()));
		request.setFrecuencia(request.getFrecuencia().substring(0,1));
		response  = (VbcSimuladorCreditoResponse) vbcSimuladorCreditoServicio.listaDetalleSimWS(request);
        Element  domResponse = this.responseToXml(response, document);            
        return domResponse;  
    }  

    /* convierte a xml el request */
    private VbcSimuladorCreditoRequest xmlToInfoRequest(Element request){           
    	VbcSimuladorCreditoRequest xmlInfoRequest = new VbcSimuladorCreditoRequest();  
    	try{
    		// recupera el elemento llamado "Monto"
            Element elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "Monto").item(0);
            // obtiene el texto contenido
            String monto = elementoNombre.getTextContent();
            xmlInfoRequest.setMonto(monto);
            
            // recupera el elemento llamado "Tasa"
            elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "Tasa").item(0);
            // obtiene el texto contenido
            String tasa = elementoNombre.getTextContent();
            xmlInfoRequest.setTasa(tasa);
            
            // recupera el elemento llamado "Frecuencia"
            elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "Frecuencia").item(0);
            // obtiene el texto contenido
            String frecuencia = elementoNombre.getTextContent();
            xmlInfoRequest.setFrecuencia(frecuencia);
            

            // recupera el elemento llamado "Periodicidad"
            elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "Periodicidad").item(0);
            // obtiene el texto contenido
            String periodicidad = elementoNombre.getTextContent();
            xmlInfoRequest.setPeriodicidad(periodicidad);
            
            // recupera el elemento llamado "FechaInicio"
            elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "FechaInicio").item(0);
            // obtiene el texto contenido
            String fechaInicio = elementoNombre.getTextContent();
            xmlInfoRequest.setFechaInicio(fechaInicio);
            
            // recupera el elemento llamado "NumeroCuotas"
            elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "NumeroCuotas").item(0);
            // obtiene el texto contenido
            String numeroCuotas = elementoNombre.getTextContent();
            xmlInfoRequest.setNumeroCuotas(numeroCuotas);
            
            // recupera el elemento llamado "ProductoCreditoID"
            elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "ProductoCreditoID").item(0);
            // obtiene el texto contenido
            String productoCreditoID = elementoNombre.getTextContent();
            xmlInfoRequest.setProductoCreditoID(productoCreditoID);
            
            // recupera el elemento llamado "ClienteID"
            elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "ClienteID").item(0);
            // obtiene el texto contenido
            String clienteID= elementoNombre.getTextContent();
            xmlInfoRequest.setClienteID(clienteID);
            
            // recupera el elemento llamado "ComisionApertura"
            elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "ComisionApertura").item(0);
            // obtiene el texto contenido
            String comisionApertura = elementoNombre.getTextContent();
            xmlInfoRequest.setComisionApertura(comisionApertura);

            // recupera el elemento llamado "ComisionApertura"
            elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "Usuario").item(0);
            // obtiene el texto contenido
            String usuario = elementoNombre.getTextContent();
            xmlInfoRequest.setUsuario(usuario);
            
            // recupera el elemento llamado "ComisionApertura"
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
    private Element responseToXml(VbcSimuladorCreditoResponse response, Document document){  
        Element     root    = document.createElementNS("http://safisrv/ws/schemas", "VbcSimuladorCreditoResponse");   
        Element domCod = document.createElement("CodigoRespuesta");  
       	Element domMen = document.createElement("MensajeRespuesta"); 
        List<VbcSimuladorCreditoBean> simCreBean  = response.getAmortiSimulador();  
          
       if (simCreBean != null){  
    	   if (simCreBean.size() > 0  ){
    		   Iterator<VbcSimuladorCreditoBean> iteDetSimCre = null;  

    		   VbcSimuladorCreditoBean simCredWsBean = null;  
    		   Element    domSimWs  = null;  
              
    		   iteDetSimCre = simCreBean.iterator();  
    		   while (iteDetSimCre.hasNext()){  
    			   simCredWsBean    = iteDetSimCre.next();  
    			   domSimWs = this.mapeoXml(document, simCredWsBean);  
    			   
    			   root.appendChild(domSimWs);
    			   
    			   domCod.appendChild(document.createTextNode(simCredWsBean.getCodigoError()));
        		   domMen.appendChild(document.createTextNode(simCredWsBean.getMensajeError()));
        		   root.appendChild(domCod);
        		   root.appendChild(domMen);      		   
    			     
    		   }  
    		   
    	   }else{           	
       			domCod.appendChild(document.createTextNode("999"));
              	domMen.appendChild(document.createTextNode("Error al Simular"));
              	root.appendChild(domCod);
              	root.appendChild(domMen);
    	   }
        }  
          
        return root;  
    }
    
    /* Crea la estructura del nodo en el xml */ 
    private Element mapeoXml(Document document, VbcSimuladorCreditoBean simCredBean){  
    	Element domNodo = document.createElement("AmortiSimulador");  
    
    	this.agregaHijo(document, domNodo, "AmortizacionID", simCredBean.getAmortizacionID());
    	this.agregaHijo(document, domNodo, "FechaInicio",simCredBean.getFechaInicio());
    	this.agregaHijo(document, domNodo, "FechaVencim", simCredBean.getFechaVencim()); 
    	this.agregaHijo(document, domNodo, "FechaExigible", simCredBean.getFechaExigible()); 
    	this.agregaHijo(document, domNodo, "Capital", simCredBean.getCapital()); 

    	this.agregaHijo(document, domNodo, "Interes", simCredBean.getInteres()); 
    	this.agregaHijo(document, domNodo, "IvaInteres", simCredBean.getIvaInteres()); 
    	this.agregaHijo(document, domNodo, "TotalPago", simCredBean.getTotalPago()); 
    	this.agregaHijo(document, domNodo, "SaldoInsoluto", simCredBean.getSaldoInsoluto()); 
    	this.agregaHijo(document, domNodo, "Dias", simCredBean.getDias()); 

    	this.agregaHijo(document, domNodo, "CuotasCapital", simCredBean.getCuotasCapital()); 
    	this.agregaHijo(document, domNodo, "NumTransaccion", simCredBean.getNumTransaccion()); 
    	this.agregaHijo(document, domNodo, "Cat", simCredBean.getCat()); 
    	this.agregaHijo(document, domNodo, "FecUltAmor", simCredBean.getFecUltAmor()); 
    	this.agregaHijo(document, domNodo, "FecInicioAmor", simCredBean.getFecInicioAmor()); 

    	this.agregaHijo(document, domNodo, "MontoCuota", simCredBean.getMontoCuota()); 
    	this.agregaHijo(document, domNodo, "TotalCap", simCredBean.getTotalCap()); 
    	this.agregaHijo(document, domNodo, "TotalInteres", simCredBean.getTotalInteres()); 
    	this.agregaHijo(document, domNodo, "TotalIva", simCredBean.getTotalIva()); 
    	this.agregaHijo(document, domNodo, "CobraSeguroCuota", simCredBean.getCobraSeguroCuota()); 

    	this.agregaHijo(document, domNodo, "MontoSeguroCuota", simCredBean.getMontoSeguroCuota()); 
    	this.agregaHijo(document, domNodo, "IvaSeguroCuota", simCredBean.getiVASeguroCuota()); 
    	this.agregaHijo(document, domNodo, "TotalSeguroCuota", simCredBean.getTotalSeguroCuota()); 
    	this.agregaHijo(document, domNodo, "TotalIVASeguroCuota", simCredBean.getTotalIVASeguroCuota()); 
    	return domNodo;  
    }
    
    /* agrega nodo al xml */
    private void agregaHijo(Document document, Element padre, String tag, String valor){  
        Element domNombre = document.createElement(tag);  
        Text    domValor  = document.createTextNode(valor);  
        domNombre.appendChild(domValor);  
        padre.appendChild(domNombre);  
    }


	public VbcSimuladorCreditoServicio getVbcSimuladorCreditoServicio() {
		return vbcSimuladorCreditoServicio;
	}


	public void setVbcSimuladorCreditoServicio(
			VbcSimuladorCreditoServicio vbcSimuladorCreditoServicio) {
		this.vbcSimuladorCreditoServicio = vbcSimuladorCreditoServicio;
	}


	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}


	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

}

