package seguridad.filtros;

import java.io.IOException;
import java.net.URLDecoder;
import java.text.Normalizer;
import java.util.List;
import java.util.Map;
import java.util.Stack;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.http.Cookie;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import general.bean.ParametrosSesionBean;
import general.dao.ParametrosAplicacionDAO;
import soporte.bean.OpcionesRolBean;
import soporte.bean.UsuarioBean;
import soporte.dao.OpcionesRolDAO;
import soporte.servicio.RolesServicio.Enum_Lis_Roles;

public class FiltroSeguridadSAFI implements Filter {

	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	private boolean shouldChain;

	OpcionesRolDAO opcionesRolDAO = null;
	ParametrosAplicacionDAO parametrosAplicacionDAO = null;

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
		      throws IOException, ServletException {
		    	HttpServletRequest  hreq = (HttpServletRequest)  request;
		    	HttpServletResponse hres = (HttpServletResponse) response;
		    	shouldChain=true;

		    	if(hreq.getRequestURI().endsWith(".htm")) //Valida que usuario tiene el rol con permisos suficientes para solicitar el htm
				{
		    		if(!verificaHTM(hreq,1)) //Donde 1 es el rol que tiene acceso a TODAS las pantallas del SAFI
						shouldChain=false;
				}
		    	if(shouldChain)
		    		chain.doFilter(request, response);
		    	else
		    	{
		    		String targetUrl = hreq.getContextPath() + "/filtroPantalla.htm";
		    		hres.sendRedirect(hres.encodeRedirectURL(targetUrl));
		    	}
		    }

private boolean verificaHTM(final HttpServletRequest request, final int MASTER_ROL){

		String recurso= request.getRequestURI().substring("/microfin/".length());
		final String[] pantallasAccesiblesPorTodos = {"entradaAplicacion.htm", "menuAplicacion.htm", "consultaSession.htm", "logoClientePantalla.htm","cerrarSessionUsuarios.htm", "sesionExpirada.htm", "accesoDenegado.htm", "filtroPantalla.htm", "olvidoUsuario.htm", "sesionExpiradaConcurrente.htm", "invalidaSession.htm"}; // TODO sustituir por Bean
		boolean isAccesible = false;
		for(String pantallas : pantallasAccesiblesPorTodos)
			isAccesible|=pantallas.equals(recurso);
		if(isAccesible)
			return true;

		int rol = MASTER_ROL;

		OpcionesRolBean opcionesRolBean = null;
		List listaOpRolAnterior = null;
		OpcionesRolBean opRolBean = new OpcionesRolBean();

		opRolBean.setRolID(Integer.toString(rol));
		boolean isSpecial = false;
		try {

			listaOpRolAnterior = opcionesRolDAO.listaOpcionesPorRol(opRolBean,Enum_Lis_Roles.opcionesRol);
			for(int i=0; i<listaOpRolAnterior.size(); i++){
				opcionesRolBean = (OpcionesRolBean)listaOpRolAnterior.get(i);
				isSpecial |= opcionesRolBean.getRecurso().equals(recurso);
			}
			if(!isSpecial)
				return true;


			ParametrosSesionBean parametrosSesionBean;
			UsuarioBean usuarioBean = new UsuarioBean();
			String clave ="";
			for(Cookie c : request.getCookies())
			{
				if(c.getName().equals("USUARIO"))
					clave=c.getValue();
			}
			if(clave.length()>0)
			{
				usuarioBean.setClave(clave);
				rol=parametrosAplicacionDAO.consultaParaSession(usuarioBean, 2).getPerfilUsuario();
				if(rol==MASTER_ROL)
					return true;


				opRolBean.setRolID(Integer.toString(rol));
				listaOpRolAnterior = opcionesRolDAO.listaOpcionesPorRol(opRolBean,Enum_Lis_Roles.opcionesRol);
				if(!listaOpRolAnterior.isEmpty()){
					for(int i=0; i<listaOpRolAnterior.size(); i++){
						opcionesRolBean = (OpcionesRolBean)listaOpRolAnterior.get(i);
						if(opcionesRolBean.getRecurso().equals(recurso))
							return true;
					}
					return false;
				}
			}
		}
		catch(Exception e)
		{
			return true;
		}
	return true;
    }

	public OpcionesRolDAO getOpcionesRolDAO() {
		return opcionesRolDAO;
	}

	public void setOpcionesRolDAO(OpcionesRolDAO opcionesRolDAO) {
		this.opcionesRolDAO = opcionesRolDAO;
	}

	public ParametrosAplicacionDAO getParametrosAplicacionDAO() {
		return parametrosAplicacionDAO;
	}

	public void setParametrosAplicacionDAO(ParametrosAplicacionDAO parametrosAplicacionDAO) {
		this.parametrosAplicacionDAO = parametrosAplicacionDAO;
	}

	@Override
	public void destroy() {
		// TODO Auto-generated method stub

	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		// TODO Auto-generated method stub

	}

}
