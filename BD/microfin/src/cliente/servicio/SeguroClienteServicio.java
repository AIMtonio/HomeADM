package cliente.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;
 
import javax.servlet.http.HttpServletRequest;

import reporte.ParametrosReporte;
import reporte.Reporte;
import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;
import soporte.servicio.UsuarioServicio.Enum_Con_Usuario;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import cliente.bean.RepSeguroClienteBean;
import cliente.bean.SeguroClienteBean;
import cliente.dao.SeguroClienteDAO;

public class SeguroClienteServicio extends BaseServicio{
	SeguroClienteDAO seguroClienteDAO = null;
	UsuarioServicio usuarioServicio = null;
	
	private SeguroClienteServicio(){
		super();
	}
	
	public static interface Enum_Tra_SeguroCliente{
		int Alta 		= 1;		// alta de seguro...
		int Cancela 	= 2;		// cancelacion de seguro
		
	}

	
	public static interface Enum_Con_SeguroCliente{
		int principal 		= 1;		// consulta principal
		int cobroSeguro 	= 2;		// consulta por número de Cliente
		int aplicaSeguro 	= 3;		// Aplica seguro Cliente
		int certSeguroVida  = 4;       //consulta Certificado seguro vida
		int canSegVid  		= 5;       //consulta para Cancelacion seguro vida
	}

	public static interface Enum_Lis_ClienteSeguro{
		int listaClieteSeg			=1;
		int segurosPorCliente		=2;
		int segurosPorNomCli		=3;
		int listaCteSegSuc			=4;
		int listaClieteSegVen		=5;
	}
	public static interface  Enum_Lis_SeguroCliMov{
		int listaMovSeguroCliente =1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SeguroClienteBean seguroClienteBean){
		MensajeTransaccionBean mensaje = null;
		UsuarioBean usuarioBean = new UsuarioBean();
		switch (tipoTransaccion) {
			case Enum_Tra_SeguroCliente.Alta:
//				mensaje = altaCliente(cliente);				
			break;
			case Enum_Tra_SeguroCliente.Cancela:
				String passValidaUser = null;
				String presentedPassword = seguroClienteBean.getContrasenia();
				/* -- -----------------------------------------------------------------
				 *  Consulta para otener la clave del usuario sin importar si es mayuscula o minuscula
				 * -- -----------------------------------------------------------------
				 */	
				usuarioBean.setClave(seguroClienteBean.getClaveUsuarioAutoriza());
				usuarioBean= usuarioServicio.consulta(Enum_Con_Usuario.clave,usuarioBean);
				if(usuarioBean == null){
					mensaje = new MensajeTransaccionBean();
		    		mensaje.setNumero(404);
		    		mensaje.setDescripcion("Usuario Invalido");
		    		return mensaje;
				}
				seguroClienteBean.setClaveUsuarioAutoriza(usuarioBean.getClave());
				
		        if(presentedPassword.contains("HD>>")){
		        	loggerSAFI.info("SAFIHUELLAS: "+seguroClienteBean.getClaveUsuarioAutoriza()+"-  Inicia Validacion de Token de Huella [SeguroClienteServicio.grabaTransaccion]");
		        	presentedPassword = presentedPassword.replace("HD>>", "");
		        	seguroClienteBean.setContrasenia(SeguridadRecursosServicio.encriptaPass(seguroClienteBean.getClaveUsuarioAutoriza(), presentedPassword));
		        	passValidaUser = SeguridadRecursosServicio.generaTokenHuella(seguroClienteBean.getClaveUsuarioAutoriza());
		        	
		        	if(seguroClienteBean.getContrasenia().equals(passValidaUser)){		        		
		        		seguroClienteBean.setContrasenia(usuarioBean.getContrasenia());
		        		mensaje = seguroClienteDAO.cancelaSeguro(seguroClienteBean);		
		        	}else{
		        		mensaje = new MensajeTransaccionBean();
		        		mensaje.setNumero(405);
		        		mensaje.setDescripcion("Token Huella Invalida");
		        	}
		        	loggerSAFI.info("SAFIHUELLAS: "+seguroClienteBean.getClaveUsuarioAutoriza()+"-  Fin Validacion de Token de Huella [SeguroClienteServicio.grabaTransaccion]");

		        }else{
					seguroClienteBean.setContrasenia(SeguridadRecursosServicio.encriptaPass(seguroClienteBean.getClaveUsuarioAutoriza(), seguroClienteBean.getContrasenia()));
					mensaje = seguroClienteDAO.cancelaSeguro(seguroClienteBean);
		        }			
			break;
		}
		return mensaje;
	}
	
	public SeguroClienteBean consulta(int tipoConsulta, SeguroClienteBean seguroClienteBean){
		SeguroClienteBean seguroCliente = null;
		switch(tipoConsulta){
			case Enum_Con_SeguroCliente.cobroSeguro:
				seguroCliente = seguroClienteDAO.consulta(seguroClienteBean,tipoConsulta);
			break;
			case Enum_Con_SeguroCliente.aplicaSeguro:
				seguroCliente = seguroClienteDAO.consulta(seguroClienteBean,tipoConsulta);
			break;
			case Enum_Con_SeguroCliente.certSeguroVida:
				seguroCliente = seguroClienteDAO.consulta(seguroClienteBean,tipoConsulta);
			break;
			case Enum_Con_SeguroCliente.canSegVid:
				seguroCliente = seguroClienteDAO.consultaCancelacion(seguroClienteBean,tipoConsulta);
			break;
		}
	return seguroCliente;
	}
	
