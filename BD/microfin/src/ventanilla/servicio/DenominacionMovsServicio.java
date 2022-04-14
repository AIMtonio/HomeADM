package ventanilla.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import ventanilla.bean.DenominacionMovsBean;
import ventanilla.dao.DenominacionMovsDAO;

public class DenominacionMovsServicio extends BaseServicio {
	public DenominacionMovsServicio(){
		super();
	}
	DenominacionMovsDAO denominacionMovsDAO = null;
	public static interface Enum_Con_CajasVentanilla{
		int principal 	= 1;
		int fecha 		= 2;
	}
	
	//consulta Cajas Ventanilla
		public DenominacionMovsBean consulta(int tipoConsulta, DenominacionMovsBean denominacionMovsBean){
			DenominacionMovsBean denominacionMovs = null;
			switch(tipoConsulta){
				case Enum_Con_CajasVentanilla.principal:
					denominacionMovs = denominacionMovsDAO.consultaPrincipal(denominacionMovsBean, tipoConsulta);
				break;
				case Enum_Con_CajasVentanilla.fecha:
					denominacionMovs = denominacionMovsDAO.consultaFecha(denominacionMovsBean, tipoConsulta);
				break;
			}
			return denominacionMovs;
		}

		public DenominacionMovsDAO getDenominacionMovsDAO() {
			return denominacionMovsDAO;
		}

		public void setDenominacionMovsDAO(DenominacionMovsDAO denominacionMovsDAO) {
			this.denominacionMovsDAO = denominacionMovsDAO;
		}
}
