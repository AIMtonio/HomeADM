package operacionesCRCB.servicioweb;

import herramientas.Constantes;

import java.util.Iterator;
import java.util.List;


import operacionesCRCB.bean.ConMovimientosCuentaBean;
import operacionesCRCB.beanWS.request.ConMovimientosCuentaRequest;
import operacionesCRCB.beanWS.response.ConMovimientosCuentaResponse;
import operacionesCRCB.beanWS.validacion.ConMovimientosCuentaValidacion;
import operacionesCRCB.servicio.ConMovimientosCuentaServicio;
import operacionesCRCB.servicio.ConMovimientosCuentaServicio.Enum_Lis_Cuenta;

import org.springframework.ws.server.endpoint.AbstractDomPayloadEndpoint;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

public class CrcbConMovimientosCuentaWS  extends AbstractDomPayloadEndpoint {
	
	ConMovimientosCuentaServicio conMovimientosCuentaServicio = null;

	
    public static final String NAMESPACE = "http://safisrv/ws/schemas";
                                
    public CrcbConMovimientosCuentaWS() {
        super();
        // TODO Auto-generated constructor stub
    }   

    protected Element invokeInternal(Element domRequest, Document document) throws Exception {   

        ConMovimientosCuentaRequest request     = this.xmlToInfoRequest(domRequest);
         
        ConMovimientosCuentaResponse response   = new ConMovimientosCuentaResponse();   
        ConMovimientosCuentaResponse responseLista   = new ConMovimientosCuentaResponse();   
        		
        ConMovimientosCuentaValidacion conMovimientosCuentaValidacion = new ConMovimientosCuentaValidacion();

        response = conMovimientosCuentaValidacion.isRequestValid(request); 
        
    	Element  domResponse = null;
        if(response.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
        	request.asignaParametrosAud(conMovimientosCuentaServicio.getConMovimientosCuentaDAO().getParametrosAuditoriaBean());

        	// Consulta de Saldos de la Cuenta
        	response = conMovimientosCuentaServicio.consultaSaldoCuenta(request);   
        	
        	if(response.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
	        	// Lista de Movimientos de la Cuenta
	        	responseLista = (ConMovimientosCuentaResponse) conMovimientosCuentaServicio.listaMovimientoCtaWS(Enum_Lis_Cuenta.movimientoCtas,request);
	        	
	        	response.setMovimientosCuenta(responseLista.getMovimientosCuenta());
        	}
            domResponse = this.responseToXml(response, document);  
            
        }else{
            domResponse = respuestaValidacion(response, document);
        }
        return domResponse;  
    }  

    
    private Element respuestaValidacion(ConMovimientosCuentaResponse response, Document document){  
        Element     root    = document.createElementNS("http://safisrv/ws/schemas", "ConMovimientosCuentaResponse");   
        Element domCod = document.createElement("CodigoRespuesta");  
        Element domMen = document.createElement("MensajeRespuesta"); 
        
        domCod.appendChild(document.createTextNode(response.getCodigoRespuesta()));
        domMen.appendChild(document.createTextNode(response.getMensajeRespuesta()));       
                
        root.appendChild(domCod);
        root.appendChild(domMen);
          
        return root;  
    }

    /* Convierte a xml el request */
    private ConMovimientosCuentaRequest xmlToInfoRequest(Element request){           
        ConMovimientosCuentaRequest xmlInfoRequest = new ConMovimientosCuentaRequest();  
        try{
            
            Element elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "CuentaAhoID").item(0);

            String cuentaAhoID= elementoNombre.getTextContent();
            xmlInfoRequest.setCuentaAhoID(cuentaAhoID);
            
            elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "Anio").item(0);
            xmlInfoRequest.setAnio(elementoNombre.getTextContent());
            
            elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "Mes").item(0);
            xmlInfoRequest.setMes(elementoNombre.getTextContent());
            
        }catch(Exception e){
            e.printStackTrace();
        }
        return xmlInfoRequest; 
    }
    
    /* Convierte a xml el response */
    private Element responseToXml(ConMovimientosCuentaResponse response, Document document){  
        Element     root    = document.createElementNS("http://safisrv/ws/schemas", "ConMovimientosCuentaResponse");   
        Element domCodigoRespuesta = document.createElement("CodigoRespuesta");  
        Element domMensajeRespuesta = document.createElement("MensajeRespuesta"); 
        Element domSaldoInicialMes = document.createElement("SaldoInicialMes"); 
        Element domAbonosMes = document.createElement("AbonosMes"); 
        Element domCargosMes = document.createElement("CargosMes"); 
        Element domSaldoDisponible = document.createElement("SaldoDisponible"); 
        
        List<ConMovimientosCuentaBean> amortiBean  = response.getMovimientosCuenta();  
        
        domCodigoRespuesta.appendChild(document.createTextNode(response.getCodigoRespuesta()));
        domMensajeRespuesta.appendChild(document.createTextNode(response.getMensajeRespuesta()));
        domSaldoInicialMes.appendChild(document.createTextNode(response.getSaldoInicialMes()));
        domAbonosMes.appendChild(document.createTextNode(response.getAbonosMes()));
        domCargosMes.appendChild(document.createTextNode(response.getCargosMes()));
        domSaldoDisponible.appendChild(document.createTextNode(response.getSaldoDisponible()));
                
        root.appendChild(domCodigoRespuesta);
        root.appendChild(domMensajeRespuesta);
        root.appendChild(domSaldoInicialMes);
        root.appendChild(domAbonosMes);
        root.appendChild(domCargosMes);
        root.appendChild(domSaldoDisponible);

        if (amortiBean != null){  
           if (amortiBean.size() > 0  ){
               Iterator<ConMovimientosCuentaBean> iteDetSimCre = null;  

               ConMovimientosCuentaBean amortiWsBean = null;  
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
    private Element mapeoXml(Document document, ConMovimientosCuentaBean movCuenta){ 

        Element domNodo = document.createElement("MovimientoCuenta");   
        
        this.agregaHijo(document, domNodo, "Fecha", movCuenta.getFecha());
        this.agregaHijo(document, domNodo, "Descripcion", movCuenta.getDescripcion()); 
        this.agregaHijo(document, domNodo, "Naturaleza", movCuenta.getNaturaleza());
        this.agregaHijo(document, domNodo, "Referencia", movCuenta.getReferencia());
        this.agregaHijo(document, domNodo, "Monto", movCuenta.getMonto()); 
        this.agregaHijo(document, domNodo, "Saldo", movCuenta.getSaldo());
        return domNodo;  
    }
    
    /* Agrega nodo al xml */
    private void agregaHijo(Document document, Element padre, String tag, String valor){  
        Element domNombre = document.createElement(tag);  
        Text    domValor  = document.createTextNode(valor);  
        domNombre.appendChild(domValor);  
        padre.appendChild(domNombre);  
    }

    
    // ========== GETTER & SETTER ============
    
	public ConMovimientosCuentaServicio getConMovimientosCuentaServicio() {
		return conMovimientosCuentaServicio;
	}

	public void setConMovimientosCuentaServicio(
			ConMovimientosCuentaServicio conMovimientosCuentaServicio) {
		this.conMovimientosCuentaServicio = conMovimientosCuentaServicio;
	}
 }

