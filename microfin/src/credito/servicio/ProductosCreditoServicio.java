 
package credito.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.Iterator;
import java.util.List;

import credito.bean.ProductosCreditoBean;
import credito.beanWS.request.ListaProdCreditoRequest;
import credito.beanWS.response.ListaProdCreditoResponse;
import credito.dao.ProductosCreditoDAO;


public class ProductosCreditoServicio extends BaseServicio {

	
	//---------- Variables ------------------------------------------------------------------------
	ProductosCreditoDAO productosCreditoDAO = null;
	String codigo= "";
	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Con_ProductosCredito {
		int principal   = 1;
		int foranea   = 2;
		int grup		=4;
		int garantiaLiq = 5; // obtiene los datos de garantia liquida
		int existencia	= 6; // usando en alta de solicitud grupal ws sana tus finanzas
		int individuales = 7; //Consulta solo productos individuales
		int agropecuarios = 8;
		int consolidacion = 10;
	}
	public static interface Enum_Tra_ProductosCredito {
		int alta = 1;
		int modificacion = 2;
	}
	
	public static interface Enum_Lis_ProductosCredito {
		int principal   = 1;
		int comboProductos = 2;
		int altaCredi = 3;
		int altaLinea = 4;
		int reestructura = 5; // lista que muestra los productos de credito que permiten reestructura
		int listaProdCredWS =6; //lista de los productos de credito para el WS
		int listaCombo	= 7;
		int listaGrupales	= 8;
		int listaIndividuales	= 9;
		int listaAgropecuarios = 10;
		int listaProductos = 11;
		int listaProductosTodosCombo = 13;
		int listaProducNom = 12;
		int listaConsolidadoAgro = 14;
		int listaProductosActivos = 15;	// Lista de los productos de credito activos
		int listaComboProductosActivos = 16; // Lista combo de los productos de credito activos
		int ListaIndividualesActivos = 17; // Lista productos Individuales Activos
	}
	public static interface Enum_Con_ProdCreditoWS{
		int principal =1;
		int foranea = 2;
	}
	