	public List lista(int tipoLista, SeguroClienteBean seguroClienteBean){		
		List listaClientes = null;
		switch (tipoLista) {
			case Enum_Lis_ClienteSeguro.listaClieteSeg:		
				listaClientes = seguroClienteDAO.listaSeguroCliente(seguroClienteBean, tipoLista);				
				break;
			case Enum_Lis_ClienteSeguro.segurosPorNomCli:		
				listaClientes = seguroClienteDAO.listaSeguroNomCliente(seguroClienteBean, tipoLista);				
				break;
			case Enum_Lis_ClienteSeguro.listaCteSegSuc:		
				listaClientes = seguroClienteDAO.listaSeguroCliente(seguroClienteBean, tipoLista);				
				break;
			case Enum_Lis_ClienteSeguro.listaClieteSegVen:		
				listaClientes = seguroClienteDAO.listaSeguroCliente(seguroClienteBean, tipoLista);				
				break;
				
		}		
		return listaClientes;
	}	
	
	public Object[] listaCombo(int tipoLista, SeguroClienteBean seguroClienteBean){
		List listaSucursales = null;
		switch (tipoLista) {
			case Enum_Lis_ClienteSeguro.segurosPorCliente:		
				listaSucursales=  seguroClienteDAO.listaCombo(seguroClienteBean,tipoLista);				
				break;				
		}		
		return listaSucursales.toArray();
	}
	
	
	// reporte Seguro del Cliente
	public String reporteSeguroCliente(SeguroClienteBean seguroClienteBean , String nomReporte,HttpServletRequest request ) throws Exception{				
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(seguroClienteBean.getClienteID() )  );
			
		return Reporte.creaHtmlReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	} 
	
/* Funciones para Reportes Seguro de cliente */
	
	// Reporte de Seguro Cliente a PDF
		public ByteArrayOutputStream creaRepSeguroClientePDF(RepSeguroClienteBean repSeguroClienteBean , String nomReporte) throws Exception{
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_FechaInicio",Utileria.convierteFecha(repSeguroClienteBean.getFechaInicio()) );
		parametrosReporte.agregaParametro("Par_FechaFin",Utileria.convierteFecha(repSeguroClienteBean.getFechaFin()) );
		parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(repSeguroClienteBean.getClienteID()));
		
		parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(repSeguroClienteBean.getSucursal()));
		parametrosReporte.agregaParametro("Par_Promotor",Utileria.convierteEntero(repSeguroClienteBean.getPromotor()));
		parametrosReporte.agregaParametro("Par_Estatus",repSeguroClienteBean.getEstatus());
		
		parametrosReporte.agregaParametro("Par_nombreCliente",repSeguroClienteBean.getNombreCliente() );
		parametrosReporte.agregaParametro("Par_nombreSucursal",(!repSeguroClienteBean.getNombreSucursal().isEmpty())?repSeguroClienteBean.getNombreSucursal(): "TODOS");
		parametrosReporte.agregaParametro("Par_nombrePromotor",(!repSeguroClienteBean.getNombrePromotor().isEmpty())?repSeguroClienteBean.getNombrePromotor(): "TODOS");
		parametrosReporte.agregaParametro("Par_nombreInstitucion",(!repSeguroClienteBean.getNombreInstitucion().isEmpty())?repSeguroClienteBean.getNombreInstitucion(): "TODOS");
		parametrosReporte.agregaParametro("Par_nombreUsuario",(!repSeguroClienteBean.getNombreUsuario().isEmpty())?repSeguroClienteBean.getNombreUsuario(): "TODOS");
		parametrosReporte.agregaParametro("Par_FechaEmision",repSeguroClienteBean.getParFechaEmision());		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
		// Reporte de Seguro Cliente a PDF
				public ByteArrayOutputStream creaRepCertificadoSegVidaPDF(RepSeguroClienteBean repSeguroClienteBean , String nomReporte) throws Exception{
				
				ParametrosReporte parametrosReporte = new ParametrosReporte();
				
				parametrosReporte.agregaParametro("Par_NombreInstitucio",repSeguroClienteBean.getNombreInstitucion());
				parametrosReporte.agregaParametro("Par_DireccionInstitucion",repSeguroClienteBean.getDireccionInstit());
				parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(repSeguroClienteBean.getClienteID()));
				
				parametrosReporte.agregaParametro("Par_RFCInstitucion",repSeguroClienteBean.getRFCInstit());
				parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(repSeguroClienteBean.getSucursal()));
				parametrosReporte.agregaParametro("Par_NombreCajero",repSeguroClienteBean.getNombreUsuario());
				
				parametrosReporte.agregaParametro("Par_NombreCliente",repSeguroClienteBean.getNombreCliente());
				parametrosReporte.agregaParametro("Par_TelefonoSucursal",repSeguroClienteBean.getTelefonoInst());
				parametrosReporte.agregaParametro("Par_FechaSistema",repSeguroClienteBean.getFechaActual());
		
				return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			}	
	
		

//----------------getter y setter
	public SeguroClienteDAO getSeguroClienteDAO() {
		return seguroClienteDAO;
	}
	public void setSeguroClienteDAO(SeguroClienteDAO seguroClienteDAO) {
		this.seguroClienteDAO = seguroClienteDAO;
	}

	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}
		
}
