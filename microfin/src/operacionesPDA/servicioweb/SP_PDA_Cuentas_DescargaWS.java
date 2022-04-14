package operacionesPDA.servicioweb;

import java.util.Iterator;
import java.util.List;

import operacionesPDA.beanWS.request.SP_PDA_Cuentas_DescargaRequest;
import operacionesPDA.beanWS.response.SP_PDA_Cuentas_DescargaResponse;
import operacionesPDA.servicio.SP_PDA_Cuentas_Descarga3ReyesServicio;
import operacionesPDA.servicio.SP_PDA_Cuentas_Descarga3ReyesServicio.Enum_Lis_CtaCreGrupoNoSoli;

import org.springframework.ws.server.endpoint.AbstractDomPayloadEndpoint;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

import soporte.PropiedadesSAFIBean;
import soporte.bean.ParametrosCajaBean;
import soporte.servicio.ParametrosCajaServicio;
import cuentas.bean.CuentasAhoBean;
import cuentas.servicio.CuentasAhoServicio;
import cuentas.servicio.CuentasAhoServicio.Enum_Lis_CtaCreGrupoNoSol;


public class SP_PDA_Cuentas_DescargaWS  extends AbstractDomPayloadEndpoint {
	CuentasAhoServicio cuentasAhoServicio = null;
	SP_PDA_Cuentas_Descarga3ReyesServicio sP_PDA_Cuentas_Descarga3ReyesServicio = null;
	ParametrosCajaServicio parametrosCajaServicio = null;
	String varYanga = "YANGA";
	String var3Reyes = "3 REYES";

	public SP_PDA_Cuentas_DescargaWS() {
		super();
		// TODO Auto-generated constructor stub
	}
	

    protected Element invokeInternal(Element domRequest, Document document) throws Exception {                   
    	SP_PDA_Cuentas_DescargaRequest request     = this.xmlToInfoRequest(domRequest);    
    	
    	String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
    	cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
    	sP_PDA_Cuentas_Descarga3ReyesServicio.getsP_PDA_Cuentas_Descarga3ReyesDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);

    	SP_PDA_Cuentas_DescargaResponse response   = null;
    	
    			ParametrosCajaBean parametrosCajaBean = new ParametrosCajaBean();
    	
    	parametrosCajaBean.setEmpresaID("1");
		parametrosCajaBean = parametrosCajaServicio.consulta(ParametrosCajaServicio.Enum_Con_ParametrosCaja.paramVersionWS, parametrosCajaBean);
		
		if(parametrosCajaBean.getVersionWS().equals(varYanga)){
			response  = (SP_PDA_Cuentas_DescargaResponse) cuentasAhoServicio.listaCuentasWS(Enum_Lis_CtaCreGrupoNoSol.cuentasws);
		}
		else{

		if(parametrosCajaBean.getVersionWS().equals(var3Reyes)){
			response  = (SP_PDA_Cuentas_DescargaResponse) sP_PDA_Cuentas_Descarga3ReyesServicio.listaCuentasWS(Enum_Lis_CtaCreGrupoNoSoli.cuentasws);

			}
		}
          
        Element  domResponse = this.responseToXml(response, document);            
        return domResponse;  
    }  

    /* convierte a xml el request */
    private SP_PDA_Cuentas_DescargaRequest xmlToInfoRequest(Element request){  
          
    	SP_PDA_Cuentas_DescargaRequest xmlInfoRequest = new SP_PDA_Cuentas_DescargaRequest();  
          
        return xmlInfoRequest;  
    }
    
    /* convierte a xml el response */
    private Element responseToXml(SP_PDA_Cuentas_DescargaResponse response, Document document){  
        Element     root    = document.createElementNS("http://safisrv/ws/schemas", "DescargarCuentasResponse");  
        List<CuentasAhoBean> cuentas  = response.getCuentas();  
          
        if (cuentas != null){  
            Iterator<CuentasAhoBean> iteCuentas = null;  
            CuentasAhoBean cuenta     = null;  
            Element    domCuenta  = null;  
              
            iteCuentas = cuentas.iterator();  
            while (iteCuentas.hasNext()){  
            	cuenta    = iteCuentas.next();  
            	domCuenta = this.mapeoXml(document, cuenta);  
                root.appendChild(domCuenta);  
            }  
        }  
          
        return root;  
    }
    
    /* Crea la estructura del nodo en el xml */
    private Element mapeoXml(Document document, CuentasAhoBean cuentaBean){  
        Element domNodo = document.createElement("Cuenta");  
          
        this.agregaHijo(document, domNodo, "Id_Cuenta", cuentaBean.getCuentaAhoID());  
        this.agregaHijo(document, domNodo, "NombreCta",  cuentaBean.getDescripcionTipoCta()); 
        this.agregaHijo(document, domNodo, "TipoCta",  cuentaBean.getTipoCuentaID()); 
        this.agregaHijo(document, domNodo, "SaldoMax",  cuentaBean.getSaldoMax()); 
        this.agregaHijo(document, domNodo, "SaldoMin",  cuentaBean.getSaldoMin()); 
        this.agregaHijo(document, domNodo, "PermiteAbo",  cuentaBean.getPermiteAbo()); 
          
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


	public SP_PDA_Cuentas_Descarga3ReyesServicio getsP_PDA_Cuentas_Descarga3ReyesServicio() {
		return sP_PDA_Cuentas_Descarga3ReyesServicio;
	}


	public void setsP_PDA_Cuentas_Descarga3ReyesServicio(
			SP_PDA_Cuentas_Descarga3ReyesServicio sP_PDA_Cuentas_Descarga3ReyesServicio) {
		this.sP_PDA_Cuentas_Descarga3ReyesServicio = sP_PDA_Cuentas_Descarga3ReyesServicio;
	}


	public ParametrosCajaServicio getParametrosCajaServicio() {
		return parametrosCajaServicio;
	}


	public void setParametrosCajaServicio(
			ParametrosCajaServicio parametrosCajaServicio) {
		this.parametrosCajaServicio = parametrosCajaServicio;
	}
	
}
