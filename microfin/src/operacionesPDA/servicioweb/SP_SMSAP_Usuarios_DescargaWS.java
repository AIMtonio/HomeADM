package operacionesPDA.servicioweb;

import java.util.Iterator;
import java.util.List;

import operacionesPDA.beanWS.request.SP_SMSAP_Usuarios_DescargaRequest;
import operacionesPDA.beanWS.response.SP_SMSAP_Usuarios_DescargaResponse;

import org.springframework.ws.server.endpoint.AbstractDomPayloadEndpoint;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

import soporte.PropiedadesSAFIBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;
import soporte.servicio.UsuarioServicio.Enum_Lis_Usuario;

public class SP_SMSAP_Usuarios_DescargaWS extends AbstractDomPayloadEndpoint{
	UsuarioServicio usuarioServicio = null;
	
	public SP_SMSAP_Usuarios_DescargaWS()  {
		super();
	}
	

    protected Element invokeInternal(Element domRequest, Document document) throws Exception {                   
    	SP_SMSAP_Usuarios_DescargaRequest  request     = this.xmlToInfoRequest(domRequest);
    	String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
    	usuarioServicio.getUsuarioDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
    	SP_SMSAP_Usuarios_DescargaResponse response    = (SP_SMSAP_Usuarios_DescargaResponse) usuarioServicio.listaUsuariosWS(Enum_Lis_Usuario.userFR_WS);
    	
          
        Element  domResponse = this.responseToXml(response, document);            
        return domResponse;  
    }  

    /* convierte a xml el request */
    private SP_SMSAP_Usuarios_DescargaRequest xmlToInfoRequest(Element request){  
          
    	SP_SMSAP_Usuarios_DescargaRequest xmlInfoRequest = new SP_SMSAP_Usuarios_DescargaRequest();  
          
        return xmlInfoRequest;  
    }
    
    /* convierte a xml el response */
    private Element responseToXml(SP_SMSAP_Usuarios_DescargaResponse response, Document document){  
        Element     root    = document.createElementNS("http://safisrv/ws/schemas", "DescargarUsuariosSMSAPResponse");  
        List<UsuarioBean> usuarios  = response.getUsuarios();  
          
        if (usuarios != null){  
            Iterator<UsuarioBean> iteUsuarios = null;  
            UsuarioBean usuario     = null;  
            Element    domUsuario  = null;  
              
            iteUsuarios = usuarios.iterator();  
            while (iteUsuarios.hasNext()){  
            	usuario    = iteUsuarios.next();  
            	domUsuario = this.mapeoXml(document, usuario);  
                root.appendChild(domUsuario);  
            }  
        }  
          
        return root;  
    }
    
    /* Crea la estructura del nodo en el xml */
    private Element mapeoXml(Document document, UsuarioBean usuarioBean){  
        Element domNodo = document.createElement("Usuario");  
          
        this.agregaHijo(document, domNodo, "Id_Usuario", usuarioBean.getUsuarioID());  
        this.agregaHijo(document, domNodo, "Usuario",  usuarioBean.getNombreCompleto());   
          
        return domNodo;  
    }
    
    /* agrega nodo al xml */
    private void agregaHijo(Document document, Element padre, String tag, String valor){  
        Element domNombre = document.createElement(tag);  
        Text    domValor  = document.createTextNode(valor);  
          
        domNombre.appendChild(domValor);  
        padre.appendChild(domNombre);  
    }  

	

	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}
}
