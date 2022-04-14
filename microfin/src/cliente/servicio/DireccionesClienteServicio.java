package cliente.servicio;
import java.io.ByteArrayOutputStream;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
 
import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import cliente.BeanWS.Request.ListaDireccionClienteRequest;
import cliente.BeanWS.Response.ListaDireccionClienteResponse;
import cliente.bean.ClienteBean;
import cliente.bean.DireccionesClienteBean;
import cliente.bean.ReporteClienteLocMarginadasBean;
import cliente.dao.DireccionesClienteDAO;

public class DireccionesClienteServicio extends BaseServicio {
	
	DireccionesClienteDAO direccionesClienteDAO = null;
	ParametrosSisServicio		parametrosSisServicio	= null;
	String codigo= "";

	public static interface Enum_Tra_DireccionesCliente {
		int alta = 1;
		int modificacion = 2;
		int elimina = 3;
		int actualiza =4;
		int modificacionWS =5;
	}

	public static interface Enum_Con_DireccionesCliente{
		int principal 	= 1;
		int foranea 	= 2;
		int oficialDirec= 3;
		int oficial 	= 4;
		int verOficial	= 5;
		int BC			= 6;
		int dirAval		= 7;
		int dirTrabajo	= 8;
		int dirCpTar	= 9;
		int fiscal		= 10;
		int verFiscal	= 11;
		int principalWS	= 12;
		int oficfondeo	= 15;
		int direcNumHab	= 16;
	}

	public static interface Enum_Lis_DireccionesCliente{
		int principal = 1;
		int listaDireccionWS = 2; // Lista Direcciones WS
	}
	public static interface Enum_Lis_ReporteClienteLocMarginadas {
		int cliLocMarginadas = 1;
	}
	
