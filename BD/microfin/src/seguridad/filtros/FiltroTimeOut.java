package seguridad.filtros;

import herramientas.Constantes;

import java.io.IOException;
import java.util.StringTokenizer;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.InitializingBean;


public class FiltroTimeOut implements Filter, InitializingBean {
	
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	private String expiredUrl;
	
	public void destroy() {	}

	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {		
				
		if(req instanceof HttpServletRequest){
			HttpServletRequest hReq = (HttpServletRequest)req;
			HttpServletResponse hRes = (HttpServletResponse)res;
			HttpSession session = hReq.getSession(false);
			
			
			if(session == null && hReq.getRequestedSessionId() != null && !hReq.isRequestedSessionIdValid()
			   && esRecursoAsegurado(hReq.getRequestURI())){
				
				loggerSAFI.debug("Session Invalida." + Constantes.SALTO_LINEA + 
						"Contexto: " + hReq.getContextPath() + Constantes.SALTO_LINEA + 
						"Pagina Solicitada: " + hReq.getRequestURL() + Constantes.SALTO_LINEA +
						"URI Solicitada: "+hReq.getRequestURI() + Constantes.SALTO_LINEA + 
						"HttpSession: " + session + Constantes.SALTO_LINEA + 
						"RequestedSessionId: " + hReq.getRequestedSessionId() + Constantes.SALTO_LINEA + 
						"IsRequestedSessionIdValid: " + hReq.isRequestedSessionIdValid());
				String targetUrl = hReq.getContextPath() + expiredUrl;
				//hRes.sendRedirect(hRes.encodeRedirectURL(targetUrl));
				return;
			}
			chain.doFilter(req,res);
		}
	}
	
	private boolean esRecursoAsegurado(String urlSolicitada) throws IOException{
		boolean esAsegurado = true;
		StringTokenizer tokensBean = new StringTokenizer(urlSolicitada, "/");
		String stringToken;
		while(tokensBean.hasMoreTokens()){
			stringToken = tokensBean.nextToken();
						
			if(stringToken.equalsIgnoreCase("images") ||
			   stringToken.equalsIgnoreCase("css") ||
			   stringToken.equalsIgnoreCase("js")){
					esAsegurado = false;					
					return esAsegurado;					
			}else if (stringToken.equalsIgnoreCase("")){
				esAsegurado = false;
				return esAsegurado;				
			}else if(stringToken.equalsIgnoreCase("entradaAplicacion.htm") ||
					   stringToken.equalsIgnoreCase("cerrarSessionUsuarios.htm") ||
					   stringToken.equalsIgnoreCase("accesoDenegado.htm")||
					   stringToken.equalsIgnoreCase("sesionExpiradaConcurrente.htm") ||
					   stringToken.equalsIgnoreCase("capturaOpInusualesVista.htm") ||
					   stringToken.equalsIgnoreCase("capturaOpIntPreocupantesVista.htm") ||
					   stringToken.equalsIgnoreCase("invalidaSession.htm")){
				esAsegurado = false;
				return esAsegurado;
			}
		}
		return esAsegurado;
	}
	
	public void init(FilterConfig config) throws ServletException {	}

	public void afterPropertiesSet() throws Exception {
	}

	public void setExpiredUrl(String expiredUrl) {
		this.expiredUrl = expiredUrl;
	}


}
