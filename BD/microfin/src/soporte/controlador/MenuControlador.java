package soporte.controlador;
import general.bean.ParametrosAuditoriaBean;
import general.bean.ParametrosSesionBean;
import general.servicio.ParametrosAplicacionServicio;
import general.servicio.ParametrosAplicacionServicio.Enum_Con_ParAplicacion;
import herramientas.SistemaLogging;
 
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.springframework.web.servlet.support.RequestContextUtils;

import soporte.bean.MenuAplicacionBean;
import soporte.bean.UsuarioBean;
import soporte.dao.UsuarioDAO;
import soporte.servicio.MenuServicio;
import soporte.servicio.MenuServicio.Enum_Con_Menu;

public class MenuControlador extends AbstractController{

	Logger log = Logger.getLogger( this.getClass() );
	
 	MenuServicio menuServicio = null;
 	ParametrosAplicacionServicio parametrosAplicacionServicio = null;
 	private ParametrosSesionBean parametrosSesionBean = null;
 	private ParametrosAuditoriaBean parametrosAuditoriaBean = null;
 	UsuarioDAO usuarioDAO =null;

	public MenuControlador() {
		super();
	}
	
	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			 									 HttpServletResponse response)
																			throws Exception {
		
		String claveUsuario = SecurityContextHolder.getContext().getAuthentication().getName();
				
		MenuAplicacionBean menuAplicacion = null;
		UsuarioBean usuarioBean = new UsuarioBean();
		usuarioBean.setClave(claveUsuario);
		usuarioBean = usuarioDAO.consultaPorClaveBDPrincipal(usuarioBean, 3);
		

	
		ParametrosSesionBean parametros =	parametrosAplicacionServicio.consultaParametrosSession(
				Enum_Con_ParAplicacion.loginSession, usuarioBean);
		
					
		String programa="MenuControlador";
		ParametrosAuditoriaBean parametrosAuditoriaBean1 = new ParametrosAuditoriaBean();
		parametrosAuditoriaBean1.setNumeroTransaccion(1234567890);
								
		log.info("Consulto parametros sesion");
		estableceParametros(parametros, request);
		//Sistema Loggin
		//String ClaseBean=ParametrosSesionBean.class.getName();
		String ClaseBean = parametros.getClass().getName();//nombre de la claseBean que se envia con
		SistemaLogging.escribeLog(programa,parametrosAuditoriaBean,parametros, this.getClass(),ClaseBean);
		
		
		 try {
	            RequestContextUtils.getLocaleResolver(request).setLocale(request, response, new Locale(parametros.getNomCortoInstitucion()));
	        } catch (Exception ex) {
	        }
		
		
		//TODO Agregar el llenado de los Parametros de Auditoria
		menuAplicacion = menuServicio.consultaMenuPorPerfil(Enum_Con_Menu.porPerfil, usuarioBean);
		List<Object> listaResultado = (List<Object>)new ArrayList();
		listaResultado.add(parametros);   
		listaResultado.add(menuAplicacion);		
		

		Cookie cookie = new Cookie("USUARIO",parametros.getClaveUsuario());
		cookie.setMaxAge(-1); 
		cookie.setPath(request.getContextPath());
		cookie.setSecure(true);
		response.addCookie(cookie);
		
		return new ModelAndView("menuAplicacionView", "listaResultado", listaResultado);
			
	}
	
	private void estableceParametros(ParametrosSesionBean parametros, HttpServletRequest request){
		parametrosSesionBean.setFechaAplicacion(parametros.getFechaAplicacion());
		parametrosSesionBean.setNumeroSucursalMatriz(parametros.getNumeroSucursalMatriz());
		parametrosSesionBean.setNombreSucursalMatriz(parametros.getNombreSucursalMatriz());
		parametrosSesionBean.setTelefonoLocal(parametros.getTelefonoLocal());
		parametrosSesionBean.setTelefonoInterior(parametros.getTelefonoInterior());
		parametrosSesionBean.setNumeroInstitucion(parametros.getNumeroInstitucion());
		parametrosSesionBean.setNombreInstitucion(parametros.getNombreInstitucion());
		parametrosSesionBean.setRepresentanteLegal(parametros.getRepresentanteLegal());
		parametrosSesionBean.setRfcRepresentante(parametros.getRfcRepresentante());		
		parametrosSesionBean.setNumeroMonedaBase(parametros.getNumeroMonedaBase());
		parametrosSesionBean.setNombreMonedaBase(parametros.getNombreMonedaBase());
		parametrosSesionBean.setDesCortaMonedaBase(parametros.getDesCortaMonedaBase());
		parametrosSesionBean.setSimboloMonedaBase(parametros.getSimboloMonedaBase());
		
		parametrosSesionBean.setNumeroUsuario(parametros.getNumeroUsuario());
		parametrosSesionBean.setClaveUsuario(parametros.getClaveUsuario());
		parametrosSesionBean.setPerfilUsuario(parametros.getPerfilUsuario());		
		parametrosSesionBean.setNombreUsuario(parametros.getNombreUsuario());
		parametrosSesionBean.setCorreoUsuario(parametros.getCorreoUsuario());
		parametrosSesionBean.setSucursal(parametros.getSucursal());
		parametrosSesionBean.setFechaSucursal(parametros.getFechaSucursal());
		parametrosSesionBean.setNombreSucursal(parametros.getNombreSucursal());		
		parametrosSesionBean.setGerenteSucursal(parametros.getGerenteSucursal());		
		parametrosSesionBean.setNumeroCaja(parametros.getNumeroCaja());
		parametrosSesionBean.setLoginsFallidos(parametros.getLoginsFallidos());		
		parametrosSesionBean.setTasaISR(parametros.getTasaISR());
		parametrosSesionBean.setDiasBaseInversion(parametros.getDiasBaseInversion());
		parametrosSesionBean.setFechUltimAcces(parametros.getFechUltimAcces());
		parametrosSesionBean.setFechUltPass(parametros.getFechUltPass());
		parametrosSesionBean.setDiasCambioPass(parametros.getDiasCambioPass());
		parametrosSesionBean.setCambioPassword(parametros.getCambioPassword());
		parametrosSesionBean.setEstatusSesion(parametros.getEstatusSesion());
		parametrosSesionBean.setIPsesion(parametros.getIPsesion());
		parametrosSesionBean.setPromotorID(parametros.getPromotorID());
		parametrosSesionBean.setClienteInstitucion(parametros.getClienteInstitucion());
		parametrosSesionBean.setCuentaInstitucion(parametros.getCuentaInstitucion());
		parametrosSesionBean.setRutaArchivos(parametros.getRutaArchivos());

		parametrosSesionBean.setCajaID(parametros.getCajaID());
		parametrosSesionBean.setTipoCaja(parametros.getTipoCaja());
		parametrosSesionBean.setEstatusCaja(parametros.getEstatusCaja());
		parametrosSesionBean.setSaldoEfecMN(parametros.getSaldoEfecMN());
		parametrosSesionBean.setSaldoEfecME(parametros.getSaldoEfecME());
		parametrosSesionBean.setLimiteEfectivoMN(parametros.getLimiteEfectivoMN());
		parametrosSesionBean.setTipoCajaDes(parametros.getTipoCajaDes());
		
		parametrosSesionBean.setClavePuestoID(parametros.getClavePuestoID());
		parametrosSesionBean.setRutaArchivosPLD(parametros.getRutaArchivosPLD());
		parametrosSesionBean.setIvaSucursal(parametros.getIvaSucursal());
		parametrosSesionBean.setDireccionInstitucion(parametros.getDireccionInstitucion());
		parametrosSesionBean.setEdoMunSucursal(parametros.getEdoMunSucursal());
		parametrosSesionBean.setImpTicket(parametros.getImpTicket());
		parametrosSesionBean.setTipoImpTicket(parametros.getTipoImpTicket());
		parametrosSesionBean.setMontoAportacion(parametros.getMontoAportacion());		
		parametrosSesionBean.setMontoPolizaSegA(parametros.getMontoPolizaSegA());
		parametrosSesionBean.setMontoSegAyuda(parametros.getMontoSegAyuda());
		parametrosSesionBean.setNomCortoInstitucion(parametros.getNomCortoInstitucion());    // Parametro agregado para nombre corto Locale
		parametrosSesionBean.setSalMinDF(parametros.getSalMinDF());
		parametrosSesionBean.setDirFiscal(parametros.getDirFiscal()); //se agregó para la dirección fiscal de la institucion
		parametrosSesionBean.setRfcInst(parametros.getRfcInst()); //se agregó para el RFC de la institución
		parametrosSesionBean.setNomJefeOperayPromo(parametros.getNomJefeOperayPromo());
		parametrosSesionBean.setNombreJefeCobranza(parametros.getNombreJefeCobranza());
		parametrosSesionBean.setImpSaldoCred(parametros.getImpSaldoCred()); //se agregó imprimir el el ticket de pago de credito la fecha del proximo pago
		parametrosSesionBean.setImpSaldoCta(parametros.getImpSaldoCta()); //se agregó imprimir el el ticket de abono a cuenta
		parametrosSesionBean.setNombreCortoInst(parametros.getNombreCortoInst());
		
		/* Define el tipo de Institución y los mensajes que se mostraran SOCAP - SOFIPO */
		
		parametrosSesionBean.setNomCortoInstitucion(parametros.getNomCortoInstitucion());
		
		/*se agrego para los reportes financieros*/
		parametrosSesionBean.setGerenteGeneral(parametros.getGerenteGeneral());
		parametrosSesionBean.setPresidenteConsejo(parametros.getPresidenteConsejo());
		parametrosSesionBean.setJefeContabilidad(parametros.getJefeContabilidad());
		parametrosSesionBean.setDirectorFinanzas(parametros.getDirectorFinanzas());
		
		// se agregó para el control de los tickets en las empresas 
		parametrosSesionBean.setRecursoTicketVent(parametros.getRecursoTicketVent());
		//Se agregó para los roles de tesoreria
		parametrosSesionBean.setRolTesoreria(parametros.getRolTesoreria());
		parametrosSesionBean.setRolAdminTeso(parametros.getRolAdminTeso());
		// Campo para llevar si debe mostrar o no el saldo dispoble de cuenta o sbc //
		parametrosSesionBean.setMostrarSaldDisCtaYSbc(parametros.getMostrarSaldDisCtaYSbc());
		//Campo para llevar si se debe de hacer las validaciones por huella digital//
		parametrosSesionBean.setFuncionHuella(parametros.getFuncionHuella());
		parametrosSesionBean.setOrigenDatos(parametros.getOrigenDatos());
		parametrosSesionBean.setRutaReportes(parametros.getRutaReportes());
		parametrosSesionBean.setRutaImgReportes(parametros.getRutaImgReportes());
		parametrosSesionBean.setLogoCtePantalla(parametros.getLogoCtePantalla());
		parametrosSesionBean.setMostrarPrefijo(parametros.getMostrarPrefijo());

		//Campo para llevar si se debe de hacer las validaciones para Cambio de Promotor//
		parametrosSesionBean.setCambiaPromotor(parametros.getCambiaPromotor());
		parametrosSesionBean.setTipoImpresoraTicket(parametros.getTipoImpresoraTicket());
		parametrosSesionBean.setMostrarBtnResumen(parametros.getMostrarBtnResumen());

		parametrosAuditoriaBean.setSucursal(parametros.getSucursal());
		parametrosAuditoriaBean.setUsuario(parametros.getNumeroUsuario());
		parametrosAuditoriaBean.setDireccionIP(request.getRemoteHost());
		parametrosAuditoriaBean.setFecha(parametros.getFechaAplicacion());
		parametrosAuditoriaBean.setEmpresaID(parametros.getEmpresaID());
		parametrosAuditoriaBean.setOrigenDatos(parametros.getOrigenDatos());
		parametrosAuditoriaBean.setRutaReportes(parametros.getRutaReportes());
		parametrosAuditoriaBean.setRutaImgReportes(parametros.getRutaImgReportes());
		parametrosAuditoriaBean.setLogoCtePantalla(parametros.getLogoCtePantalla());
		
		
		parametrosSesionBean.setLookAndFeel(parametros.getLookAndFeel());
		
	}			
		

	
	// ------------------------- Getters y Setters ----------------------------------------------------------
	public void setMenuServicio(MenuServicio menuServicio) {
		this.menuServicio = menuServicio;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public void setParametrosAplicacionServicio(
			ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}

	public UsuarioDAO getUsuarioDAO() {
		return usuarioDAO;
	}

	public void setUsuarioDAO(UsuarioDAO usuarioDAO) {
		this.usuarioDAO = usuarioDAO;
	}
	
	
	
}
