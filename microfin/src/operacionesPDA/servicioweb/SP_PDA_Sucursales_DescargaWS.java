package operacionesPDA.servicioweb;

import java.util.Iterator;
import java.util.List;

import operacionesPDA.beanWS.request.SP_PDA_Sucursales_DescargaRequest;
import operacionesPDA.beanWS.response.SP_PDA_Sucursales_DescargaResponse;

import org.springframework.ws.server.endpoint.AbstractDomPayloadEndpoint;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

import soporte.PropiedadesSAFIBean;
import soporte.bean.SucursalesBean;
import soporte.servicio.SucursalesServicio;
import soporte.servicio.SucursalesServicio.Enum_Lis_Sucursal;

public class SP_PDA_Sucursales_DescargaWS extends AbstractDomPayloadEndpoint  {
	SucursalesServicio sucursalesServicio = null;
	
	public SP_PDA_Sucursales_DescargaWS() {
		super();
	}
	
	
    protected Element invokeInternal(Element domRequest, Document document) throws Exception {                   
    	SP_PDA_Sucursales_DescargaRequest  request     = this.xmlToInfoRequest(domRequest);
    	String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
    	sucursalesServicio.getSucursalesDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
    	SP_PDA_Sucursales_DescargaResponse response    = (SP_PDA_Sucursales_DescargaResponse) sucursalesServicio.listaSucursalesWS(Enum_Lis_Sucursal.sucursalesWS);
    	
          
        Element  domResponse = this.responseToXml(response, document);            
        return domResponse;  
    }  

    /* convierte a xml el request */
    private SP_PDA_Sucursales_DescargaRequest xmlToInfoRequest(Element request){  
          
    	SP_PDA_Sucursales_DescargaRequest xmlInfoRequest = new SP_PDA_Sucursales_DescargaRequest();  
          
        return xmlInfoRequest;  
    }
    
    /* convierte a xml el response */
    private Element responseToXml(SP_PDA_Sucursales_DescargaResponse response, Document document){  
        Element     root    = document.createElementNS("http://safisrv/ws/schemas", "DescargarSucursalesResponse");  
        List<SucursalesBean> sucursales  = response.getSucursales();  
          
        if (sucursales != null){  
            Iterator<SucursalesBean> iteSucursales = null;  
            SucursalesBean           sucursal     = null;  
            Element         domSucursal  = null;  
              
            iteSucursales = sucursales.iterator();  
            while (iteSucursales.hasNext()){  
            	sucursal    = iteSucursales.next();  
                domSucursal = this.mapeoXml(document, sucursal);  
                root.appendChild(domSucursal);  
            }  
        }  
          
        return root;  
    }
    
    /* Crea la estructura del nodo en el xml */
    private Element mapeoXml(Document document, SucursalesBean sucursalBean){  
        Element domNodo = document.createElement("Sucursal");  
          
        this.agregaHijo(document, domNodo, "Id_Sucursal", sucursalBean.getSucursalID());  
        this.agregaHijo(document, domNodo, "NombreSuc",  sucursalBean.getNombreSucurs());   
          
        return domNodo;  
    }
    
    /* agrega nodo al xml */
    private void agregaHijo(Document document, Element padre, String tag, String valor){  
        Element domNombre = document.createElement(tag);  
        Text    domValor  = document.createTextNode(valor);  
          
        domNombre.appendChild(domValor);  
        padre.appendChild(domNombre);  
    }  

    
	public SucursalesServicio getSucursalesServicio() {
		return sucursalesServicio;
	}
	public void setSucursalesServicio(SucursalesServicio sucursalesServicio) {
		this.sucursalesServicio = sucursalesServicio;
	}

}
