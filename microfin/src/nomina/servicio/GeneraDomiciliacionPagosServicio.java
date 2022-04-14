
package nomina.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import nomina.bean.GeneraDomiciliacionPagosBean;
import nomina.dao.GeneraDomiciliacionPagosDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class GeneraDomiciliacionPagosServicio extends BaseServicio {
	GeneraDomiciliacionPagosDAO generaDomiciliacionPagosDAO= null;

	// -------------- Tipo Transaccion ----------------
	public static interface Enum_Tipo_Transaccion{
		int bajaDetalle     = 1;			// Elimina Detalles Domiciliacion de Pagos
		int generar     	= 2;			// Genera Informacion para el Layout
	}
	
	// -------------- Tipo Consulta ----------------
	public static interface Enum_Con_Domiciliacion{
		int conClientes			= 1;		// Consulta de Clientes de Nomina
		int conFolio			= 2;		// Consulta de Informacion Domiciliacion de Pagos por Folio
		int conDomiciliaPagos	= 4;		// Consulta Domiciliacion de Pagos de Convenios de Nomina
		int conFolioDomicilia	= 6;		// Consulta para validar que el folio exista
	}
		
	// -------------- Tipo Lista ----------------
	public static interface Enum_Lis_Domiciliacion{
		int lisClientes		= 1;		// Lista de Clientes de Nomina
		int convenios		= 2;		// Lista de Convenios
		int domPagos		= 3;		// Lista Domiciliacion de Pagos
		int domPagosPag		= 4;		// Lista de Domiciliacion de Pagos Paginadas
		int busqueda		= 5;		// Busqueda de Domiciliacion de Pagos
		int layout			= 6;		// Lista para generar el layout
		int folioDomicilia	= 7;		// Lista de folios de la pantalla de consulta de folios
	}
	
	/**
	 * 
	 * @param tipoTransaccion : Generar Domiciliación de Pagos
	 * @param listaDomiciliacionPagos
	 * @return
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean) {
	 	MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tipo_Transaccion.generar:
			mensaje = generaDomiciliacionPagosDAO.generaDomiciliacionPagos(generaDomiciliacionPagosBean);
			break;
		}
		return mensaje;
	}

	/**
	 * 
	 * @param tipoConsulta : Consulta para generar Domiciliación de Pagos
	 * @param generaDomiciliacionPagosBean
	 * @return
	 */
	public GeneraDomiciliacionPagosBean consulta(int tipoConsulta, GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean){
		GeneraDomiciliacionPagosBean generaDomiciliacionPagos = null;
		switch (tipoConsulta) {
			case Enum_Con_Domiciliacion.conClientes:
				generaDomiciliacionPagos = generaDomiciliacionPagosDAO.consultaClientes(tipoConsulta, generaDomiciliacionPagosBean);
			break;	
			case Enum_Con_Domiciliacion.conFolio:
				generaDomiciliacionPagos = generaDomiciliacionPagosDAO.consultaFolio(tipoConsulta, generaDomiciliacionPagosBean);
			break;
			case Enum_Con_Domiciliacion.conDomiciliaPagos:
				generaDomiciliacionPagos = generaDomiciliacionPagosDAO.consultaDomiciliaPagos(tipoConsulta, generaDomiciliacionPagosBean);
			break;
			case Enum_Con_Domiciliacion.conFolioDomicilia:
				generaDomiciliacionPagos = generaDomiciliacionPagosDAO.consultaFolioDomicilia(tipoConsulta, generaDomiciliacionPagosBean);
			break;
		}
		return generaDomiciliacionPagos;
	}
	
	/**
	 * 
	 * @param tipoLista : Lista para generar Domiciliación de Pagos
	 * @param generaDomiciliacionPagosBean
	 * @return
	 */
	public List lista(int tipoLista, GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean){
		List domiciliacionPagosLista = null;
		 switch (tipoLista) {
		 	case  Enum_Lis_Domiciliacion.lisClientes:          
		       	domiciliacionPagosLista = generaDomiciliacionPagosDAO.listaClientes(generaDomiciliacionPagosBean, tipoLista);
		    break;
		    case  Enum_Lis_Domiciliacion.domPagos:          
		       	domiciliacionPagosLista = generaDomiciliacionPagosDAO.listaDomiciliacionPagos(generaDomiciliacionPagosBean, tipoLista);
		    break;
		    case  Enum_Lis_Domiciliacion.domPagosPag:          
		       	domiciliacionPagosLista = generaDomiciliacionPagosDAO.listaDomiciliacionPagosPag(generaDomiciliacionPagosBean, tipoLista);
		    break;
		    case  Enum_Lis_Domiciliacion.busqueda:          
		       	domiciliacionPagosLista = generaDomiciliacionPagosDAO.listaBusqueda(generaDomiciliacionPagosBean, tipoLista);
		    break;
		    case Enum_Lis_Domiciliacion.folioDomicilia:
		    	domiciliacionPagosLista = generaDomiciliacionPagosDAO.listaFolioDomicilia(generaDomiciliacionPagosBean, tipoLista);
		    break;
		}
		return domiciliacionPagosLista;
	}
	
	/**
	 * 
	 * @param tipoLista : Lista de Convenios de las Empresas de Nomina 
	 * @param generaDomiciliacionPagosBean
	 * @return
	 */
	public  Object[] listaCombo(int tipoLista,GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean) {
		List listaConvenios = null;
		switch(tipoLista){
			case (Enum_Lis_Domiciliacion.convenios): 
				listaConvenios =  generaDomiciliacionPagosDAO.listaConveniosNomina(generaDomiciliacionPagosBean,tipoLista);
			break;
		}
		
		return listaConvenios.toArray();		
	}
	
	
	
	public List listaLayoutDomPagos(String folio,int numLista) {
		List listaConvenios = null;
		
		listaConvenios =  generaDomiciliacionPagosDAO.listaLayoutDomPagos(folio,numLista);

		return listaConvenios;		
	}
	
	public void generaLayout(List generaDomiciliacionPagosBean, long consecutivo,HttpServletResponse response){
		generaDomiciliacionPagosDAO.generaLayout(generaDomiciliacionPagosBean, consecutivo, response);
	}
	
	/**
	 * 
	 * @param tipoBaja : Elimina Detalles de Domiciliación de Pagos
	 * @param generaDomiciliacionPagosBean
	 * @return
	 */
	public MensajeTransaccionBean bajaDomiciliacionPagos(int tipoBaja,GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean){
		MensajeTransaccionBean mensaje = null;
		try{
			switch (tipoBaja) {
			case Enum_Tipo_Transaccion.bajaDetalle:		
				mensaje = generaDomiciliacionPagosDAO.bajaDomiciliacionPagos(generaDomiciliacionPagosBean,tipoBaja);		
				break;
			case Enum_Tipo_Transaccion.generar:		
				mensaje = generaDomiciliacionPagosDAO.eliminaDomiciliacionPagos(generaDomiciliacionPagosBean,tipoBaja);		
				break;
		}
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Baja de Domiciliación de Pagos.", e);
		}
		
		return mensaje;
	}

	// ============ GETTER  & SETTER ============== //

	public GeneraDomiciliacionPagosDAO getGeneraDomiciliacionPagosDAO() {
		return generaDomiciliacionPagosDAO;
	}

	public void setGeneraDomiciliacionPagosDAO(GeneraDomiciliacionPagosDAO generaDomiciliacionPagosDAO) {
		this.generaDomiciliacionPagosDAO = generaDomiciliacionPagosDAO;
	}


}