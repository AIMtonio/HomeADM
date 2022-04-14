package tarjetas.servicio;

import java.util.ArrayList;
import java.util.List;

import tarjetas.dao.TarDebConciliaCorrespDAO;
import tarjetas.bean.TarDebConciliaCorrespBean;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class TarDebConciliaCorrespServicio extends BaseServicio {
	
	TarDebConciliaCorrespDAO	tarDebConciliaCorrespDAO	= null;
	
	public TarDebConciliaCorrespServicio() {
		super();
	}
	
	public static interface Enum_Tra_Movs {
		int	concilia	= 1;
		int	fraude		= 2;
	}
	
	public static interface Enum_Con_MovsGrid {
		int	principal	= 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(TarDebConciliaCorrespBean tarDebConciliaCorrespBean, int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ArrayList listaBean = (ArrayList) listaGrid(tarDebConciliaCorrespBean);
		
		switch (tipoTransaccion) {
			case Enum_Tra_Movs.concilia :
				mensaje = tarDebConciliaCorrespDAO.grabaConcilia(listaBean, tipoTransaccion);
				break;
		}
		return mensaje;
		
	}
	
	// lista de parametros del grid
	public List listaGrid(TarDebConciliaCorrespBean tarDebConciliaCorrespBean) {
		
		List<String> numAutorizacionLis = tarDebConciliaCorrespBean.getLisNumAutorizacion();
		List<String> fechaConsumoLis = tarDebConciliaCorrespBean.getLisFechaConsumo();
		List<String> conciliaIDLis = tarDebConciliaCorrespBean.getLisConciliaID();
		List<String> detalleIDLis = tarDebConciliaCorrespBean.getLisDetalleID();
		List<String> tipoOperacionLis = tarDebConciliaCorrespBean.getLisTipoOperacion();
		List<String> descTipoOperacionLis = tarDebConciliaCorrespBean.getLisDescTipoOperacion();
		List<String> numCuentaLis = tarDebConciliaCorrespBean.getLisNumCuenta();
		List<String> montoLis = tarDebConciliaCorrespBean.getLisMonto();
		List<String> estatusConciliaLis = tarDebConciliaCorrespBean.getLisEstatusConci();
		
		ArrayList listaDetalle = new ArrayList();
		TarDebConciliaCorrespBean tarDebCorresp = null;
		if (conciliaIDLis != null) {
			try {
				
				int tamanio = conciliaIDLis.size();
				for (int i = 0; i < tamanio; i++) {
					
					tarDebCorresp = new TarDebConciliaCorrespBean();
					
					tarDebCorresp.setNumAutorizacion(numAutorizacionLis.get(i));
					tarDebCorresp.setFechaConsumo(fechaConsumoLis.get(i));
					tarDebCorresp.setConciliaID(conciliaIDLis.get(i));
					tarDebCorresp.setDetalleID(detalleIDLis.get(i));
					tarDebCorresp.setTipoOperacion(tipoOperacionLis.get(i));
					tarDebCorresp.setDescTipoOperacion(descTipoOperacionLis.get(i));
					tarDebCorresp.setNumCuenta(numCuentaLis.get(i));
					tarDebCorresp.setMonto(montoLis.get(i));
					tarDebCorresp.setEstatusConci(estatusConciliaLis.get(i));
					
					listaDetalle.add(i, tarDebCorresp);
				}
				
			} catch (Exception e) {
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en lista de registros para conciliar", e);
			}
		}
		return listaDetalle;
	}
	
	public List movsTarjetas(int tipoLista, TarDebConciliaCorrespBean tarDebMovsBean) {
		List listaMov = null;
		switch (tipoLista) {
			case Enum_Con_MovsGrid.principal :
				listaMov = tarDebConciliaCorrespDAO.listaConsultaMovs(tarDebMovsBean, tipoLista);
				break;
		}
		return listaMov;
	}
	
	public TarDebConciliaCorrespDAO getTarDebConciliaCorrespDAO() {
		return tarDebConciliaCorrespDAO;
	}
	public void setTarDebConciliaCorrespDAO(TarDebConciliaCorrespDAO tarDebConciliaCorrespDAO) {
		this.tarDebConciliaCorrespDAO = tarDebConciliaCorrespDAO;
	}
	
}