	public ProductosCreditoServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ProductosCreditoBean clasificCredito){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_ProductosCredito.alta:
			mensaje = altaProducCred(clasificCredito);
			break;
		case Enum_Tra_ProductosCredito.modificacion:
			mensaje = modificaProducCred(clasificCredito);
			break;
		}

		return mensaje;
	}
	
	public MensajeTransaccionBean altaProducCred(ProductosCreditoBean productoCredito){
		MensajeTransaccionBean mensaje = null;
		mensaje = productosCreditoDAO.alta(productoCredito);		
		return mensaje;
	}

	public MensajeTransaccionBean modificaProducCred(ProductosCreditoBean productoCred){
		MensajeTransaccionBean mensaje = null;
		mensaje = productosCreditoDAO.modifica(productoCred);		
		return mensaje;
	}	
	
	public ProductosCreditoBean consulta(int tipoConsulta, ProductosCreditoBean productosCredito){
		ProductosCreditoBean productosCreditoBean = null;
		switch(tipoConsulta){
			case Enum_Con_ProductosCredito.foranea:
				productosCreditoBean = productosCreditoDAO.consultaForanea(productosCredito, Enum_Con_ProductosCredito.foranea);
			break;
			case Enum_Con_ProductosCredito.principal:
				productosCreditoBean = productosCreditoDAO.consultaPrincipal(productosCredito, tipoConsulta);
			case Enum_Con_ProductosCredito.agropecuarios:
				productosCreditoBean = productosCreditoDAO.consultaPrincipal(productosCredito, tipoConsulta);
			break;
			case Enum_Con_ProductosCredito.grup:
				productosCreditoBean = productosCreditoDAO.consultaGrupal(productosCredito, Enum_Con_ProductosCredito.grup);
			break;
			case Enum_Con_ProductosCredito.garantiaLiq:
				productosCreditoBean = productosCreditoDAO.consultaDatosGarantiaLiq(productosCredito, Enum_Con_ProductosCredito.garantiaLiq);
			break;
			case Enum_Con_ProductosCredito.existencia:
				productosCreditoBean = productosCreditoDAO.consultaExistencia(productosCredito, Enum_Con_ProductosCredito.existencia);
			break;
			case Enum_Con_ProductosCredito.individuales:
				productosCreditoBean = productosCreditoDAO.consultaPrincipal(productosCredito, Enum_Con_ProductosCredito.individuales);
			break;
			case Enum_Con_ProductosCredito.consolidacion:
				productosCreditoBean = productosCreditoDAO.consultaPrincipal(productosCredito, Enum_Con_ProductosCredito.consolidacion);
			break;
		}
		return productosCreditoBean;
	}
	
	public ProductosCreditoBean consultaBE(int tipoConsulta, ProductosCreditoBean productosCredito){
		ProductosCreditoBean productosCreditoBean = null;
		switch(tipoConsulta){
		case Enum_Con_ProductosCredito.principal:
			productosCreditoBean = productosCreditoDAO.consultaBanca(productosCredito, Enum_Con_ProdCreditoWS.principal);
		break;
		case Enum_Con_ProductosCredito.foranea:
			productosCreditoBean = productosCreditoDAO.consultaWS(productosCredito, Enum_Con_ProdCreditoWS.foranea);
		break;
		
	 }
	return productosCreditoBean;
	}

	
	public List lista(int tipoLista, ProductosCreditoBean productosCredito){
		List productosCreditoLista = null;

		switch (tipoLista) {
	        case  Enum_Lis_ProductosCredito.principal:
	        case  Enum_Lis_ProductosCredito.listaProductosActivos:
	        	productosCreditoLista = productosCreditoDAO.listaProductosCredito(productosCredito, tipoLista);
	        break;
	        case  Enum_Lis_ProductosCredito.altaCredi:
	        	productosCreditoLista = productosCreditoDAO.listaProductosAltaCred(productosCredito, tipoLista);
	        break;
	        case  Enum_Lis_ProductosCredito.altaLinea:
	        	productosCreditoLista = productosCreditoDAO.listaProductosAltaCred(productosCredito, tipoLista);
	        break;
	        case  Enum_Lis_ProductosCredito.reestructura:
	        	productosCreditoLista = productosCreditoDAO.listaProductosCreditoReestructura(productosCredito, tipoLista);
	        break;
	        case  Enum_Lis_ProductosCredito.listaGrupales:
	        	productosCreditoLista = productosCreditoDAO.listaProductosCredito(productosCredito, tipoLista);
	        break;
	        case  Enum_Lis_ProductosCredito.listaIndividuales:
	        case  Enum_Lis_ProductosCredito.ListaIndividualesActivos:
	        	productosCreditoLista = productosCreditoDAO.listaProductosCredito(productosCredito, tipoLista);
	        break;
	        case  Enum_Lis_ProductosCredito.listaAgropecuarios:
	        	productosCreditoLista = productosCreditoDAO.listaProductosCredito(productosCredito, tipoLista);
	        break;
	        case  Enum_Lis_ProductosCredito.listaConsolidadoAgro:
	        	productosCreditoLista = productosCreditoDAO.listaProductosCredito(productosCredito, tipoLista);
	        break;
		}
		return productosCreditoLista;
	}
	
	// listas para comboBox
					 
	public  Object[] listaCombo(int tipoLista) {
		List listaProductos = null;
		switch(tipoLista){
			case Enum_Lis_ProductosCredito.comboProductos: 
				listaProductos =  productosCreditoDAO.listaProductos(tipoLista);
				break;
			case Enum_Lis_ProductosCredito.listaCombo: 
				listaProductos =  productosCreditoDAO.listaProductos(tipoLista);
				break;
			case  Enum_Lis_ProductosCredito.listaAgropecuarios:
				listaProductos =  productosCreditoDAO.listaProductos(tipoLista);
		        break;
			case  Enum_Lis_ProductosCredito.listaProductos:
			case  Enum_Lis_ProductosCredito.listaComboProductosActivos:
				listaProductos =  productosCreditoDAO.listaProductos(tipoLista);
				break;
			case  Enum_Lis_ProductosCredito.listaProductosTodosCombo:
				listaProductos =  productosCreditoDAO.listaProductos(tipoLista);
		        break;
			case  Enum_Lis_ProductosCredito.listaProducNom:
				listaProductos =  productosCreditoDAO.listaProductosNomina(tipoLista);
		        break;
		        
		        
		}
		return listaProductos.toArray();	
	}
	// lista para el WS

  public Object listaProdCredWS(int tipoConsulta, ListaProdCreditoRequest productoRequest){
		Object obj= null;
		String cadena= "";
		codigo = "01";
		ListaProdCreditoResponse resultadoProducto=new ListaProdCreditoResponse();
		List<ListaProdCreditoResponse> lisProducto = productosCreditoDAO.listaProdCreditoWS(productoRequest,tipoConsulta);
		if (lisProducto != null ){
			cadena = transformArray(lisProducto);							
		}
		resultadoProducto.setListaProductosCredito(cadena);
		
		obj=(Object)resultadoProducto;
		
		return obj;
	}
	
	
	private String transformArray(List  listaProductos){
		String resultadoProducto = "";
	    String separadorCampos = "[";  
	    String separadorRegistros = "]";
 
	    ProductosCreditoBean productosBean;
	    if(listaProductos != null) {   
	        Iterator<ProductosCreditoBean> it = listaProductos.iterator();
	        while(it.hasNext()){    
	        	productosBean = (ProductosCreditoBean)it.next();
	        	resultadoProducto += productosBean.getProducCreditoID()+ separadorCampos +
	        			productosBean.getDescripcion() + separadorRegistros;
	        }
	    }
	    if(resultadoProducto.length() != 0){
	    	resultadoProducto = resultadoProducto.substring(0,resultadoProducto.length()-1);
	    }
	    return resultadoProducto;
    }

	//------------------ Geters y Seters ------------------------------------------------------	
	public void setProductosCreditoDAO(ProductosCreditoDAO productosCreditoDAO) {
		this.productosCreditoDAO = productosCreditoDAO;
	}

	public ProductosCreditoDAO getProductosCreditoDAO() {
		return productosCreditoDAO;
	}	
}
