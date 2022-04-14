package operacionesPDA.servicioweb;

import java.util.Iterator;
import java.util.List;

import org.springframework.ws.server.endpoint.AbstractDomPayloadEndpoint;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

import credito.bean.CreditosBean;
import operacionesPDA.beanWS.request.SP_PDA_Creditos_DescargaRequest;
import operacionesPDA.beanWS.response.SP_PDA_Creditos_DescargaResponse;
import operacionesPDA.servicio.SP_PDA_Creditos_Descarga3ReyesServicio;
//import operacionesPDA.servicio.SP_PDA_Creditos3ReyesServicio;
import operacionesPDA.servicio.SP_PDA_CreditosServicio;
import soporte.PropiedadesSAFIBean;
import soporte.bean.ParametrosCajaBean;
import soporte.servicio.ParametrosCajaServicio;

 
public class SP_PDA_Creditos_DescargaWS  extends AbstractDomPayloadEndpoint {
	SP_PDA_CreditosServicio sp_PDA_CreditosServicio= null;
    SP_PDA_Creditos_Descarga3ReyesServicio sP_PDA_Creditos_Descarga3ReyesServicio= null;
	ParametrosCajaServicio parametrosCajaServicio = null;
	String varYanga = "YANGA";
	String var3Reyes = "3 REYES";

	public static final String NAMESPACE = "http://safisrv/ws/schemas";
	
	protected Element invokeInternal(Element domRequest, Document document) throws Exception{   
		SP_PDA_Creditos_DescargaRequest  request     = this.xmlToInfoRequest(domRequest);  
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
		sp_PDA_CreditosServicio.getSp_PDA_CreditosDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
		sP_PDA_Creditos_Descarga3ReyesServicio.getsP_PDA_Creditos_Descarga3ReyesDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);

		SP_PDA_Creditos_DescargaResponse response = new SP_PDA_Creditos_DescargaResponse();
		
		ParametrosCajaBean parametrosCajaBean = new ParametrosCajaBean();

		parametrosCajaBean.setEmpresaID("1");
		parametrosCajaBean = parametrosCajaServicio.consulta(ParametrosCajaServicio.Enum_Con_ParametrosCaja.paramVersionWS, parametrosCajaBean);
		
		if(parametrosCajaBean.getVersionWS().equals(varYanga)){
			response  = (SP_PDA_Creditos_DescargaResponse) sp_PDA_CreditosServicio.listaCreditosWS(request);
		}
		else{

		if(parametrosCajaBean.getVersionWS().equals(var3Reyes)){
			response  = (SP_PDA_Creditos_DescargaResponse) sP_PDA_Creditos_Descarga3ReyesServicio.listaCreditosWS(request);

			}
		}
	 	   	
	    Element  domResponse = this.responseToXml(response, document);   
	    
