package soporte;

import java.util.Iterator;
import java.util.Set;

import general.bean.ParametrosAuditoriaBean;
import herramientas.Utileria;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.springframework.jndi.JndiTemplate;

import seguridad.bean.ConexionOrigenDatosBean;
import seguridad.servicio.ConexionOrigenDatosServicio;
import soporte.bean.ParamGeneralesBean;
import soporte.bean.ParametrosSisBean;
import soporte.dao.ParamGeneralesDAO;
import soporte.dao.ParametrosSisDAO;

public class CustomSessionListener implements HttpSessionListener {
	private int minutosSesion = 100;
	
	@Override
	public void sessionCreated(HttpSessionEvent event) {
		try {
			JndiTemplate jndiTemplate = new JndiTemplate();
			ConexionOrigenDatosBean conexionOrigenDatosBean = new ConexionOrigenDatosBean();
			
			ConexionOrigenDatosServicio conexionOrigenDatosServicio = new ConexionOrigenDatosServicio();
			conexionOrigenDatosServicio.setConexionOrigenDatosBean(conexionOrigenDatosBean);
			conexionOrigenDatosServicio.setJndiTemplate(jndiTemplate);
			conexionOrigenDatosServicio.creaConexionesBD();
			
			
			Set<String> recursos = conexionOrigenDatosBean.getOrigenDatosMapa().keySet();
			Iterator<String> it = recursos.iterator();
			String nombreRecurso = null;
			while(it.hasNext()){
				String recurso = it.next();
				if(recurso!=null && recurso.indexOf("principal")<0) {
					nombreRecurso = recurso;
					break;
				}
		    }
			
			if(nombreRecurso == null) {
				throw new Exception("No se encontró el recurso para la consulta del tiempo de sesiones definido por el usuario.");
			}
			
			ParametrosAuditoriaBean parametrosAuditoriaBean = new ParametrosAuditoriaBean();
			parametrosAuditoriaBean.setOrigenDatos(nombreRecurso);
			
			ParamGeneralesDAO paramGeneralesDAO = new ParamGeneralesDAO();
			paramGeneralesDAO.setParametrosAuditoriaBean(parametrosAuditoriaBean);
			paramGeneralesDAO.setConexionOrigenDatosBean(conexionOrigenDatosBean);
			
			ParamGeneralesBean paramGeneralesBean = paramGeneralesDAO.consultaPrincipal(new ParamGeneralesBean(), 33);

			
			if("S".equals(paramGeneralesBean.getValorParametro())) {
				ParametrosSisDAO parametrosSisDAO = new ParametrosSisDAO();
				parametrosSisDAO.setParametrosAuditoriaBean(parametrosAuditoriaBean);
				parametrosSisDAO.setConexionOrigenDatosBean(conexionOrigenDatosBean);
				
				ParametrosSisBean parametrosSisBeanRequest = new ParametrosSisBean();
				parametrosSisBeanRequest.setEmpresaID("1");
				
				ParametrosSisBean parametrosSisBean = parametrosSisDAO.consultaPrincipal(parametrosSisBeanRequest, 1);
				
				int minutosSesion = Utileria.convierteEntero(parametrosSisBean.getDiaMaxInterSesion());
				if(minutosSesion <= 0) {
					minutosSesion = this.minutosSesion;
				}

				event.getSession().setMaxInactiveInterval(minutosSesion * 60); 
			}
		}
		catch(Exception e) {
			System.out.println("Error en el proceso de actualización de tiempo de sesión.");
			e.printStackTrace();
		}
		System.out.println("Tiempo de sesión a " + event.getSession().getMaxInactiveInterval() + " segundos.");
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent event) {
		// TODO Auto-generated method stub
	}
}