	public DireccionesClienteServicio(){
		super();
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, DireccionesClienteBean direccionesCliente){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_DireccionesCliente.alta:		
				mensaje = altaDireccion(direccionesCliente);				
				break;				
			case Enum_Tra_DireccionesCliente.modificacion:
				mensaje = modificaDireccion(direccionesCliente);				
				break;
			case Enum_Tra_DireccionesCliente.elimina:
				mensaje = bajaDireccion(direccionesCliente);				
				break;
			case Enum_Tra_DireccionesCliente.actualiza:
				mensaje = direccionesClienteDAO.actualizaCor(direccionesCliente,tipoTransaccion);			
				break;
			case Enum_Tra_DireccionesCliente.modificacionWS:
				mensaje = modificaDireccionWS(direccionesCliente);				
				break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean altaDireccion(DireccionesClienteBean direccionesCliente){
		MensajeTransaccionBean mensaje = null;
		mensaje = direccionesClienteDAO.alta(direccionesCliente);		
		return mensaje;
	}

	public MensajeTransaccionBean modificaDireccion(DireccionesClienteBean direccionesCliente){
		MensajeTransaccionBean mensaje = null;
		mensaje = direccionesClienteDAO.modifica(direccionesCliente);	
		
		ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
		parametrosSisBean.setEmpresaID("1");
		parametrosSisBean = parametrosSisServicio.consulta(1, parametrosSisBean);
		
		if(mensaje.getNumero() == 0 ) {
			if(parametrosSisBean.getReplicaAct().equalsIgnoreCase("S")) {
				mensaje = direccionesClienteDAO.modificaReplica(direccionesCliente, parametrosSisBean.getOrigenReplica());
			}
		}
		
		
		return mensaje;
	}
	
	public MensajeTransaccionBean modificaDireccionWS(DireccionesClienteBean direccionesCliente){
		MensajeTransaccionBean mensaje = null;
		mensaje = direccionesClienteDAO.modificaWS(direccionesCliente);		
		return mensaje;
	}
	
	public MensajeTransaccionBean bajaDireccion(DireccionesClienteBean direccionesCliente){
		MensajeTransaccionBean mensaje = null;
		mensaje = direccionesClienteDAO.baja(direccionesCliente);		
		return mensaje;
	}
	
	
	public DireccionesClienteBean consulta(int tipoConsulta,DireccionesClienteBean direccion){
		DireccionesClienteBean direccionesCliente = null;
		switch (tipoConsulta) {
			case Enum_Con_DireccionesCliente.principal:		
				direccionesCliente = direccionesClienteDAO.consultaPrincipal(direccion,tipoConsulta);				
			break;	
			case Enum_Con_DireccionesCliente.principalWS:		
				direccionesCliente = direccionesClienteDAO.consultaPrincipalWS(direccion,Enum_Con_DireccionesCliente.principal);				
			break;	
			case Enum_Con_DireccionesCliente.foranea:
				direccionesCliente = direccionesClienteDAO.consultaForanea(direccion,tipoConsulta);
			break;
			case Enum_Con_DireccionesCliente.oficialDirec:		
				direccionesCliente = direccionesClienteDAO.consultaDirecOficial(direccion,tipoConsulta);				
			break;
			case Enum_Con_DireccionesCliente.oficial:
				direccionesCliente = direccionesClienteDAO.consultaOficial(direccion,tipoConsulta);
			break;
			case Enum_Con_DireccionesCliente.verOficial:		
				 direccionesCliente = direccionesClienteDAO.consultaTieneTipoDir(direccion,tipoConsulta);
			break;
			case Enum_Con_DireccionesCliente.BC:		
				 direccionesCliente = direccionesClienteDAO.consultaDirecBC(direccion,tipoConsulta);
			break;
			case Enum_Con_DireccionesCliente.dirAval:		
				 direccionesCliente = direccionesClienteDAO.consultaDirecAval(direccion,tipoConsulta);
			break;
			case Enum_Con_DireccionesCliente.dirTrabajo:		
				 direccionesCliente = direccionesClienteDAO.consultaDirecTrabajo(direccion,tipoConsulta);
			break;
			case Enum_Con_DireccionesCliente.dirCpTar:		
				 direccionesCliente = direccionesClienteDAO.consultaDirCliTar(direccion,tipoConsulta);
			break;
			case Enum_Con_DireccionesCliente.fiscal:	
				 direccionesCliente = direccionesClienteDAO.consultaFiscal(direccion,tipoConsulta);
			break;
			case Enum_Con_DireccionesCliente.verFiscal:	
				 direccionesCliente = direccionesClienteDAO.consultaVerFiscal(direccion,tipoConsulta);
			break;
			case Enum_Con_DireccionesCliente.oficfondeo:	
				 direccionesCliente = direccionesClienteDAO.consultaPrincipalFondeo(direccion,tipoConsulta);
			break;
			case Enum_Con_DireccionesCliente.direcNumHab:	
				 direccionesCliente = direccionesClienteDAO.consultaNumeroHabitantes(direccion,tipoConsulta);
			break;
			
			
		}
		if(direccionesCliente!=null & tipoConsulta<3){
			direccionesCliente.setDireccionID(Utileria.completaCerosIzquierda(
											direccionesCliente.getDireccionID(),DireccionesClienteBean.LONGITUD_ID));
		}
		return direccionesCliente;
	}	
	
	// Lista de Direcciones del Cliente WS
		public Object listaDireccionWS(ListaDireccionClienteRequest listaDireccionClienteRequest){
			Object obj= null;
			String cadena= "";
			ListaDireccionClienteResponse listaDireccionClienteResponse = new ListaDireccionClienteResponse();
			List<ListaDireccionClienteResponse> listaDireccionCliente = direccionesClienteDAO.listaDireccionWS(listaDireccionClienteRequest);
			if (listaDireccionCliente != null ){
				cadena=creaCadenaDireccion(listaDireccionCliente);
			}
			listaDireccionClienteResponse.setListaDireccion(cadena);
					
				obj=(Object)listaDireccionClienteResponse;
				
				return obj;
			}

		private String creaCadenaDireccion(List  listaDireccion){
			String resultadoDireccion = "";
		    String separadorCampos = "[";  
		    String separadorRegistros = "]";
		    		    
		    DireccionesClienteBean direccionesClienteBean;
		    if(listaDireccion != null) {   
		        Iterator<DireccionesClienteBean> it = listaDireccion.iterator();
		        while(it.hasNext()){    
		        	direccionesClienteBean = (DireccionesClienteBean)it.next();
		        	resultadoDireccion += direccionesClienteBean.getDireccionID() + separadorCampos +
		        			direccionesClienteBean.getDireccionCompleta() + separadorRegistros;
		        }
		    }
		    if(resultadoDireccion.length() != 0){
		    	resultadoDireccion = resultadoDireccion.substring(0,resultadoDireccion.length()-1);
		    }
		    return resultadoDireccion;
	    }

	public List lista(int tipoLista, DireccionesClienteBean direccionesCliente){		
		List listaDireccionesClientes = null;
		switch (tipoLista) {
			case Enum_Lis_DireccionesCliente.principal:		
				listaDireccionesClientes = direccionesClienteDAO.listaDirecciones(direccionesCliente, tipoLista);				
				break;				
		}		
		return listaDireccionesClientes;
	}
	
	// Reporte  de Localidades Marginadas pdf
		public ByteArrayOutputStream creaRepClienteLocMarginPDF(ReporteClienteLocMarginadasBean reporteClienteLocMarginadasBean,String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			
			parametrosReporte.agregaParametro("Par_FechaInicio",reporteClienteLocMarginadasBean.getFechaInicio());
			parametrosReporte.agregaParametro("Par_FechaFin",reporteClienteLocMarginadasBean.getFechaFin());
			parametrosReporte.agregaParametro("Par_EstadoID",(!reporteClienteLocMarginadasBean.getEstadoMarginadasID().isEmpty())? reporteClienteLocMarginadasBean.getEstadoMarginadasID():"TODOS");
			parametrosReporte.agregaParametro("Par_NombreEstado",(reporteClienteLocMarginadasBean.getNombreEstadoMarginadas()));
			parametrosReporte.agregaParametro("Par_MunicipioID",(!reporteClienteLocMarginadasBean.getMunicipioMarginadasID().isEmpty())? reporteClienteLocMarginadasBean.getMunicipioMarginadasID():"TODOS");
			parametrosReporte.agregaParametro("Par_NombreMunicipio",reporteClienteLocMarginadasBean.getNombreMunicipioMarginadas());
			parametrosReporte.agregaParametro("Par_LocalidadID",(!reporteClienteLocMarginadasBean.getLocalidadMarginadasID().isEmpty())? reporteClienteLocMarginadasBean.getLocalidadMarginadasID():"TODOS");
			parametrosReporte.agregaParametro("Par_NombreLocalidad",reporteClienteLocMarginadasBean.getNombreLocalidadMarginadas());
			
			parametrosReporte.agregaParametro("Par_NombreInstitucion",(!reporteClienteLocMarginadasBean.getNombreInstitucion().isEmpty())?reporteClienteLocMarginadasBean.getNombreInstitucion(): "TODOS");
			parametrosReporte.agregaParametro("Par_NombreUsuario",reporteClienteLocMarginadasBean.getNombreUsuario());
			parametrosReporte.agregaParametro("Par_FechaEmision",reporteClienteLocMarginadasBean.getFechaEmision());
		
			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}
				
		
		public List listaRepClienteLocMarginExcel(int tipoLista, 
													ReporteClienteLocMarginadasBean reporteClienteLocMarginadasBean, 
															HttpServletResponse response){
				 List listaClienteLocMargin=null;
			switch(tipoLista){		
				case Enum_Lis_ReporteClienteLocMarginadas.cliLocMarginadas:
					listaClienteLocMargin = direccionesClienteDAO.listaClienteLocsMargin(reporteClienteLocMarginadasBean, tipoLista); 
					break;	
			}
			
			return listaClienteLocMargin;
		}

	public DireccionesClienteDAO getDireccionesClienteDAO() {
		return direccionesClienteDAO;
	}

	public void setDireccionesClienteDAO(DireccionesClienteDAO direccionesClienteDAO ){
		this.direccionesClienteDAO = direccionesClienteDAO;
	}
	
	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
}

