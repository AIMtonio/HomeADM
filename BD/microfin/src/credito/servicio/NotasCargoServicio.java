package credito.servicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import credito.bean.NotasCargoBean;
import credito.bean.NotasCargoRepBean;
import credito.dao.NotasCargoDAO;
import general.servicio.BaseServicio;

public class NotasCargoServicio extends BaseServicio {

	private NotasCargoDAO notasCargoDAO = null;

	private NotasCargoServicio(){
		super();
	}

	public static interface Enum_Tra_NotaCargo {
		int notasPagosNoReconocidos = 1;
		int notaIndividual = 2;
	}

	public static interface Enum_Con_NotaCargo {
		int consultaAmortizacion = 1;
	}

	public static interface Enum_Lis_NotaCargo {
		int listaGrid = 1;
	}

	public static interface Enum_Reporte_NotasCargo{
		int notasCargoExcel = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, NotasCargoBean notasCargoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
		case Enum_Tra_NotaCargo.notasPagosNoReconocidos:
			mensaje = notasCargoDAO.altaNotasPagosNoReconocidos(notasCargoBean, (ArrayList<NotasCargoBean>) detalleGrid(notasCargoBean));
			break;
		case Enum_Tra_NotaCargo.notaIndividual:
			mensaje = notasCargoDAO.altaNotaCargoIndividual(notasCargoBean);
			break;
		}
		return mensaje;
	}

	public NotasCargoBean consulta(int tipoConsulta, NotasCargoBean notasCargoBean) {
		NotasCargoBean beanConsulta = null;
		switch(tipoConsulta) {
			case Enum_Con_NotaCargo.consultaAmortizacion:
				beanConsulta = notasCargoDAO.consultaAmortizacion(notasCargoBean, tipoConsulta);
				break;
		}
		return beanConsulta;
	}

	public List<?> lista(int tipoLista, NotasCargoBean notasCargoBean) {
		List<?> resultado = null;
		switch (tipoLista) {
			case Enum_Lis_NotaCargo.listaGrid:
				resultado = notasCargoDAO.listaGrid(tipoLista, notasCargoBean);
				break;
			case Enum_Reporte_NotasCargo.notasCargoExcel:
				resultado = notasCargoDAO.listaNotasCargo(notasCargoBean, tipoLista);
				break;
		}
		return resultado;
	}

	private List<NotasCargoBean> detalleGrid(NotasCargoBean beanEntrada) {
		// Separa las listas del grid en beans individuales
		List<String> listaAmortizacionID	= beanEntrada.getListaAmortizacionID();
		List<String> listaCapital			= beanEntrada.getListaCapital();
		List<String> listaInteresOrd		= beanEntrada.getListaInteresOrd();
		List<String> listaIvaInteres		= beanEntrada.getListaIvaInteres();
		List<String> listaMoratorio			= beanEntrada.getListaMoratorio();
		List<String> listaIvaMoratorio		= beanEntrada.getListaIvaMoratorio();
		List<String> listaOtrasComisiones	= beanEntrada.getListaOtrasComisiones();
		List<String> listaIvaComisiones		= beanEntrada.getListaIvaComisiones();
		List<String> listaTotalPago			= beanEntrada.getListaTotalPago();
		List<String> listaCheck				= beanEntrada.getListaCheck();
		List<String> listaTranPagoCredito	= beanEntrada.getListaTranPagoCredito();

		ArrayList<NotasCargoBean> listaDetalle = new ArrayList<NotasCargoBean>();

		NotasCargoBean iterBean = null;
		int tamanio = 0;
		if(listaAmortizacionID != null){
			tamanio = listaAmortizacionID.size();
		}

		for(int fila = 0; fila < tamanio; fila++) {
			String estaSeleccionado = listaCheck.get(fila);
			if (estaSeleccionado.equals("S")){
				iterBean = new NotasCargoBean();
				iterBean.setAmortizacionID(beanEntrada.getAmortizacionID());
				iterBean.setCapital(listaCapital.get(fila));
				iterBean.setInteresOrd(listaInteresOrd.get(fila));
				iterBean.setIvaInteres(listaIvaInteres.get(fila));
				iterBean.setMoratorio(listaMoratorio.get(fila));
				iterBean.setIvaMoratorio(listaIvaMoratorio.get(fila));
				iterBean.setOtrasComisiones(listaOtrasComisiones.get(fila));
				iterBean.setIvaComisiones(listaIvaComisiones.get(fila));
				iterBean.setTotalPago(listaTotalPago.get(fila));
				iterBean.setTranPagoCredito(listaTranPagoCredito.get(fila));
				iterBean.setAmortizacionPago(listaAmortizacionID.get(fila));
				iterBean.setCreditoID(beanEntrada.getCreditoID());
				listaDetalle.add(iterBean);
			}
		}
		return listaDetalle;
	}

	public List<NotasCargoRepBean> consultaReporteNotasCargo(int tipoLista, NotasCargoBean notasCargoBean, HttpServletResponse respon){
		List<NotasCargoRepBean> listaNotasCargoRep = null;
		switch(tipoLista){
			case Enum_Reporte_NotasCargo.notasCargoExcel:
				listaNotasCargoRep = notasCargoDAO.listaNotasCargo(notasCargoBean, tipoLista);
			break;
		}
		return listaNotasCargoRep;
	}

	public NotasCargoDAO getNotasCargoDAO() {
		return notasCargoDAO;
	}

	public void setNotasCargoDAO(NotasCargoDAO notasCargoDAO) {
		this.notasCargoDAO = notasCargoDAO;
	}
}