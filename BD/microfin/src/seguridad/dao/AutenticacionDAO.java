package seguridad.dao;

import java.util.ArrayList;
import java.util.List;
 
import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.security.authentication.dao.SaltSource;
import org.springframework.security.authentication.encoding.PasswordEncoder;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.GrantedAuthorityImpl;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.core.userdetails.jdbc.JdbcDaoImpl;

import seguridad.bean.SeguridadUsuarioBean;
import soporte.bean.UsuarioBean;
import soporte.dao.UsuarioDAO;
import soporte.servicio.UsuarioServicio;

public class AutenticacionDAO extends JdbcDaoImpl {
	
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	private UsuarioDAO usuarioDAO = null;
	private PasswordEncoder passwordEncoder;
	private SaltSource saltSource;
	
	
	public UserDetails loadUserByUsername(String username)
			throws UsernameNotFoundException, DataAccessException {
		
		UsuarioBean usuarioBean = new UsuarioBean();
		UsuarioBean usuarioCon = null;
		SeguridadUsuarioBean userDetails = null;
		boolean activo = false;		
		
		usuarioBean.setClave(username);
		usuarioCon = usuarioDAO.consultaPorClaveBDPrincipal(usuarioBean, UsuarioServicio.Enum_Con_Usuario.clave);
		usuarioBean.setOrigenDatos(usuarioCon.getOrigenDatos());
		usuarioCon = usuarioDAO.consultaPorClave(usuarioBean, UsuarioServicio.Enum_Con_Usuario.clave);
		
		if(usuarioCon==null){			
			throw new UsernameNotFoundException("El Usuario " + username  + " no Existe");
		}else{
			List<GrantedAuthority> listaRoles = new ArrayList<GrantedAuthority>();
			listaRoles.add(new GrantedAuthorityImpl(usuarioCon.getNombreRol()));
			
			
			if(usuarioCon.getEstatus().equalsIgnoreCase(UsuarioBean.STATUS_ACTIVO) ){
				activo = true;
			}
			userDetails = new SeguridadUsuarioBean(usuarioCon.getClave(), usuarioCon.getContrasenia(), activo,
												   true, true, true, listaRoles, usuarioCon.getClave());
			
			loggerSAFI.info(usuarioCon.getOrigenDatos()+"Autenticando al Usuario en BD: " + usuarioCon.getClave() + "-" + usuarioCon.getNombreRol());
			//passwordEncoder.encodePassword(usuarioCon.getContrasenia(), saltSource.getSalt(userDetails))

		}		 
		return userDetails;		
	}
	
	
	public void setUsuarioDAO(UsuarioDAO usuarioDAO) {
		this.usuarioDAO = usuarioDAO;
	}


	public void setPasswordEncoder(PasswordEncoder passwordEncoder) {
		this.passwordEncoder = passwordEncoder;
	}


	public void setSaltSource(SaltSource saltSource) {
		this.saltSource = saltSource;
	}

	
	
}
