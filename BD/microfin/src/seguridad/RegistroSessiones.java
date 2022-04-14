package seguridad;

import java.util.List;

import org.springframework.security.core.session.SessionDestroyedEvent;
import org.springframework.security.core.session.SessionInformation;
import org.springframework.security.core.session.SessionRegistryImpl;

public class RegistroSessiones extends SessionRegistryImpl{
	
	public List<Object> getAllPrincipals() {
		return super.getAllPrincipals();
	}

	
	public List<SessionInformation> getAllSessions(Object arg0, boolean arg1) {
		return super.getAllSessions(arg0, arg1);
	}

	
	public SessionInformation getSessionInformation(String sessionId) {
		return super.getSessionInformation(sessionId);
	}

	
	public void onApplicationEvent(SessionDestroyedEvent event) {
		super.onApplicationEvent(event);
	}

	public void refreshLastRequest(String sessionId) {
		super.refreshLastRequest(sessionId);
	}


	public synchronized void registerNewSession(String sessionId, Object principal) {
		super.registerNewSession(sessionId, principal);
	}

	public void removeSessionInformation(String sessionId) {
		super.removeSessionInformation(sessionId);
	}
	
	public static void removeSessionInformation1(String sessionId) {
		removeSessionInformation1(sessionId);
	}

	// -------------------------- Setter y Guetters ---------------------------------------
	
	
}
