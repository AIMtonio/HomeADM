package operacionesPDA.servicioweb;

import herramientas.Constantes;

import java.util.Iterator;
import java.util.List;

import operacionesPDA.beanWS.request.SP_PDA_Ahorros_DescargaRequest;
import operacionesPDA.beanWS.response.SP_PDA_Ahorros_DescargaResponse;
import operacionesPDA.servicio.SP_PDA_Ahorros_Descarga3ReyesServicio;

import org.springframework.ws.server.endpoint.AbstractDomPayloadEndpoint;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

import soporte.PropiedadesSAFIBean;
import soporte.bean.ParametrosCajaBean;
import soporte.servicio.ParametrosCajaServicio;
import cuentas.bean.CuentasAhoBean;
import cuentas.servicio.CuentasAhoServicio;

public class SP_PDA_Ahorros_DescargaWS  extends AbstractDomPayloadEndpoint  {
	CuentasAhoServicio cuentasAhoServicio = null;
	SP_PDA_Ahorros_Descarga3ReyesServicio sp_PDA_Ahorros_Descarga3ReyesServicio= null;
	ParametrosCajaServicio parametrosCajaServicio = null;
	String varYanga = "YANGA";
	String var3Reyes = "3 REYES";

	public static final String NAMESPACE = "http://safisrv/ws/schemas";
		
		public SP_PDA_Ahorros_DescargaWS()  {
			super();
		}
		
		

	    protected Element invokeInternal(Element domRequest, Document document) throws Exception {                   
	    	SP_PDA_Ahorros_DescargaRequest request     = this.xmlToInfoRequest(domRequest);  
	    	String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
	    	cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
	    	sp_PDA_Ahorros_Descarga3ReyesServicio.getSp_PDA_Ahorro_Descarga3ReyesDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);

	    	SP_PDA_Ahorros_DescargaResponse response    =  new SP_PDA_Ahorros_DescargaResponse();
	      
	    	
	    	ParametrosCajaBean parametrosCajaBean = new ParametrosCajaBean();

			parametrosCajaBean.setEmpresaID("1");
			parametrosCajaBean = parametrosCajaServicio.consulta(ParametrosCajaServicio.Enum_Con_ParametrosCaja.paramVersionWS, parametrosCajaBean);
			
			if(parametrosCajaBean.getVersionWS().equals(varYanga)){
				response  = (SP_PDA_Ahorros_DescargaResponse) cuentasAhoServicio.listacuentasAhoWS(request); 
			}
			else{

			if(parametrosCajaBean.getVersionWS().equals(var3Reyes)){
				response  = (SP_PDA_Ahorros_DescargaResponse) sp_PDA_Ahorros_Descarga3ReyesServicio.listacuentasAhoWS(request);

				}
			}
	    	
	    	Element  domResponse = this.responseToXml(response, document);  
	        
	        return domResponse;  
	    }  

	    /* convierte a xml el request */
	    private SP_PDA_Ahorros_DescargaRequest xmlToInfoRequest(Element request){         
	   	
	    	String Id_Segmento ;
	    	SP_PDA_Ahorros_DescargaRequest xmlInfoRequest  = new SP_PDA_Ahorros_DescargaRequest();  
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
	    private Element responseToXml(SP_PDA_Ahorros_DescargaResponse response, Document document){  
	        Element     root    = document.createElementNS("http://safisrv/ws/schemas", "DescargarAhorrosResponse");  
	        List<CuentasAhoBean> ahorros  = response.getAhorros();  
	          
	        if (ahorros != null){  
	            Iterator<CuentasAhoBean> iteAhorros = null;  
	            CuentasAhoBean ahorro     = null;  
	            Element    domAhorro  = null;  
	              
	            iteAhorros = ahorros.iterator();  
	            while (iteAhorros.hasNext()){  
	            	ahorro    = iteAhorros.next();  
	            	domAhorro = this.mapeoXml(document, ahorro);  
	                root.appendChild(domAhorro);  
	            }  
	        }  
	          
	        return root;  
	    }
	    
	    /* Crea la estructura del nodo en el xml */
	    private Element mapeoXml(Document document, CuentasAhoBean segmentoBean){  
	        Element domNodo = document.createElement("Ahorro");  
	        
	        this.agregaHijo(document, domNodo, "Id_Cuenta", segmentoBean.getTipoCuentaID());  
	        this.agregaHijo(document, domNodo, "Num_Cta",  segmentoBean.getCuentaAhoID());  
	        this.agregaHijo(document, domNodo, "Num_Socio", segmentoBean.getClienteID());  
	        this.agregaHijo(document, domNodo, "SaldoDisp",  segmentoBean.getSaldoDispon());  
	        this.agregaHijo(document, domNodo, "SaldoTot", segmentoBean.getSaldo());  
	        this.agregaHijo(document, domNodo, "Parametros",  Constantes.STRING_VACIO);  
	          
	        return domNodo;  
	    }
	    
	    /* agrega nodo al xml */
	    private void agregaHijo(Document document, Element padre, String tag, String valor){  
	        Element domNombre = document.createElement(tag);  
	        Text    domValor  = document.createTextNode(valor);  
	          
	        domNombre.appendChild(domValor);  
	        padre.appendChild(domNombre);  
	    }


		public CuentasAhoServicio getCuentasAhoServicio() {
			return cuentasAhoServicio;
		}


		public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
			this.cuentasAhoServicio = cuentasAhoServicio;
		}



		public SP_PDA_Ahorros_Descarga3ReyesServicio getSp_PDA_Ahorros_Descarga3ReyesServicio() {
			return sp_PDA_Ahorros_Descarga3ReyesServicio;
		}



		public void setSp_PDA_Ahorros_Descarga3ReyesServicio(
				SP_PDA_Ahorros_Descarga3ReyesServicio sp_PDA_Ahorros_Descarga3ReyesServicio) {
			this.sp_PDA_Ahorros_Descarga3ReyesServicio = sp_PDA_Ahorros_Descarga3ReyesServicio;
		}



		public ParametrosCajaServicio getParametrosCajaServicio() {
			return parametrosCajaServicio;
		}



		public void setParametrosCajaServicio(
				ParametrosCajaServicio parametrosCajaServicio) {
			this.parametrosCajaServicio = parametrosCajaServicio;
		}

   }
