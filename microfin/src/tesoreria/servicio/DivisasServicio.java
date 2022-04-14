package tesoreria.servicio;

import java.util.List;

import pld.servicio.NivelRiesgoClienteServicio.Enum_Tipo_Reporte;
import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;
import general.servicio.BaseServicio;
import tesoreria.bean.DivisasBean;
import tesoreria.dao.DivisasDAO;

public class DivisasServicio extends BaseServicio {
	
	DivisasDAO	divisasDAO	= null;
	
	public static interface Enum_Tra_Divisa {
		int	alta			= 1;
		int	modificacion	= 2;
		int	elimina			= 3;
		
	}
	public static interface Enum_Tra_Consulta {
		int	principal	= 3;
		
	}
	
	public static interface Enum_Tipo_Reporte {
		int	historico	= 1;
	}
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, DivisasBean divisaBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Divisa.alta :
				mensaje = divisasDAO.altaMoneda(divisaBean);
				break;
			case Enum_Tra_Divisa.modificacion :
				mensaje = divisasDAO.ModificaMoneda(divisaBean);
				break;
		}
		return mensaje;
	}
	
	public DivisasBean consultaExisteDivisa(int tipoConsulta, DivisasBean divisasBean) {
		
		DivisasBean divisa = null;
		
		switch (tipoConsulta) {
		
			case Enum_Tra_Consulta.principal :
				divisa = divisasDAO.consultaExisteMoneda(divisasBean, tipoConsulta);
				break;
		}
		return divisa;
	}
	
	public List<DivisasBean> listaReporte(DivisasBean bean, int tipoReporte) {
		List<DivisasBean> lista = null;
		switch (tipoReporte) {
			case Enum_Tipo_Reporte.historico :
				lista = divisasDAO.listaReporte(bean, Enum_Tipo_Reporte.historico);
		}
		return lista;
	}
	
	public void setDivisasDAO(DivisasDAO divisasDAO) {
		this.divisasDAO = divisasDAO;
	}
	
	public DivisasDAO getDivisasDAO() {
		return divisasDAO;
	}
	
}
