package ventanilla.servicio;

import java.util.Iterator;
import java.util.List;


import ventanilla.bean.CatalogoServBean;
import ventanilla.beanWS.request.ConsultaListaServRequest;
import ventanilla.beanWS.request.ConsultaMontoServRequest;
import ventanilla.beanWS.response.ConsultaListaServResponse;
import ventanilla.dao.CatalogoServDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class CatalogoServServicio extends BaseServicio {
	CatalogoServDAO catalogoServDAO = null;
	String codigo="";
	public static interface Enum_Tra_CatalogoServ {
		int alta = 1;
		int modificacion = 2;
	}
	public static interface Enum_Con_CatalogoServ {
		int principal = 1;
		int montos	  = 2;
	}
	public static interface Enum_Lis_CatalogoServ {
		int principal	= 1;
		int combo		=2;
		int requiereCliente=4;
		int tiposServicioGral=5;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	CatalogoServBean catalogoServBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_CatalogoServ.alta:		
				mensaje = catalogoServDAO.altaServicio(catalogoServBean);								
				break;			
			case Enum_Tra_CatalogoServ.modificacion:		
				mensaje = catalogoServDAO.modificaServicio(catalogoServBean);								
				break;		
		}
		return mensaje;
	}
	
	public CatalogoServBean consulta(int tipoConsulta, CatalogoServBean catalogoServBean){
		CatalogoServBean catalogoServ = null;
		switch (tipoConsulta) {
			case Enum_Con_CatalogoServ.principal:	
				catalogoServ = catalogoServDAO.consultaPrincipalServicios(catalogoServBean,tipoConsulta);
				break;				
		}
		return catalogoServ;
	}


	public List lista(int tipoLista, CatalogoServBean catalogoServBean){		
		List listaSolicitud = null;
		switch (tipoLista) {
		case Enum_Lis_CatalogoServ.principal:		
			listaSolicitud = catalogoServDAO.listaServicios(tipoLista,catalogoServBean);				
			break;			
		case Enum_Lis_CatalogoServ.requiereCliente:		
			listaSolicitud = catalogoServDAO.listaServicios(tipoLista,catalogoServBean);				
			break;			
		}		
		return listaSolicitud;
	}			
	
	//-----Lista Combo-------
	public Object[] listaCombo(int tipoLista, CatalogoServBean catalogoServBean){
		List listaCatalogoServ = null;	

		switch (tipoLista) {
			case Enum_Lis_CatalogoServ.combo:
			case Enum_Lis_CatalogoServ.tiposServicioGral:	
				listaCatalogoServ=  catalogoServDAO.listaCombo(tipoLista,catalogoServBean);				
				break;		
		}		
		return listaCatalogoServ.toArray();
	}
	
	public Object listaCatServiciosWS(ConsultaListaServRequest consultaListaServRequest ){
		Object obj= null;
		String cadena = "";
		codigo = "01";
		ConsultaListaServResponse respuestaLista = new ConsultaListaServResponse();
		List<ConsultaListaServResponse> listaDescuentosNomina = catalogoServDAO.listaComboWS(consultaListaServRequest);
		if (listaDescuentosNomina != null ){
			cadena = transformArray(listaDescuentosNomina);
		}
				respuestaLista.setListaServicio(cadena);				
				obj=(Object)respuestaLista;
				return obj;
		}	

	// Separador de campos y registros de la lista de Combo de Catalogo de Servicios
	private String transformArray(List listaServicios){
        String resultadoServicios = "";
        String separadorCampos = "[";
 		String separadorRegistro = "]";
 		
 		CatalogoServBean catalogoServBean;
        if(listaServicios!= null){   
            Iterator<CatalogoServBean> it = listaServicios.iterator();
            while(it.hasNext()){    
            	catalogoServBean = (CatalogoServBean)it.next();             	
            	resultadoServicios += catalogoServBean.getCatalogoServID()+separadorCampos+
            			catalogoServBean.getNombreServicio()+separadorRegistro;
            }
        }
        System.out.println("resultadoServicios "+resultadoServicios);
 		if(resultadoServicios.length() !=0){
 			resultadoServicios= resultadoServicios.substring(0,resultadoServicios.length()-1);
 		}
        return resultadoServicios;
    }

	public CatalogoServBean montoCatServiciosWS(int tipoConsulta,ConsultaMontoServRequest consultaMontoServRequest ){
		CatalogoServBean catalogoBean=null;
		switch(tipoConsulta){
				case Enum_Con_CatalogoServ.montos:
					catalogoBean=catalogoServDAO.montoServicioWS(tipoConsulta, consultaMontoServRequest);
				break;
		}
		return catalogoBean;
	}	
		
	//--------- getter y setter 	-------------
	public CatalogoServDAO getCatalogoServDAO() {
		return catalogoServDAO;
	}

	public void setCatalogoServDAO(CatalogoServDAO catalogoServDAO) {
		this.catalogoServDAO = catalogoServDAO;
	}
	
	

}
