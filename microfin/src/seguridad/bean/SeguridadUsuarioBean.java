package seguridad.bean;

import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

public class SeguridadUsuarioBean extends User{

	private static final long serialVersionUID = -4914184640037540249L;
	
	private String salt;
	
	public SeguridadUsuarioBean(String username,
								String password,
								boolean enabled,
								boolean accountNonExpired,
								boolean credentialsNonExpired,
								boolean accountNonLocked,
								List<GrantedAuthority> authorities,
								String salt) {
		
		super(username, password, enabled,
				accountNonExpired, credentialsNonExpired,
				accountNonLocked, authorities);
		this.salt = salt;
	}
	
	public String getSalt() {
		return salt;
	}
	
	public void setSalt(String salt) {
		this.salt = salt;
	}
	
}
