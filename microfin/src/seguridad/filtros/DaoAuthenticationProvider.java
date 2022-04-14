package seguridad.filtros;


import org.apache.log4j.Logger;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.dao.DataAccessException;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.authentication.dao.AbstractUserDetailsAuthenticationProvider;
import org.springframework.security.authentication.dao.SaltSource;
import org.springframework.security.authentication.encoding.PasswordEncoder;
import org.springframework.security.authentication.encoding.PlaintextPasswordEncoder;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.util.Assert;

import herramientas.Constantes;
import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.ControlClaveBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.ControlClaveServicio;
import soporte.servicio.UsuarioServicio;

public class DaoAuthenticationProvider
extends AbstractUserDetailsAuthenticationProvider {
    private PasswordEncoder passwordEncoder = new PlaintextPasswordEncoder();
    private SaltSource saltSource;
    private UserDetailsService userDetailsService;
    private boolean includeDetailsObject = true;
    private ControlClaveServicio controlClaveServicio;
    private UsuarioServicio usuarioServicio;
    protected final Logger loggerSAFI = Logger.getLogger("SAFI");
    protected void additionalAuthenticationChecks(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication) throws AuthenticationException {
        Object salt = null;
        String passValidaUser = null;
        if (this.saltSource != null) {
            salt = this.saltSource.getSalt(userDetails);
        }
        if (authentication.getCredentials() == null) {
            throw new BadCredentialsException(this.messages.getMessage("AbstractUserDetailsAuthenticationProvider.badCredentials", "Bad credentials"), (Object)(this.includeDetailsObject ? userDetails : null));
        }
        
        /* Validación de Licencia SAFI */
        UsuarioBean usuarioBean = new UsuarioBean();
        usuarioBean.setClave(userDetails.getUsername());
        usuarioBean = usuarioServicio.consulta(UsuarioServicio.Enum_Con_Usuario.clave, usuarioBean);
        ControlClaveBean claveBean = new ControlClaveBean();
        claveBean.setOrigenDatos(usuarioBean.getOrigenDatos());
        if (controlClaveServicio.consulta(ControlClaveServicio.Enum_Con_Claves.claveKey, claveBean).getActivo().equals(Constantes.STRING_NO)) {
            throw new LockedException(this.messages.getMessage("AbstractUserDetailsAuthenticationProvider.badCredentials", "Bad credentials"), (Object)(this.includeDetailsObject ? userDetails : null));
        }
        
        String presentedPassword = authentication.getCredentials().toString();
        
        /* Validar password */
        if(presentedPassword.contains("HD>>")){
        	loggerSAFI.info("SAFIHUELLAS: "+userDetails.getUsername()+"-  Inicia Validacion de Token de Huella [DaoAuthenticationProvider.additionalAuthenticationChecks]");
        	presentedPassword = presentedPassword.replace("HD>>", "");
        	passValidaUser = SeguridadRecursosServicio.generaTokenHuella(userDetails.getUsername());
        	loggerSAFI.info("SAFIHUELLAS: "+userDetails.getUsername()+"-  Fin Validacion de Token de Huella [DaoAuthenticationProvider.additionalAuthenticationChecks]");
        }else{
        	passValidaUser = userDetails.getPassword();
        }
        
        if (!this.passwordEncoder.isPasswordValid(passValidaUser, presentedPassword, salt)) {
            throw new BadCredentialsException(this.messages.getMessage("AbstractUserDetailsAuthenticationProvider.badCredentials", "Bad credentials"), (Object)(this.includeDetailsObject ? userDetails : null));
        }
    }

    protected void doAfterPropertiesSet() throws Exception {
        Assert.notNull((Object)this.userDetailsService, (String)"A UserDetailsService must be set");
    }

    protected final UserDetails retrieveUser(String username, UsernamePasswordAuthenticationToken authentication) throws AuthenticationException {
        UserDetails loadedUser;
        try {
            loadedUser = this.getUserDetailsService().loadUserByUsername(username);
        }
        catch (DataAccessException repositoryProblem) {
            throw new AuthenticationServiceException(repositoryProblem.getMessage(), (Throwable)repositoryProblem);
        }
        if (loadedUser == null) {
            throw new AuthenticationServiceException("UserDetailsService returned null, which is an interface contract violation");
        }
        return loadedUser;
    }

    public void setPasswordEncoder(PasswordEncoder passwordEncoder) {
        this.passwordEncoder = passwordEncoder;
    }

    protected PasswordEncoder getPasswordEncoder() {
        return this.passwordEncoder;
    }

    public void setSaltSource(SaltSource saltSource) {
        this.saltSource = saltSource;
    }

    protected SaltSource getSaltSource() {
        return this.saltSource;
    }

    public void setUserDetailsService(UserDetailsService userDetailsService) {
        this.userDetailsService = userDetailsService;
    }

    protected UserDetailsService getUserDetailsService() {
        return this.userDetailsService;
    }

    protected boolean isIncludeDetailsObject() {
        return this.includeDetailsObject;
    }

    public void setIncludeDetailsObject(boolean includeDetailsObject) {
        this.includeDetailsObject = includeDetailsObject;
    }

	public ControlClaveServicio getControlClaveServicio() {
		return controlClaveServicio;
	}

	public void setControlClaveServicio(ControlClaveServicio controlClaveServicio) {
		this.controlClaveServicio = controlClaveServicio;
	}

	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}
    
    
}
