package seguridad.filtros;

import general.bean.ParametrosSesionBean;

import java.util.Collection;

import org.apache.log4j.Logger;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.access.SecurityConfig;
import org.springframework.security.web.FilterInvocation;
import org.springframework.security.web.access.intercept.FilterInvocationSecurityMetadataSource;

import seguridad.bean.BitacoraAccesoBean;
import seguridad.bean.RolesPorRecursoBean;
import seguridad.servicio.SeguridadRecursosServicio;

public class FiltroAccesoRecursos implements FilterInvocationSecurityMetadataSource {
	
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	private RolesPorRecursoBean rolesPorRecursoBean;
	SeguridadRecursosServicio seguridadRecursosServicio = null;
	private ParametrosSesionBean parametrosSesionBean = null;
	
	public Collection<ConfigAttribute> getAllConfigAttributes() {		
		return null;
	}

	
	public Collection<ConfigAttribute> getAttributes(Object arg0) throws IllegalArgumentException {		
		FilterInvocation filterInvocation = (FilterInvocation) arg0;
		String url = filterInvocation.getRequestUrl();
		String metodo = filterInvocation.getRequest().getMethod();
				
		String rolesString = null;
		
		String usuarioName = "DEFAULT";
		
		try{
			if(parametrosSesionBean != null){
				usuarioName = parametrosSesionBean.getClaveUsuario();
				
				if(usuarioName != null){
					usuarioName = parametrosSesionBean.getClaveUsuario();
				}else{
					usuarioName = "ANONIMO";
				}
			}			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		if (url.endsWith("htm")){	
			url = url.substring(1,url.length());
						
			if(url.equals("activaPantallasRol.htm")){
				seguridadRecursosServicio.setRolesPorRecursoBean(rolesPorRecursoBean);
				seguridadRecursosServicio.consultaRolesPorRecurso();
				rolesPorRecursoBean = seguridadRecursosServicio.getRolesPorRecursoBean();
			}
			
			/*
			 * Registro de Bitacora Acceso a Recursos SAFI
			 */
			if(parametrosSesionBean != null ){
				if(!url.equals("entradaAplicacion.htm") && !url.equals("menuAplicacion.htm") 
						&& !url.equals("cerrarSessionUsuarios.htm") && !url.equals("consultaSession.htm")
						&& !url.equals("capturaOpInusualesVista.htm") && !url.equals("capturaOpIntPreocupantesVista.htm")){
					// Ingresar acceso a pantallas
										
					BitacoraAccesoBean bitacoraAccesoBean = new BitacoraAccesoBean();
					bitacoraAccesoBean.setSucursalID(""+parametrosSesionBean.getSucursal());
					bitacoraAccesoBean.setAccesoIP( filterInvocation.getRequest().getRemoteAddr());
					bitacoraAccesoBean.setClaveUsuario(""+parametrosSesionBean	.getClaveUsuario());
					bitacoraAccesoBean.setPerfil(""+parametrosSesionBean.getPerfilUsuario());
					bitacoraAccesoBean.setRecurso(url);
					bitacoraAccesoBean.setDetalleAcceso("Actividad: Acceso pantalla SAFI;"+" Recurso: "+url+" ;");
					bitacoraAccesoBean.setTipoAcceso("3");
					bitacoraAccesoBean.setTipoMetodo(metodo);

					if(usuarioName != "ANONIMO"){
						seguridadRecursosServicio.altaBitacoraAcceso(bitacoraAccesoBean);
						
					}
				}
			}
			
			
			
			loggerSAFI.info("FiltroAccesoRecursos. Roles del URL: " + url + ";Usuario:" + usuarioName);
		}		
		
		
		if(rolesPorRecursoBean.getRolesPorRecursoMapa().get(url)!=null){
			
			rolesString = (String)rolesPorRecursoBean.getRolesPorRecursoMapa().get(url);
		}
	
		
		if(rolesString == null || rolesString.equalsIgnoreCase("")){
			if (url.indexOf("/dwr/")>-1 || url.indexOf("/js/")>-1){
				rolesString = rolesPorRecursoBean.getListaRoles();
			}else{
				rolesString = "ANONYMOUS," + rolesPorRecursoBean.getListaRoles(); 
			}
		}				
				
		
		loggerSAFI.debug("FiltroAccesoRecursos. Roles del URL: " + url + ";"  + rolesString + " ;" + usuarioName);
						
		return SecurityConfig.createListFromCommaDelimitedString(rolesString);
	}

	

	
	public boolean supports(Class<?> arg0) {
		return true;
	}
	
	public void setRolesPorRecursoBean(RolesPorRecursoBean rolesPorRecursoBean) {
		this.rolesPorRecursoBean = rolesPorRecursoBean;
	}


	public RolesPorRecursoBean getRolesPorRecursoBean() {
		return rolesPorRecursoBean;
	}


	public SeguridadRecursosServicio getSeguridadRecursosServicio() {
		return seguridadRecursosServicio;
	}


	public void setSeguridadRecursosServicio(
			SeguridadRecursosServicio seguridadRecursosServicio) {
		this.seguridadRecursosServicio = seguridadRecursosServicio;
	}


	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}


	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	
}
