
package credito.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import credito.bean.CreditoDevGLBean;
import credito.dao.CreditoDevGLDAO;


public class CreditoDevGLServicio extends BaseServicio {

	
	//---------- Variables ------------------------------------------------------------------------
	CreditoDevGLDAO creditoDevGLDAO = null;			
	
	//------------Constantes------------------
	 
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_CreditoDevGL {
		int principal 			= 1;
				
	}
		
	
	public CreditoDevGLServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public CreditoDevGLBean consulta(int tipoConsulta, CreditoDevGLBean creditoDevGLBean){
		CreditoDevGLBean creditoDevGL= null;
		switch (tipoConsulta) {
			case Enum_Con_CreditoDevGL.principal:		
				creditoDevGL = creditoDevGLDAO.consultaPrincipal(creditoDevGLBean, tipoConsulta);				
				break;	
		}
		return creditoDevGL;
	}


	public CreditoDevGLDAO getCreditoDevGLDAO() {
		return creditoDevGLDAO;
	}


	public void setCreditoDevGLDAO(CreditoDevGLDAO creditoDevGLDAO) {
		this.creditoDevGLDAO = creditoDevGLDAO;
	}
	

	
	

	
	
}