	    return domResponse;  
		}
	
	 /* convierte a xml el request */
    private SP_PDA_Creditos_DescargaRequest xmlToInfoRequest(Element request){         
    	SP_PDA_Creditos_DescargaRequest xmlInfoRequest  = new SP_PDA_Creditos_DescargaRequest();  
    	try{
    		// recupera el elemento llamado "Id_Segmento"
            Element elementoNombre = (Element) request.getElementsByTagNameNS(NAMESPACE, "Id_Segmento").item(0);
            // obtiene el texto contenido
            String solicitudString = elementoNombre.getTextContent();
            xmlInfoRequest.setId_Segmento(solicitudString);
    	}
          catch(Exception e){
        	  e.printStackTrace();
          }
        return xmlInfoRequest; 
    }
    
  /* convierte a xml el response */
    private Element responseToXml(SP_PDA_Creditos_DescargaResponse response, Document document){  
        Element     root    = document.createElementNS("http://safisrv/ws/schemas", "DescargarCreditosResponse");  
        List<CreditosBean> creditos  = response.getCreditos();
          
        if (creditos != null){  
            Iterator<CreditosBean> iterador = null;  
            CreditosBean credito     = null;  
            Element    domSegmento  = null;            
              
            iterador = creditos.iterator();  
            while (iterador.hasNext()){  
            	credito    = iterador.next();  
            	domSegmento = this.mapeoXml(document, credito);  
                root.appendChild(domSegmento);
                
            }
            
        }  
          
        return root;  
    }

    /* Crea la estructura del nodo en el xml */
    private Element mapeoXml(Document document, CreditosBean creditoBean){  
        Element domNodo = document.createElement("Credito");  
                       
        this.agregaHijo(document, domNodo, "Num_Cta", creditoBean.getCuentaID());  
        this.agregaHijo(document, domNodo, "Num_Socio",  creditoBean.getClienteID());          
        this.agregaHijo(document, domNodo, "Id_Cuenta", creditoBean.getCreditoID());  
        this.agregaHijo(document, domNodo, "Saldo",  creditoBean.getAdeudoTotal());
        this.agregaHijo(document, domNodo, "PagoMinimo", creditoBean.getPagoExigible());  
        this.agregaHijo(document, domNodo, "PagoMensual",  creditoBean.getMontoExigible());
        this.agregaHijo(document, domNodo, "PagoMaximo", creditoBean.getSaldCapVenNoExi());  
        this.agregaHijo(document, domNodo, "GastosCobranza",  creditoBean.getSaldoComFaltPago());
        this.agregaHijo(document, domNodo, "FechaUltAbono", creditoBean.getFechaUltAbonoCre());  
        this.agregaHijo(document, domNodo, "Estatus",  creditoBean.getEstatus());
        this.agregaHijo(document, domNodo, "IntMorPagado", creditoBean.getIntOrdDevengado());
        this.agregaHijo(document, domNodo, "IntOrdPagado", creditoBean.getIntMorDevengado());
        this.agregaHijo(document, domNodo, "IvaIntMor", creditoBean.getSaldoIVAMorato());
        this.agregaHijo(document, domNodo, "IvaIntOrd", creditoBean.getIVAInteres());

        Element domNodoHijo = document.createElement("Parametros");  
        Element domNodoNieto = document.createElement("ParametroComponente"); 

        this.agregaHijo(document, domNodoNieto, "Campo",  "TasaInterés");
        this.agregaHijo(document, domNodoNieto, "Valor",  creditoBean.getTasaFija());

        domNodoHijo.appendChild(domNodoNieto);
        domNodo.appendChild(domNodoHijo);  
                  
		return domNodo;  
    }
    
    /* agrega nodo al xml */
    private void agregaHijo(Document document, Element padre, String tag, String valor){  
        Element domNombre = document.createElement(tag);  
        Text    domValor  = document.createTextNode(valor);  
          
        domNombre.appendChild(domValor);  
        padre.appendChild(domNombre);  
    }
      
  
 // Set y get del Servicio
    

	public ParametrosCajaServicio getParametrosCajaServicio() {
		return parametrosCajaServicio;
	}

	public void setParametrosCajaServicio(
			ParametrosCajaServicio parametrosCajaServicio) {
		this.parametrosCajaServicio = parametrosCajaServicio;
	}
	
	public SP_PDA_CreditosServicio getSp_PDA_CreditosServicio() {
		return sp_PDA_CreditosServicio;
	}

	public void setSp_PDA_CreditosServicio(
			SP_PDA_CreditosServicio sp_PDA_CreditosServicio) {
		this.sp_PDA_CreditosServicio = sp_PDA_CreditosServicio;
	}

	public SP_PDA_Creditos_Descarga3ReyesServicio getsP_PDA_Creditos_Descarga3ReyesServicio() {
		return sP_PDA_Creditos_Descarga3ReyesServicio;
	}

	public void setsP_PDA_Creditos_Descarga3ReyesServicio(
			SP_PDA_Creditos_Descarga3ReyesServicio sP_PDA_Creditos_Descarga3ReyesServicio) {
		this.sP_PDA_Creditos_Descarga3ReyesServicio = sP_PDA_Creditos_Descarga3ReyesServicio;
	}

}

