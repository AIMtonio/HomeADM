package ventanilla.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import ventanilla.bean.RemesasPagadasBean;
import ventanilla.dao.RemesasPagadasDAO;

public class RemesasPagadasServicio extends BaseServicio {
	RemesasPagadasDAO remesasPagadasDAO = null;

	public RemesasPagadasDAO getRemesasPagadasDAO() {
		return remesasPagadasDAO;
	}

	public void setRemesasPagadasDAO(RemesasPagadasDAO remesasPagadasDAO) {
		this.remesasPagadasDAO = remesasPagadasDAO;
	}

	public static interface Enum_Consulta_RemesasPagadas {
		int consultaGeneral = 2;
		int salidaEfectivo = 3;
		int consultaGeneralLista = 4;
	}
	
	public List<RemesasPagadasBean> consulta(int tipoConsulta, String referencia){
		List listaRespuesta = null;
		switch (tipoConsulta) {
		case 1:
			listaRespuesta = consultaPorReferencia(referencia);
			break;
		case 2:
			listaRespuesta = consultaSalidaEfectivo(referencia);
			break;
		}
		return listaRespuesta;
	}

	public List<RemesasPagadasBean> lista(String referenciaRemesa) {
		return remesasPagadasDAO.consultaReremesas(referenciaRemesa, Enum_Consulta_RemesasPagadas.consultaGeneralLista);
	}
	
	private List<RemesasPagadasBean> consultaPorReferencia(String referenciaRemesa) {
		List<RemesasPagadasBean> resultadoConsulta =remesasPagadasDAO.consultaReremesas(referenciaRemesa, Enum_Consulta_RemesasPagadas.consultaGeneral);
		return resultadoConsulta.isEmpty() ? null : resultadoConsulta;
	}

	private List<RemesasPagadasBean> consultaSalidaEfectivo(String referenciaRemesa) {
		return remesasPagadasDAO.consultaReremesas(referenciaRemesa, Enum_Consulta_RemesasPagadas.salidaEfectivo);
	}
	
	public MensajeTransaccionBean reimpresionPagoRemesa(String referencia){
		return remesasPagadasDAO.reimpresionPagoRemesa(referencia);
	}

}
